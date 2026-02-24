# Next Session Prompts (Current Restart Pack)

## Current State Snapshot
- Repo: `/Users/jerijuar/multiagent-azure`
- Branch: `main`
- Remote: `git@github.com-443:SiCar10mw/multiagent-azure.git`
- Git state: synced except one local workflow edit currently unstaged.
- Primary workstream: `OSCAL POC for Salesforce` with SBS + CSA SSCF mapping.

## What Is Completed
- Salesforce baseline v1.0 deliverable updated (MD + DOCX).
- OSCAL scaffold implemented:
  - `config/oscal-salesforce/*`
  - `scripts/oscal_import_sbs.py`
  - `scripts/oscal_gap_map.py`
  - `scripts/oscal_smoke_test.sh`
  - `docs/oscal-salesforce-poc/*`
- Collector-style mock run generated and committed:
  - `docs/oscal-salesforce-poc/generated/sbs_controls.json`
  - `docs/oscal-salesforce-poc/generated/salesforce_oscal_backlog.json`
  - `docs/oscal-salesforce-poc/generated/salesforce_oscal_gap_matrix.md`
- Brutal-critic remediation backlog created:
  - `docs/reviews/2026-02-24-brutal-critic-backlog.md`

## Open Item (Local Only Right Now)
- `.github/workflows/security-checks.yml` is edited locally to enforce:
  - tfsec `--minimum-severity HIGH`
  - checkov `hard_fail_on: HIGH,CRITICAL`
  - checkov `soft_fail_on: LOW,MEDIUM`
- This change is not committed/pushed yet.

## Prompt 1: Resume Exactly Where We Left Off
```text
Resume from /Users/jerijuar/multiagent-azure/NEXT_SESSION_PROMPTS.md.
First, inspect git status and handle the pending local workflow change in .github/workflows/security-checks.yml:
- either commit/push it, or revert it if we decide to keep report-only mode.
Then confirm latest security-checks workflow behavior on GitHub Actions.
```

## Prompt 2: Run OSCAL Pipeline with Real Gap Data
```text
Use the OSCAL pipeline in /Users/jerijuar/multiagent-azure with my real Salesforce gap-analysis JSON.
Run oscal_gap_map.py against real input and regenerate:
- docs/oscal-salesforce-poc/generated/salesforce_oscal_backlog.json
- docs/oscal-salesforce-poc/generated/salesforce_oscal_gap_matrix.md
Keep SBS to CSA SSCF mapping enabled.
```

## Prompt 3: Start Sandbox Collector Implementation
```text
Implement the first read-only Salesforce collector stub that emits schema-compatible findings.
Start with Authentication/Access controls and output findings to baseline_assessment_schema.json shape.
Save under scripts/ and docs/oscal-salesforce-poc/.
```

## Prompt 4: Work Through Brutal-Critic Backlog
```text
Use docs/reviews/2026-02-24-brutal-critic-backlog.md as the source of truth.
Start with BC-001, BC-002, BC-003 in order, with minimal safe increments and verification after each.
```

## First Commands To Run Next Session
```bash
git -C /Users/jerijuar/multiagent-azure status -sb
git -C /Users/jerijuar/multiagent-azure log --oneline -n 8
git -C /Users/jerijuar/multiagent-azure diff -- .github/workflows/security-checks.yml
```

