from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from typing import List

from app import crud, schemas, auth
from app.database.session import get_db
from ..database import models


# -------------------------------
# Protected routes (auth required)
# -------------------------------
router = APIRouter(
    prefix="/api/communities",
    tags=["communities"],
    dependencies=[Depends(auth.get_current_user)],  # Protect all routes here
)


@router.post(
    "/", response_model=schemas.CommunityDetail, status_code=status.HTTP_201_CREATED
)
async def create_community(
    community: schemas.CommunityCreate,
    db: AsyncSession = Depends(get_db),
    current_user: schemas.User = Depends(auth.get_current_user),
):
    # db_community = await crud.get_community_by_name(db, name=community.name)
    # if db_community:
    #     raise HTTPException(
    #         status_code=status.HTTP_400_BAD_REQUEST,
    #         detail="Community name already registered",
    #     )

    new_community = await crud.create_community(
        db=db, community=community, user_id=current_user.id
    )
    # Refresh with members/posts so schema works correctly
    return await crud.get_community(db, new_community.id)


@router.post("/{community_id}/join", response_model=schemas.CommunityDetail)
async def join_community(
    community_id: int,
    db: AsyncSession = Depends(get_db),
    current_user: models.User = Depends(auth.get_current_user),
):
    db_community = await crud.join_community(
        db=db, community_id=community_id, user_id=current_user.id
    )
    if db_community is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="Community not found"
        )

    # Refresh to include updated members
    return await crud.get_community(db, community_id)


# -------------------------------
# Public routes (no auth required)
# -------------------------------
public_router = APIRouter(prefix="/api/communities", tags=["communities"])


@public_router.get("/", response_model=List[schemas.CommunitySimple])
async def read_communities(
    skip: int = 0, limit: int = 100, db: AsyncSession = Depends(get_db)
):
    communities = await crud.get_communities(db, skip=skip, limit=limit)
    return communities


@public_router.get("/{community_id}", response_model=schemas.CommunityDetail)
async def read_community(community_id: int, db: AsyncSession = Depends(get_db)):
    db_community = await crud.get_community(db, community_id=community_id)
    if db_community is None:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="Community not found"
        )
    return db_community
