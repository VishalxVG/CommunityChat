from sqlalchemy.ext.asyncio import create_async_engine, AsyncSession
from sqlalchemy.orm import sessionmaker
import asyncio
import os

DATABASE_URL = os.getenv("DATABASE_URL")

MAX_RETRIES = 10
WAIT_TIME = 3


async def create_engine_with_retry():
    for attempt in range(1, MAX_RETRIES + 1):
        try:
            engine = create_async_engine(DATABASE_URL, echo=True)
            # Test connection
            async with engine.begin() as conn:
                await conn.run_sync(lambda _: None)
            print("✅ Database connection successful!")
            return engine
        except Exception as e:
            print(f"❌ DB connection failed (attempt {attempt}/{MAX_RETRIES}): {e}")
            if attempt == MAX_RETRIES:
                raise e
            await asyncio.sleep(WAIT_TIME)


# Create engine asynchronously
engine = asyncio.get_event_loop().run_until_complete(create_engine_with_retry())

AsyncSessionLocal = sessionmaker(
    bind=engine, class_=AsyncSession, expire_on_commit=False
)


async def get_db():
    async with AsyncSessionLocal() as session:
        yield session
