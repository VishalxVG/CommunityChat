# app/routers/posts.py

from typing import List
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy import select
from sqlalchemy.orm import selectinload
from app import crud, schemas, auth
from app.database.session import get_db
from app.database import models
from ..schemas import Post

router = APIRouter(prefix="/api/communities", tags=["posts"])


@router.post(
    "/{community_id}/posts",
    response_model=schemas.Post,
    status_code=status.HTTP_201_CREATED,
)
async def create_post_for_community(
    community_id: int,
    post_in: schemas.PostCreate,
    db: AsyncSession = Depends(get_db),
    current_user: models.User = Depends(auth.get_current_user),
):
    # 1) Community must exist
    community = await db.get(models.Community, community_id)
    if not community:
        raise HTTPException(status_code=404, detail="Community not found")

    # 2) Must be a member of the community
    membership_q = (
        select(models.user_community_association.c.user_id)
        .where(models.user_community_association.c.user_id == current_user.id)
        .where(models.user_community_association.c.community_id == community_id)
        .limit(1)
    )
    membership = (await db.execute(membership_q)).first()
    if not membership:
        raise HTTPException(
            status_code=403,
            detail="You must be a member of this community to post",
        )

    # 3) Create the post
    db_post = models.Post(
        title=post_in.title,
        content=post_in.content,
        community_id=community_id,
        user_id=current_user.id,
    )
    db.add(db_post)
    await db.commit()
    result = await db.execute(
        select(models.Post)
        .options(
            selectinload(models.Post.author),
            selectinload(models.Post.community),
            selectinload(models.Post.comments),
        )
        .where(models.Post.id == db_post.id)
    )
    post_with_relations = result.scalar_one()

    return post_with_relations


public_router = APIRouter(prefix="/api", tags=["posts"])


@public_router.get(
    "/communities/{community_id}/posts", response_model=List[schemas.Post]
)
async def read_posts_for_community(
    community_id: int, db: AsyncSession = Depends(get_db)
):
    posts = await crud.get_posts_for_community(db, community_id=community_id)
    return [Post.model_validate(post) for post in posts]
