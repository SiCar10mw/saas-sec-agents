# CSA SSCF Mapping Method

This method standardizes how SaaS security controls are mapped to CSA SSCF.

## Mapping Workflow
1. Define the SaaS control requirement (what must be configured).
2. Define verification evidence (API object, setting path, log source).
3. Map to one or more SSCF control IDs.
4. Set mapping strength:
   - `direct`: control objective is materially the same.
   - `partial`: control contributes but does not fully satisfy objective.
   - `informative`: related context only.
5. Record rationale and remediation notes.

## Required Record Structure
```yaml
id: SF-TS-001
title: Block high-risk session behavior
platform: salesforce
severity: high
category: transaction_security
expected_state: "Enabled with blocking response"
validation:
  method: api
  source: "<settings endpoint or metadata object>"
sscf_mappings:
  - sscf_domain: "<domain>"
    sscf_control_id: "<id>"
    mapping_strength: direct
    rationale: "<why this mapping is valid>"
```

## Quality Rules
- Do not leave controls without SSCF mapping.
- Use `partial` if implementation only covers part of control objective.
- Include at least one evidence source per control.
- Keep mappings versioned; update when SSCF/control language changes.

## Deliverables
- Platform control catalogs (YAML)
- Baseline assessment output (`pass/fail/partial/not_applicable`)
- Gap report and remediation backlog linked to SSCF IDs

