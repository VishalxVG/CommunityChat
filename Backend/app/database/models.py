from sqlalchemy import Column, Integer, String, DateTime, ForeignKey, Table
from sqlalchemy.orm import relationship
from sqlalchemy.ext.declarative import declarative_base
from datetime import datetime


Base = declarative_base()

user_community_association = Table(
    "user_community",
    Base.metadata,
    Column("user_id", Integer, ForeignKey("users.id")),
    Column("community_id", Integer, ForeignKey("communities.id")),
)


class User(Base):
    __tablename__ = "users"
    id = Column(Integer, primary_key=True, index=True)
    username = Column(String, unique=True, index=True)
    email = Column(String, unique=True, index=True)
    password_hash = Column(String)
    created_at = Column(DateTime, default=datetime.utcnow)

    communities = relationship(
        "Community",
        secondary=user_community_association,
        back_populates="members",
    )
    posts = relationship("Post", back_populates="author")


class Community(Base):
    __tablename__ = "communities"
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, unique=True, index=True)
    description = Column(String)
    created_by = Column(Integer, ForeignKey("users.id"))
    created_at = Column(DateTime, default=datetime.utcnow)
    posts = relationship("Post", back_populates="community")

    members = relationship(
        "User",
        secondary=user_community_association,
        back_populates="communities",
    )


class Post(Base):
    __tablename__ = "posts"
    id = Column(Integer, primary_key=True, index=True)
    title = Column(String)
    content = Column(String, nullable=True)
    community_id = Column(Integer, ForeignKey("communities.id"))
    user_id = Column(Integer, ForeignKey("users.id"))
    votes = Column(Integer, default=0)
    created_at = Column(DateTime, default=datetime.utcnow)

    community = relationship("Community", back_populates="posts")
    comments = relationship("Comment", back_populates="post")

    author = relationship("User", back_populates="posts")


class Comment(Base):
    __tablename__ = "comments"
    id = Column(Integer, primary_key=True, index=True)
    post_id = Column(Integer, ForeignKey("posts.id"))
    user_id = Column(Integer, ForeignKey("users.id"))
    content = Column(String)
    created_at = Column(DateTime, default=datetime.utcnow)
    post = relationship("Post", back_populates="comments")
