from fastapi import FastAPI

app = FastAPI(title="Pallas FastAPI", version="0.1.0")


@app.get("/")
def read_root() -> dict[str, str]:
    return {"message": "Pallas FastAPI is running"}


@app.get("/health")
def health_check() -> dict[str, str]:
    return {"status": "ok"}
