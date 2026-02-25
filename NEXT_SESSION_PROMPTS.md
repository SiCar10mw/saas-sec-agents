# Next Session Prompts (Current Restart Pack)

## Current State Snapshot
- Repo: `/Users/jerijuar/multiagent-azure`
- Branch: `main`
- Remote: `git@github.com-443:SiCar10mw/multiagent-azure.git`
- Git state: `main...origin/main` (fully synced).
- Primary workstream: `OSCAL POC for Salesforce` with business-facing deliverable outputs.
- GitHub CLI auth: restored and validated via `gh run rerun/watch/list`.

## What Is Completed
- Terraform tfsec blocker fixed:
  - commit `b50a447`
  - change: Key Vault deny-by-default network ACL in `infra/terraform/main.tf`
  - result: `Run tfsec` passes in CI.
- Security checks are strict and active:
  - tfsec fails on `HIGH+`
  - checkov hard-fails on `HIGH,CRITICAL`; soft-fails on `LOW,MEDIUM`
- OSCAL end-to-end example outputs generated and committed:
  - commit `929dec9`
  - `docs/oscal-salesforce-poc/generated/salesforce_oscal_backlog_latest.json`
  - `docs/oscal-salesforce-poc/generated/salesforce_oscal_gap_matrix_latest.md`
  - `docs/oscal-salesforce-poc/deliverables/SFDC_OSCAL_Example_Output_2026-02-25.md`
  - `docs/oscal-salesforce-poc/deliverables/SFDC_OSCAL_Example_Output_2026-02-25.docx`
- Example run summary (collector-style SFDC gap file):
  - controls/findings: `45`
  - mapped: `45`
  - unmapped: `0`
  - invalid mappings: `0`
  - status: `24 pass / 12 partial / 9 fail`

## Prompt 1: OSCAL With Real Business Unit Gap File
```text
Resume from /Users/jerijuar/multiagent-azure/NEXT_SESSION_PROMPTS.md.
Use the OSCAL pipeline with my real Salesforce gap-analysis JSON and regenerate:
- docs/oscal-salesforce-poc/generated/salesforce_oscal_backlog_latest.json
- docs/oscal-salesforce-poc/generated/salesforce_oscal_gap_matrix_latest.md
Then refresh the business-unit deliverable DOCX with run-specific metrics and top remediation priorities.
```

## Prompt 2: Publish Business Unit Pack
```text
Create a client-facing package from the latest OSCAL output:
1) update docs/oscal-salesforce-poc/deliverables/SFDC_OSCAL_Example_Output_2026-02-25.md
2) regenerate DOCX from reference template
3) add an appendix table of all fail/partial controls with owner + due date
Keep wording executive-friendly and audit-ready.
```

## Prompt 3: Continue Security Hardening After OSCAL Pack
```text
Use the latest failed security-checks run and remediate checkov HIGH/CRITICAL findings in small safe increments.
Start with storage + service bus + APIM findings and rerun CI after each increment.
```

## First Commands To Run Next Session
```bash
git -C /Users/jerijuar/multiagent-azure status -sb
git -C /Users/jerijuar/multiagent-azure log --oneline -n 10
cd /Users/jerijuar/multiagent-azure && unset GITHUB_TOKEN GH_TOKEN; gh run list --workflow security-checks.yml --limit 8
```
