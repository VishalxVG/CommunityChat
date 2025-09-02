from fastapi import FastAPI
from app.routers import users, communities

app = FastAPI()

app.include_router(users.router, tags=["users"])
app.include_router(communities.router, tags=["communities"])


@app.get("/")
async def root():
    return {"message": "Community Chat App"}
