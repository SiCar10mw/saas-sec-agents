from __future__ import annotations

from dataclasses import dataclass
from typing import Dict, Optional

from app.model_router import ModelRouter
from app.tool_policy import is_tool_allowed


@dataclass
class Orchestrator:
    router: ModelRouter

    @classmethod
    def default(cls) -> "Orchestrator":
        return cls(router=ModelRouter())

    async def run_triage(self, case_text: str, role: str = "malware_analyst", tool_name: Optional[str] = None) -> dict:
        prompt = (
            "You are a DFIR triage agent. Return concise JSON-like findings: "
            "severity, likely malware family, confidence, next_steps.\n"
            f"Case: {case_text}"
        )

        route = self.router.route_for_role(role)
        provider = self.router.providers[route.selected_provider]
        response = await provider.generate(prompt)

        tool_allowed = None
        if tool_name:
            tool_allowed = is_tool_allowed(role, tool_name)

        return {
            "role": role,
            "provider": provider.name(),
            "provider_attempt_order": route.attempted_order,
            "tool_name": tool_name,
            "tool_allowed": tool_allowed,
            "result": response,
        }
