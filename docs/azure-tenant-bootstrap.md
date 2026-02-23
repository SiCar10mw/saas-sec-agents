# Azure Tenant Bootstrap (Enterprise-Safe)

Use this before any workload deployment. If your business already has a tenant, align to that tenant and do not create a parallel unmanaged one.

## 0) Decision
- Preferred: deploy into your company Entra tenant with existing governance.
- Fallback (lab only): create a separate tenant/subscription for non-production prototyping.

## 1) Identity Foundation (Day 0)
1. Enforce MFA for all users.
2. Enable Conditional Access baseline policies.
3. Create two break-glass accounts with hardware MFA and offline custody process.
4. Enable Entra PIM for privileged roles.
5. Assign least-privilege RBAC groups (`platform-admin`, `security-admin`, `devops-read`, `workload-contrib`).

## 2) Management Group + Subscription Layout
1. Management groups:
   - `platform`
   - `security`
   - `shared-services`
   - `workloads`
2. Subscriptions:
   - `platform-connectivity`
   - `platform-management`
   - `security-operations`
   - `workload-dev`
   - `workload-prod`
3. Keep malware/sandbox execution in a separate subscription boundary.

## 3) Logging + Security Baseline
1. Create central Log Analytics workspace (or dedicated per environment with forwarding strategy).
2. Enable Microsoft Defender for Cloud plans required by policy.
3. Onboard subscriptions to Microsoft Sentinel (or your SOC data plane standard).
4. Enable activity/resource diagnostics on all critical services.
5. Configure retention and immutable evidence strategy for DFIR artifacts.

## 4) Network Baseline
1. Hub-and-spoke topology (or virtual WAN per enterprise standard).
2. Private endpoints preferred for Key Vault, Storage, and data services.
3. Restrict egress with firewall/NAT policy.
4. Deny direct trust path from detonation/sandbox networks to corp networks.

## 5) Policy Baseline (Azure Policy/Initiatives)
Apply a baseline initiative with, at minimum:
- deny public storage blobs
- require TLS 1.2+
- require diagnostic settings
- restrict allowed locations
- require tag set (`owner`, `environment`, `data-classification`, `cost-center`)
- deny privileged role assignment outside approved groups

## 6) GitHub OIDC Setup (No Long-Lived Cloud Secrets)
1. Create Entra application for GitHub Actions.
2. Add federated credentials for repo/environment branches.
3. Grant scoped roles at subscription/resource-group level only.
4. Set repo variables:
   - `AZURE_CLIENT_ID`
   - `AZURE_TENANT_ID`
   - `AZURE_SUBSCRIPTION_ID`
   - backend state vars (`TF_STATE_*`)

## 7) Terraform State Security
1. Use dedicated state storage account/container.
2. Enable soft delete/versioning and access logging.
3. Restrict state access to CI principal + platform admins.

## 8) Readiness Checklist
- [ ] Identity controls enabled (MFA, CA, PIM).
- [ ] Subscription boundaries created.
- [ ] Baseline policy initiative assigned.
- [ ] Logging/security onboarding completed.
- [ ] GitHub OIDC pipeline authenticated.
- [ ] Terraform plan runs in `workload-dev`.

