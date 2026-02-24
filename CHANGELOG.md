# Changelog

All notable changes to this project will be documented in this file.

This project follows a simple changelog format and semantic versioning intent:
- `Added` for new features
- `Changed` for changes in existing behavior
- `Fixed` for bug fixes
- `Security` for hardening and security controls
- `Deprecated` for soon-to-be removed features
- `Removed` for now removed features

## [Unreleased]

### Added
- Initial Azure-first scaffold:
  - Python orchestrator API and provider adapter interface
  - Terraform baseline for RG, Log Analytics, Service Bus, Storage, Key Vault, Container Apps, APIM
  - GitHub Actions OIDC workflows for Terraform plan/apply
  - Architecture documentation
- Phased rollout runbook with rollback and release-validation (RV) gates.
- Change control runbook for safe rollout and backout.
- Azure tenant bootstrap runbook for secure setup before first deployment.
- Secure coding standard aligned to Well-Architected pillars.
- GitHub PR template enforcing risk, RV, and rollback fields.
- Security CI workflow with Bandit + Terraform format checks.
- CODEOWNERS policy for required reviewer routing by path.
- Inline PR reviewer workflow for Terraform (`tflint`) and Python (`ruff`) feedback.
- SIFT image factory scaffold:
  - `infra/terraform/sift-image-factory` stack
  - `scripts/sift-install.sh` and `scripts/sift-hardening.sh`
  - `docs/sift-worker-runbook.md`
- Rollout phase split into `Phase 4A (SIFT Image Factory)` and `Phase 4B (Sandbox Workers)`.
- Evidence/sample storage model expanded with dedicated private containers:
  - `samples-quarantine`, `memory-captures`, `disk-images`, `pcaps`, `case-artifacts`, `manifests`, `evidence`
- Sample data tooling and governance:
  - `scripts/upload-sample-data.sh`
  - `docs/sample-data-catalog.md`
- Cloud-only MCP capability added:
  - `infra/terraform/cloud-mcp` scaffold
  - `docs/cloud-mcp-architecture.md`
  - role-scoped policy files (`config/role_model_policy.yaml`, `config/role_tool_policy.yaml`)
  - orchestrator policy enforcement for model routing and tool authorization
- Brutal-critic governance assets added:
  - `docs/agents/brutal-critic-agent.md`
  - `docs/templates/brutal-critic-review-template.md`
  - change-control requirement to run brutal-critic for phase/architecture changes
- CSA SSCF-aligned SaaS baseline foundation added:
  - `docs/saas-baseline/README.md`
  - `docs/saas-baseline/sscf-mapping-method.md`
  - platform control catalogs:
    - `config/saas_baseline_controls/salesforce.yaml`
    - `config/saas_baseline_controls/servicenow.yaml`
    - `config/saas_baseline_controls/workday.yaml`
- Program operating artifacts added:
  - `config/sscf_control_index.yaml`
  - `schemas/baseline_assessment_schema.json`
  - `docs/saas-baseline/raci.md`
  - `docs/saas-baseline/exception-process.md`
  - `docs/saas-baseline/quarterly-report-template.md`
- SaaS baseline intake template added:
  - `docs/saas-baseline/intake-template.md`
- Brutal-critic audit workflow additions:
  - `docs/agents/tasks/brutal-critic-audit-task.md`
  - `docs/reviews/2026-02-24-brutal-critic-audit.md`

## [0.1.0] - 2026-02-23

### Added
- First project bootstrap release.
