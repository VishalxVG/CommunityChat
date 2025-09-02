from pydantic import BaseModel
from datetime import datetime
from typing import List, Optional


# -------------------------------
# User Schemas
# -------------------------------
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


# -------------------------------
# Token Schemas
# -------------------------------
class Token(BaseModel):
    access_token: str
    token_type: str


class TokenData(BaseModel):
    username: Optional[str] = None


# -------------------------------
# Post Schemas
# -------------------------------
class PostBase(BaseModel):
    title: str
    content: Optional[str] = None


class PostCreate(PostBase):
    pass


class Post(PostBase):
    id: int
    user_id: int
    community_id: int
    created_at: datetime
    votes: int
    author: User  # Nested User schema
    community: "CommunitySimple"  # Forward reference

    class Config:
        orm_mode = True


# -------------------------------
# Community Schemas
# -------------------------------
class CommunityBase(BaseModel):
    name: str
    description: str


class CommunityCreate(CommunityBase):
    pass


class CommunitySimple(BaseModel):
    id: int
    name: str

    class Config:
        orm_mode = True


class CommunityDetail(CommunityBase):
    id: int
    created_by: int
    posts: List[Post] = []
    member_count: int  # <-- Computed in CRUD

    class Config:
        orm_mode = True


# -------------------------------
# Resolve forward refs
# -------------------------------
Post.model_rebuild()
CommunitySimple.model_rebuild()
CommunityDetail.model_rebuild()
