# SIFT Worker Image Runbook (Azure)

This runbook covers build, validation, and rollback for SIFT worker images.

## Scope
- Build a reusable SIFT image pipeline for ephemeral DFIR workers.
- Use Ubuntu native install (not OVA) for cloud maintainability.

## Prerequisites
1. Dedicated sandbox subscription/resource group boundary.
2. Network isolation approved by security architecture.
3. Terraform backend configured.

## Build Steps
1. Deploy image factory baseline:
```bash
cd infra/terraform/sift-image-factory
terraform init \
  -backend-config="resource_group_name=<TF_STATE_RG>" \
  -backend-config="storage_account_name=<TF_STATE_SA>" \
  -backend-config="container_name=<TF_STATE_CONTAINER>" \
  -backend-config="key=sift-image-factory-dev.tfstate"
terraform plan -var-file=envs/dev.tfvars
terraform apply -var-file=envs/dev.tfvars
```
2. Upload scripts from `scripts/` to image-factory script container.
3. Create Azure Image Builder template referencing:
   - Ubuntu 22.04 base image
   - `scripts/sift-install.sh`
   - `scripts/sift-hardening.sh`
4. Run image build and publish new version to Azure Compute Gallery.

## Release Validation (RV)
- VM launched from new image can run:
  - `cast --help`
  - selected SIFT tool smoke tests
- SSH hardening validated (`PasswordAuthentication no`, `PermitRootLogin no`).
- Image can process sample evidence and upload artifacts.
- Worker VM teardown workflow succeeds.

## Rollback / Backout
1. Mark latest image version as blocked for deployment.
2. Repoint worker scale-set/template to previous known-good image version.
3. Re-run worker smoke tests.
4. Open incident note with failed version metadata.

## Security Notes
- Never detonate malware in shared corp VNet.
- Restrict outbound egress to approved destinations.
- Use one-case-per-worker and destroy worker after completion.
- Rotate credentials and avoid embedding secrets in image.
- Use only approved containers from `docs/sample-data-catalog.md` for evidence/sample data.
