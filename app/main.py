from __future__ import annotations

from fastapi import FastAPI, Request
from fastapi.responses import JSONResponse
from pydantic import BaseModel, ConfigDict, Field

from app.orchestrator import Orchestrator

app = FastAPI(title="multiagent-azure", version="0.1.0")
orchestrator = Orchestrator.default()
MAX_REQUEST_BODY_BYTES = 64 * 1024


class TriageRequest(BaseModel):
    model_config = ConfigDict(extra="forbid")
    case_text: str = Field(min_length=1, max_length=10000)
    role: str = Field(default="malware_analyst", min_length=1, max_length=128)
    tool_name: str | None = Field(default=None, max_length=256)


@app.middleware("http")
async def request_size_guard(request: Request, call_next):
    content_length = request.headers.get("content-length")
    if content_length and content_length.isdigit():
        if int(content_length) > MAX_REQUEST_BODY_BYTES:
            return JSONResponse(
                status_code=413,
                content={"detail": f"Request body too large. Limit is {MAX_REQUEST_BODY_BYTES} bytes."},
            )
    return await call_next(request)


@app.get("/health")
async def health() -> dict:
    return {"status": "ok"}


@app.post("/triage")
async def triage(req: TriageRequest) -> dict:
    return await orchestrator.run_triage(req.case_text, role=req.role, tool_name=req.tool_name)
