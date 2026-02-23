from __future__ import annotations

from app.providers.base import ModelProvider


class AzureOpenAIProvider(ModelProvider):
    def name(self) -> str:
        return "azure-openai"

    async def generate(self, prompt: str) -> str:
        return f"[stub:{self.name()}] {prompt[:120]}"
