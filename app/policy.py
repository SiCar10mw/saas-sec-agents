from __future__ import annotations

from pathlib import Path
from typing import Any, Dict

import yaml

ROOT = Path(__file__).resolve().parents[1]
MODEL_POLICY_PATH = ROOT / "config" / "role_model_policy.yaml"
TOOL_POLICY_PATH = ROOT / "config" / "role_tool_policy.yaml"


class PolicyError(ValueError):
    pass


def _load_yaml(path: Path) -> Dict[str, Any]:
    if not path.exists():
        raise PolicyError(f"Policy file not found: {path}")
    data = yaml.safe_load(path.read_text())
    if not isinstance(data, dict):
        raise PolicyError(f"Invalid policy format: {path}")
    return data


def model_policy_for_role(role: str) -> Dict[str, Any]:
    data = _load_yaml(MODEL_POLICY_PATH)
    roles = data.get("roles", {})
    role_cfg = roles.get(role)
    if not role_cfg:
        raise PolicyError(f"Unknown role in model policy: {role}")
    return role_cfg


def tool_policy_for_role(role: str) -> Dict[str, Any]:
    data = _load_yaml(TOOL_POLICY_PATH)
    roles = data.get("roles", {})
    role_cfg = roles.get(role)
    if not role_cfg:
        raise PolicyError(f"Unknown role in tool policy: {role}")
    return role_cfg
