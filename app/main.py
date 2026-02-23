from __future__ import annotations

from fastapi import FastAPI
from pydantic import BaseModel

from app.orchestrator import Orchestrator

app = FastAPI(title="multiagent-azure", version="0.1.0")
orchestrator = Orchestrator.default()


class TriageRequest(BaseModel):
    case_text: str
    role: str = "malware_analyst"
    tool_name: str | None = None


@app.get("/health")
async def health() -> dict:
    return {"status": "ok"}


@app.post("/triage")
async def triage(req: TriageRequest) -> dict:
    return await orchestrator.run_triage(req.case_text, role=req.role, tool_name=req.tool_name)
