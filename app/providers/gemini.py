from __future__ import annotations

from app.providers.base import ModelProvider


class GeminiProvider(ModelProvider):
    def name(self) -> str:
        return "gemini"

    async def generate(self, prompt: str) -> str:
        return f"[stub:{self.name()}] {prompt[:120]}"
