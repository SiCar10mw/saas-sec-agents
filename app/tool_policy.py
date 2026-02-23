from __future__ import annotations

from app.policy import tool_policy_for_role


def is_tool_allowed(role: str, tool_name: str) -> bool:
    cfg = tool_policy_for_role(role)
    allowed = cfg.get("allowed_tools", [])
    return tool_name in allowed
