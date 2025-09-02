from pydantic import BaseModel
from datetime import datetime
from typing import List, Optional


class UserCreate(BaseModel):
    username: str
    email: str
    password: str


class User(BaseModel):
    id: int
    username: str
    email: str
    created_at: datetime

    class Config:
        orm_mode = True


class Token(BaseModel):
    access_token: str
    token_type: str


class TokenData(BaseModel):
    username: str | None = None


class Post(BaseModel):
    id: int
    title: str
    content: Optional[str] = None
    user_id: int
    community_id: int
    created_at: datetime
    votes: int

    class Config:
        orm_mode = True


class CommunityBase(BaseModel):
    name: str
    description: str


class CommunityCreate(CommunityBase):
    pass


class Community(CommunityBase):
    id: int
    created_by: int
    # This matches the frontend's need to show posts on the community details screen
    # posts: List[Post] = []

    class Config:
        orm_mode = True
