from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
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
