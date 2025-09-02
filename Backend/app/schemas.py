from pydantic import BaseModel
from datetime import datetime
from typing import List, Optional

from app.database.models import VoteType


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

    model_config = {"from_attributes": True}


# -------------------------------
# Token Schemas
# -------------------------------
class Token(BaseModel):
    access_token: str
    token_type: str


class TokenData(BaseModel):
    username: Optional[str] = None


# -------------------------------
# Comment Schemas
# -------------------------------


class CommentBase(BaseModel):
    content: str


class CommentCreate(CommentBase):
    pass


class Comment(CommentBase):
    id: int
    post_id: int
    user_id: int
    created_at: datetime
    author: User

    model_config = {"from_attributes": True}


# -------------------------------
# Vote Schemas
# -------------------------------


class VoteCreate(BaseModel):
    vote_type: VoteType


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
    author: User
    community: "CommunitySimple"
    comments: List[Comment] = []

    model_config = {"from_attributes": True}


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

    model_config = {"from_attributes": True}


class CommunityDetail(CommunityBase):
    id: int
    created_by: int
    posts: List[Post] = []
    member_count: int  # <-- Computed in CRUD

    model_config = {"from_attributes": True}


# -------------------------------
# Resolve forward refs
# -------------------------------
Post.model_rebuild()
CommunitySimple.model_rebuild()
CommunityDetail.model_rebuild()
