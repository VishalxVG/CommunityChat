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


post_actions_router = APIRouter(prefix="/api/posts", tags=["posts-actions"])


# -------------------------------
# 1) Create Comment
# -------------------------------
@post_actions_router.post(
    "/{post_id}/comments",
    response_model=schemas.Comment,
    status_code=status.HTTP_201_CREATED,
)
async def create_comment(
    post_id: int,
    comment: schemas.CommentCreate,
    db: AsyncSession = Depends(get_db),
    current_user: models.User = Depends(auth.get_current_user),
):
    # Create the comment via CRUD function (author eagerly loaded)
    db_comment = await crud.create_post_comment(db, comment, post_id, current_user.id)
    return db_comment


# -------------------------------
# 2) Get Comments for a Post
# -------------------------------
@post_actions_router.get("/{post_id}/comments", response_model=List[schemas.Comment])
async def get_comments(
    post_id: int,
    db: AsyncSession = Depends(get_db),
):
    comments = await crud.get_comments_for_post(db, post_id)
    return comments


# -------------------------------
# 3) Vote on a Post
# -------------------------------
@post_actions_router.post("/{post_id}/vote", response_model=schemas.Post)
async def vote_on_post(
    post_id: int,
    vote: schemas.VoteCreate,
    db: AsyncSession = Depends(get_db),
    current_user: models.User = Depends(auth.get_current_user),
):
    # Apply vote (updates post.votes)
    updated_post = await crud.apply_vote(db, post_id, current_user.id, vote.vote_type)
    if not updated_post:
        raise HTTPException(status_code=404, detail="Post not found")

    # Reload post with all relationships eagerly loaded for response
    post_detail = await crud.get_post_details(db, updated_post.id)
    if not post_detail:
        raise HTTPException(status_code=404, detail="Post not found after reload")

    return post_detail
