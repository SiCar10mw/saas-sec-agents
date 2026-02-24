# Agent Task: Brutal-Critic Audit

## Objective
Run an adversarial review of the current repository state and produce a prioritized improvement plan.

## Inputs
1. Current branch state
2. `README.md`
3. `docs/rollout-phases.md`
4. `docs/change-control.md`
5. Terraform stacks under `infra/terraform/**`
6. Security/governance policies under `config/**` and `docs/saas-baseline/**`

## Required Output
Create a review file under:
- `docs/reviews/<date>-brutal-critic-audit.md`

The report must follow:
1. `Verdict`
2. `Critical Findings` (ordered by severity P0-P3)
3. `Gaps by Pillar` (security, reliability, cost, operations, performance)
4. `Rollback Risk`
5. `Required Changes Before Proceeding`
6. `Fast Wins`
7. `Confidence`

## Severity Rule
- If any `P0` exists, verdict must be `reject`.

## Completion Criteria
- Findings include concrete remediation actions.
- At least one remediation is mapped to each major phase in `docs/rollout-phases.md`.
- `CHANGELOG.md` updated with audit artifact reference.

