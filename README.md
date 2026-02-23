# multiagent-azure

Azure-first multi-agent DFIR/malware analysis architecture scaffold using:
- Python orchestrator (LangGraph-ready)
- Terraform for Azure infrastructure
- GitHub Actions with OIDC for CI/CD

## What This Includes
- `app/`: Python API + provider adapter interfaces
- `infra/terraform/`: Azure baseline (resource group, log analytics, container apps, APIM, key vault, storage, service bus)
- `.github/workflows/`: Terraform plan/apply workflows using Azure OIDC
- `.github/workflows/security-checks.yml`: baseline security CI checks
- `.github/workflows/pr-inline-review.yml`: inline PR review comments for Terraform/Python
- `.github/pull_request_template.md`: required risk/RV/rollback fields
- `.github/CODEOWNERS`: required human reviewer routing
- `config/role_model_policy.yaml`: role-scoped model pool policy
- `config/role_tool_policy.yaml`: role-scoped tool allowlist policy
- `docs/architecture.md`: reference architecture and execution model
- `docs/cloud-mcp-architecture.md`: cloud-hosted MCP architecture (no local Docker dependency)
- `docs/azure-tenant-bootstrap.md`: secure tenant/subscription bootstrap checklist
- `docs/secure-coding-standard.md`: required secure coding controls
- `docs/rollout-phases.md`: phased rollout with config, RV, and backout
- `docs/change-control.md`: release/change management runbook
- `docs/sift-worker-runbook.md`: SIFT image and worker lifecycle runbook
- `docs/sample-data-catalog.md`: approved evidence/sample data model and handling rules
- `CHANGELOG.md`: required ledger for all notable changes

## If You Do Not Have an Azure Tenant Yet
1. Follow `docs/azure-tenant-bootstrap.md`.
2. Do not deploy production workloads until identity, policy, and logging baselines are in place.
3. Use `workload-dev` only until baseline controls are validated.

## Quick Start
1. Create Azure service principal/federated credentials for GitHub OIDC.
2. Set GitHub repo variables/secrets:
   - Variables: `AZURE_CLIENT_ID`, `AZURE_TENANT_ID`, `AZURE_SUBSCRIPTION_ID`, `TF_STATE_RG`, `TF_STATE_SA`, `TF_STATE_CONTAINER`, `TF_STATE_KEY`
   - Secrets: provider API keys (later in Key Vault)
3. Copy and edit `infra/terraform/envs/dev.tfvars.example` -> `dev.tfvars`.
4. Run locally:

```bash
cd infra/terraform
terraform init \
  -backend-config="resource_group_name=<TF_STATE_RG>" \
  -backend-config="storage_account_name=<TF_STATE_SA>" \
  -backend-config="container_name=<TF_STATE_CONTAINER>" \
  -backend-config="key=<TF_STATE_KEY>"
terraform plan -var-file=envs/dev.tfvars
```

## Repo Structure
```text
app/
  main.py
  orchestrator.py
  providers/
scripts/
  sift-install.sh
  sift-hardening.sh
  upload-sample-data.sh
config/
  role_model_policy.yaml
  role_tool_policy.yaml
infra/terraform/
  versions.tf
  providers.tf
  main.tf
  variables.tf
  outputs.tf
  sift-image-factory/
  cloud-mcp/
.github/workflows/
  terraform-plan.yml
  terraform-apply.yml
docs/
  architecture.md
  sift-worker-runbook.md
  sample-data-catalog.md
  cloud-mcp-architecture.md
```

## Next Build Steps
1. Implement LangGraph workflow (`ingest -> triage -> tool exec -> summarize -> approval`).
2. Add APIM policies (JWT, rate limit, schema validation).
3. Build and publish SIFT image via `infra/terraform/sift-image-factory`.
4. Deploy isolated worker pool for malware detonation.
5. Connect Copilot Studio actions to APIM endpoints.
6. Load approved sample datasets using `scripts/upload-sample-data.sh`.
7. Deploy cloud MCP gateway stack (`infra/terraform/cloud-mcp`) and route tools through APIM.

## Change Management Requirements
1. Every PR must update `CHANGELOG.md` (`[Unreleased]`).
2. Follow `docs/rollout-phases.md` for phase gates and rollback.
3. Follow `docs/change-control.md` for release validation (RV) and backout.
4. Follow `docs/secure-coding-standard.md` and complete PR template fields.
5. Require status checks: `security-checks` and `pr-inline-review`.
