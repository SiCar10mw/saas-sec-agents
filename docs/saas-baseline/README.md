# SaaS Security Baseline (CSA SSCF-Aligned)

This baseline package defines configuration controls for SaaS platforms and maps each control to CSA SSCF.

## Scope
- Salesforce (including Event Monitoring and Transaction Security)
- ServiceNow
- Workday

## Design Principle
Every control/action must include:
1. A clear technical configuration requirement.
2. Validation logic and evidence source.
3. CSA SSCF mapping metadata.

## Files
- `docs/saas-baseline/sscf-mapping-method.md`
- `docs/saas-baseline/raci.md`
- `docs/saas-baseline/exception-process.md`
- `docs/saas-baseline/quarterly-report-template.md`
- `config/saas_baseline_controls/salesforce.yaml`
- `config/saas_baseline_controls/servicenow.yaml`
- `config/saas_baseline_controls/workday.yaml`
- `config/sscf_control_index.yaml`
- `schemas/baseline_assessment_schema.json`

## Minimum Mapping Fields
- `sscf_domain`
- `sscf_control_id`
- `mapping_strength` (`direct`, `partial`, `informative`)
- `rationale`

## Execution Model
1. Collect current config in read-only mode.
2. Evaluate each control against expected state.
3. Produce findings with SSCF references.
4. Generate remediation backlog and exception workflow.
