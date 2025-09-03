from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from sqlalchemy.orm import selectinload


from . import schemas
from .database import models
from .auth import get_password_hash
from typing import List


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
    """Return a single community with posts + comments + members (with eager loading)."""
    result = await db.execute(
        select(models.Community)
        .options(
            selectinload(models.Community.posts).selectinload(models.Post.author),
            selectinload(models.Community.posts).selectinload(models.Post.community),
            selectinload(models.Community.posts)
            .selectinload(models.Post.comments)
            .selectinload(models.Comment.author),
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
    return


async def get_posts_for_community(db: AsyncSession, community_id: int):
    result = await db.execute(
        select(models.Post)
        .options(
            selectinload(models.Post.author),
            selectinload(models.Post.community),
            selectinload(models.Post.comments),
        )
        .filter(models.Post.community_id == community_id)
        .order_by(models.Post.created_at.desc())
    )
    return result.scalars().all()


async def get_post_details(db: AsyncSession, post_id: int):
    result = await db.execute(
        select(models.Post)
        .options(
            selectinload(models.Post.author),
            selectinload(models.Post.community),
            selectinload(models.Post.comments).selectinload(models.Comment.author),
        )
        .filter(models.Post.id == post_id)
    )
    return result.scalars().first()


# -------------------------------
# 1) Comment Crud
# -------------------------------
async def create_post_comment(
    db: AsyncSession, comment: schemas.CommentCreate, post_id: int, user_id: int
) -> schemas.Comment:
    # Create the comment
    db_comment = models.Comment(
        **comment.model_dump(), post_id=post_id, user_id=user_id
    )
    db.add(db_comment)
    await db.commit()

    # Eager-load the author to avoid MissingGreenlet
    await db.refresh(db_comment, attribute_names=["author"])

    # Return Pydantic model
    return schemas.Comment.model_validate(db_comment)


async def get_comments_for_post(
    db: AsyncSession, post_id: int
) -> list[schemas.Comment]:
    result = await db.execute(
        select(models.Comment)
        .options(selectinload(models.Comment.author))  # Eager-load author
        .where(models.Comment.post_id == post_id)
        .order_by(models.Comment.created_at.asc())
    )
    comments = result.scalars().all()

    # Convert each comment to Pydantic model
    return [schemas.Comment.model_validate(c) for c in comments]


# -------------------------------
# Vote CRud
# -------------------------------
async def apply_vote(
    db: AsyncSession, post_id: int, user_id: int, vote_type: models.VoteType
) -> schemas.Post | None:
    # Get the post with eager-loaded relationships
    result = await db.execute(
        select(models.Post)
        .options(
            selectinload(models.Post.author),
            selectinload(models.Post.community),
            selectinload(models.Post.comments).selectinload(models.Comment.author),
        )
        .where(models.Post.id == post_id)
    )
    post = result.scalar_one_or_none()
    if not post:
        return None

    # Check existing vote
    result = await db.execute(
        select(models.Vote).filter_by(post_id=post_id, user_id=user_id)
    )
    existing_vote = result.scalar_one_or_none()

    # Apply vote logic
    if existing_vote:
        if existing_vote.vote_type == vote_type:
            post.votes -= vote_type.value
            await db.delete(existing_vote)
        else:
            post.votes += 2 * vote_type.value
            existing_vote.vote_type = vote_type
    else:
        post.votes += vote_type.value
        new_vote = models.Vote(post_id=post_id, user_id=user_id, vote_type=vote_type)
        db.add(new_vote)

    await db.commit()
    await db.refresh(post)

    # Return Pydantic model
    return schemas.Post.model_validate(post)


# -------------------------------
# Get user by username with communities
# -------------------------------
async def get_user_by_username_with_communities(db: AsyncSession, username: str):
    """
    Fetch a user by username and eagerly load their communities.
    Returns a Pydantic model to be returned safely from FastAPI.
    """
    result = await db.execute(
        select(models.User)
        .options(selectinload(models.User.communities))
        .filter(models.User.username == username)
    )
    user = result.scalars().first()

    return user


# -------------------------------
# Get home feed for a user
# -------------------------------
async def get_home_feed_for_user(
    db: AsyncSession, user: models.User
) -> List[schemas.Post]:
    """
    Fetch recent posts from communities the user has joined.
    Returns a list of Pydantic Post models with nested relationships.
    """
    # Ensure communities are eagerly loaded
    if not hasattr(user, "communities") or user.communities is None:
        await db.refresh(user, attribute_names=["communities"])

    joined_community_ids = [c.id for c in user.communities]
    if not joined_community_ids:
        return []

    result = await db.execute(
        select(models.Post)
        .options(
            selectinload(models.Post.author),
            selectinload(models.Post.community),
            selectinload(models.Post.comments).selectinload(models.Comment.author),
        )
        .filter(models.Post.community_id.in_(joined_community_ids))
        .order_by(models.Post.created_at.desc())
        .limit(100)
    )

    posts = result.scalars().all()
    # Convert all posts to Pydantic models
    return [schemas.Post.model_validate(p) for p in posts]
