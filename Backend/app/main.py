from fastapi import FastAPI
from app.routers import feed, users, communities, posts

app = FastAPI(
    title="Community Chat App",
    description="A backend service for managing users, posts, and communities.",
    version="1.0.0",
)

# User routes
app.include_router(users.router, tags=["users"])

# Community routes
app.include_router(communities.router)  # Protected community routes
app.include_router(communities.public_router)  # Public community routes

# Post routes
app.include_router(posts.router, tags=["posts"])
app.include_router(posts.public_router)
app.include_router(posts.post_actions_router)

# Feed Routers
app.include_router(feed.router, tags=["feed"])


@app.get("/", tags=["root"])
async def root():
    return {"message": "Welcome to the Community Chat App API"}
