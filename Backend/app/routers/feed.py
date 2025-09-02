from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import selectinload
from typing import List
from app import crud, schemas, auth
from ..database import models
from app.database.session import get_db

router = APIRouter()


@router.get("/api/feed", response_model=List[schemas.Post])
async def read_home_feed(
    db: AsyncSession = Depends(get_db),
    current_user: models.User = Depends(auth.get_current_user),
):
    """
    Returns a feed of posts from communities the current user has joined.
    """
    result = await db.execute(
        select(models.User)
        .options(selectinload(models.User.communities))
        .filter(models.User.id == current_user.id)
    )
    user = result.scalars().first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    # Now user.communities is fully loaded, safe to access
    posts = await crud.get_home_feed_for_user(db, user=user)
    return posts
