from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from sqlalchemy.orm import selectinload
from sqlalchemy import func

from . import schemas
from .database import models
from .auth import get_password_hash


# -------------------------------
# User CRUD
# -------------------------------
async def get_user_by_email(db: AsyncSession, email: str):
    result = await db.execute(select(models.User).filter(models.User.email == email))
    return result.scalars().first()


async def get_user_by_username(db: AsyncSession, username: str):
    result = await db.execute(
        select(models.User).filter(models.User.username == username)
    )
    return result.scalars().first()


async def create_user(db: AsyncSession, user: schemas.UserCreate):
    hashed_password = get_password_hash(user.password)
    db_user = models.User(
        email=user.email,
        username=user.username,
        password_hash=hashed_password,
    )
    db.add(db_user)
    await db.commit()
    await db.refresh(db_user)
    return db_user


# -------------------------------
# Community CRUD
# -------------------------------
async def get_community_by_name(db: AsyncSession, name: str):
    result = await db.execute(
        select(models.Community).filter(models.Community.name == name)
    )
    return result.scalars().first()


async def get_communities(db: AsyncSession, skip: int = 0, limit: int = 100):
    result = await db.execute(select(models.Community).offset(skip).limit(limit))
    return result.scalars().all()


async def get_community(db: AsyncSession, community_id: int):
    """Return a single community with posts + computed member_count."""
    result = await db.execute(
        select(models.Community)
        .options(
            selectinload(models.Community.posts).selectinload(models.Post.author),
            selectinload(models.Community.posts).selectinload(models.Post.community),
            selectinload(models.Community.members),
        )
        .filter(models.Community.id == community_id)
    )
    community = result.scalars().first()

    if community:
        # Compute member_count explicitly
        community.member_count = len(community.members)

    return community


async def create_community(
    db: AsyncSession, community: schemas.CommunityCreate, user_id: int
):
    db_community = models.Community(
        **community.model_dump(),
        created_by=user_id,
    )
    db.add(db_community)
    await db.commit()
    await db.refresh(db_community)
    return db_community


async def join_community(db: AsyncSession, community_id: int, user_id: int):
    result = await db.execute(
        select(models.User)
        .options(selectinload(models.User.communities))  # 👈 eager load
        .filter(models.User.id == user_id)
    )
    user = result.scalars().first()

    community = await db.get(models.Community, community_id)

    user.communities.append(community)  # ✅ safe now
    await db.commit()
    return community


# -------------------------------
# Post CRUD
# -------------------------------
async def create_community_post(
    db: AsyncSession, post: schemas.PostCreate, user_id: int, community_id: int
):
    db_post = models.Post(
        **post.model_dump(),
        user_id=user_id,
        community_id=community_id,
    )
    db.add(db_post)
    await db.commit()
    await db.refresh(db_post)
    return db_post
