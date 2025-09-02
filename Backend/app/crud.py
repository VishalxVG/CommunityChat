from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from sqlalchemy.orm import selectinload
from . import schemas
from .database import models
from .auth import get_password_hash


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
        email=user.email, username=user.username, password_hash=hashed_password
    )
    db.add(db_user)
    await db.commit()
    await db.refresh(db_user)
    return db_user


async def get_community_by_name(db: AsyncSession, name: str):
    result = await db.execute(
        select(models.Community).filter(models.Community.name == name)
    )
    return result.scalars().first()


async def get_communities(db: AsyncSession, skip: int = 0, limit: int = 100):
    result = await db.execute(select(models.Community).offset(skip).limit(limit))
    return result.scalars().all()


async def get_community(db: AsyncSession, community_id: int):
    result = await db.execute(
        select(models.Community)
        .options(selectinload(models.Community.posts))
        .filter(models.Community.id == community_id)
    )
    return result.scalars().first()


async def create_community(
    db: AsyncSession, community: schemas.CommunityCreate, user_id: int
):
    db_community = models.Community(**community.model_dump(), created_by=user_id)
    db.add(db_community)
    await db.commit()
    await db.refresh(db_community)
    return db_community
