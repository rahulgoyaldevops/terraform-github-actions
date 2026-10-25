# 🛠️ Production Troubleshooting & Day-2 Operations Runbook

> **Target:** Senior Engineers & On-Call Platform Leads  
> **Author:** Rahul Goyal (14+ Years)

---

## 1. Resolving State Lock Conflicts (`BlobLeaseOccupyFailed`)

### Symptoms
`Error acquiring the state lock: 412 There is currently a lease on the blob and no lease ID was specified in the request.`

### Cause
A previous CI/CD pipeline aborted abruptly or timed out while holding the lock lease.

### Production-Safe Resolution
```bash
# 1. Inspect the lease state via Azure CLI
az storage blob show \
  --account-name sttfstatelzprod01 \
  --container-name tfstate-prod \
  --name github-actions.terraform.tfstate \
  --query "properties.lease.status"

# 2. Break the orphaned lease safely
az storage blob lease break \
  --account-name sttfstatelzprod01 \
  --container-name tfstate-prod \
  --blob-name github-actions.terraform.tfstate

# 3. Retry the pipeline with verification
```

---

## 2. Azure OIDC Workload Identity Token Expiration

### Symptoms
`AADSTS700213: No matching federated identity record found for presented assertion.`

### Troubleshooting Protocol
1. Verify the subject claim (`sub`) matches the branch or environment exactly:
   - For main branch: `repo:rahulgoyaldevops/terraform-github-actions:ref:refs/heads/main`
   - For Pull Requests: `repo:rahulgoyaldevops/terraform-github-actions:pull_request`
2. Ensure `audience` is set to `api://AzureADTokenExchange`.
3. Check Azure AD App Registration Federated Credentials expiry status.

---
*Maintained by [Rahul Goyal](https://github.com/rahulgoyaldevops)*