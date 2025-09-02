from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.ext.asyncio import AsyncSession
from typing import List
from app import crud, schemas, auth
from app.database.session import get_db

router = APIRouter()


@router.post(
    "/communities/",
    response_model=schemas.Community,
    status_code=status.HTTP_201_CREATED,
)
async def create_community(
    community: schemas.CommunityCreate,
    db: AsyncSession = Depends(get_db),
    # This dependency protects only this specific endpoint
    current_user: schemas.User = Depends(auth.get_current_user),
):
    db_community = await crud.get_community_by_name(db, name=community.name)
    if db_community:
        raise HTTPException(status_code=400, detail="Community name already registered")
    return await crud.create_community(
        db=db, community=community, user_id=current_user.id
    )


@router.get("/communities/", response_model=List[schemas.Community])
async def read_communities(
    skip: int = 0, limit: int = 100, db: AsyncSession = Depends(get_db)
):
    # This endpoint has no auth dependency, so it's public.
    communities = await crud.get_communities(db, skip=skip, limit=limit)
    return communities


@router.get("/communities/{community_id}", response_model=schemas.Community)
async def read_community(community_id: int, db: AsyncSession = Depends(get_db)):
    # This endpoint is also public.
    db_community = await crud.get_community(db, community_id=community_id)
    if db_community is None:
        raise HTTPException(status_code=404, detail="Community not found")
    return db_community
