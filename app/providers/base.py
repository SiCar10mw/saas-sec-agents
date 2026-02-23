from __future__ import annotations

from abc import ABC, abstractmethod


class ModelProvider(ABC):
    """Provider contract so model routing stays vendor-agnostic."""

    @abstractmethod
    def name(self) -> str:
        raise NotImplementedError

    @abstractmethod
    async def generate(self, prompt: str) -> str:
        raise NotImplementedError
