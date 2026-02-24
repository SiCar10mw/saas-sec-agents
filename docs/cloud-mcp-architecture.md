# Cloud MCP Architecture (No Local Docker Dependency)

This project is cloud-first: all MCP tool capabilities are hosted in Azure so operations are available from any managed workstation/browser.

## Pattern
1. APIM front door for auth/policy/rate limiting.
2. Container Apps-hosted MCP gateway services.
3. Tool microservices for DFIR tasks (SIFT helpers, enrichment, parsing).
4. Role-based policy in orchestrator determines allowed tool/model use.

## Why Cloud MCP
- No workstation dependency on Docker Desktop.
- Centralized governance and audit.
- Consistent runtime across environments.
- Easier security operations handoff.

## Security Controls
- Entra auth and APIM policy enforcement.
- Private networking where required.
- RBAC role separation by agent type.
- Full request/response audit telemetry.
