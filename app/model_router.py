from __future__ import annotations

from dataclasses import dataclass
from typing import Dict, List

from app.policy import model_policy_for_role
from app.providers.anthropic import AnthropicProvider
from app.providers.azure_openai import AzureOpenAIProvider
from app.providers.base import ModelProvider
from app.providers.gemini import GeminiProvider


@dataclass
class RouteDecision:
    role: str
    selected_provider: str
    attempted_order: List[str]


class ModelRouter:
    def __init__(self) -> None:
        self.providers: Dict[str, ModelProvider] = {
            "azure-openai": AzureOpenAIProvider(),
            "anthropic": AnthropicProvider(),
            "gemini": GeminiProvider(),
        }

    def route_for_role(self, role: str) -> RouteDecision:
        cfg = model_policy_for_role(role)
        allowed: List[str] = cfg["allowed_models"]
        primary = cfg["primary"]
        fallbacks: List[str] = cfg.get("fallbacks", [])

        if primary not in allowed:
            raise ValueError(f"Primary provider {primary} is not in allowed_models for role {role}")

        attempted = [primary] + [f for f in fallbacks if f in allowed and f != primary]

        for provider_name in attempted:
            if provider_name in self.providers:
                return RouteDecision(
                    role=role,
                    selected_provider=provider_name,
                    attempted_order=attempted,
                )

        raise ValueError(f"No configured providers found for role {role}")
