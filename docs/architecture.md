# Architecture (Azure + Copilot Studio)

## Control Plane
- Copilot Studio as analyst-facing UI.
- Backend orchestration API (Python) hosted on Azure Container Apps.

## Orchestration
- LangGraph-ready orchestrator service:
  - intake
  - triage
  - tool execution dispatch
  - summary + approval

## Tooling Plane
- APIM in front of backend/tool APIs for auth, policy, and throttling.
- Cloud-hosted MCP gateway services in Azure Container Apps (no local Docker Desktop dependency).
- Service Bus queue for asynchronous DFIR jobs.

## Data/Security
- Evidence artifacts in private Storage account containers.
- Secrets in Key Vault.
- Telemetry via Log Analytics.

## Isolation for Malware Tasks (next phase)
- Separate subscription/VNet.
- SIFT image factory using Ubuntu native install and Azure Compute Gallery versioning.
- Ephemeral sandbox workers.
- No direct trust path to corp network.
