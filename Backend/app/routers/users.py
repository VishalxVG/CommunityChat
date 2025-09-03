from typing import List
from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import OAuth2PasswordRequestForm
from sqlalchemy.ext.asyncio import AsyncSession
from app.database import models
from app.database.session import get_db
from app import crud, schemas, auth

router = APIRouter()


@router.post("/signup", response_model=schemas.User)
async def signUp(user: schemas.UserCreate, db: AsyncSession = Depends(get_db)):
    db_user = await crud.get_user_by_email(db, email=user.email)
    if db_user:
        raise HTTPException(status_code=400, detail="Email already registered")
    db_user_by_username = await crud.get_user_by_username(db, username=user.username)
    if db_user_by_username:
        raise HTTPException(status_code=400, detail="Username already Exists")
    return await crud.create_user(db=db, user=user)


@router.post("/login")
async def login(
    form_data: OAuth2PasswordRequestForm = Depends(), db: AsyncSession = Depends(get_db)
):
    user = await crud.get_user_by_username(db, username=form_data.username)
    if not user or not auth.verify_password(form_data.password, user.password_hash):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect username or password",
            headers={"WWW-Authenticate": "Bearer"},
        )
    access_token = auth.create_access_token(data={"sub": user.username})
    return {"access_token": access_token, "token_type": "bearer"}


@router.get("/api/users/me", response_model=schemas.UserDetail)
async def read_users_me(
    db: AsyncSession = Depends(get_db),
    current_user: models.User = Depends(auth.get_current_user),
):
    """
    Fetch the current logged in user with their joined communities.
    """
    user_with_communities = await crud.get_user_by_username_with_communities(
        db, username=current_user.username
    )
    if not user_with_communities:
        raise HTTPException(status_code=404, detail="User not found")

    return user_with_communities


@router.get("/api/users/me/posts", response_model=List[schemas.Post])
async def read_user_posts(
    db: AsyncSession = Depends(get_db),
    current_user: models.User = Depends(auth.get_current_user),
):
    """
    Fetch all posts for the current logged in user.
    """
    posts = await crud.get_posts_by_user(db, user_id=current_user.id)
    return posts
