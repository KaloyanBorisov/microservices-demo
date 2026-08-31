# Deploy Online Boutique on Google Cloud Run with Terraform ($0 Fixed Cost)

This Terraform configuration provisions the entire Online Boutique microservices architecture on **Google Cloud Run (v2)** with **$0 fixed monthly infrastructure costs** (using built-in in-memory session caching and pure scale-to-zero serverless containers).

---

## 🏗 Architecture Overview

* **Frontend:** Public-facing Cloud Run service with unauthenticated HTTP access.
* **Backend Services (gRPC / HTTP/2 over TLS):**
  * `adservice`
  * `cartservice` (In-Memory distributed cache)
  * `checkoutservice`
  * `currencyservice`
  * `emailservice`
  * `paymentservice`
  * `productcatalogservice`
  * `recommendationservice`
  * `shippingservice`
* **Monthly Idle Cost:** **$0.00** (Full scale-to-zero; covered under Google Cloud Run's Free Tier).

---

## 🚀 Deployment Instructions

### Prerequisites
1. [Google Cloud SDK (`gcloud`)](https://cloud.google.com/sdk/docs/install) installed and authenticated:
   ```bash
   gcloud auth login
   gcloud auth application-default login
   ```
2. [Terraform CLI / OpenTofu](https://opentofu.org/docs/intro/install/) (>= 1.5.0) installed.

### Steps

1. **Initialize Terraform:**
   ```bash
   cd terraform
   terraform init
   ```

2. **Configure Variables:**
   Copy `terraform.tfvars.example` to `terraform.tfvars`:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```
   Edit `terraform.tfvars` and set your `gcp_project_id` and image registry.

3. **Plan and Apply:**
   ```bash
   terraform plan
   terraform apply
   ```

4. **Access the Application:**
   Once completed, Terraform outputs the frontend URL:
   ```bash
   terraform output frontend_url
   ```
   Open the printed URL in your browser to access Online Boutique.

---

## 🧹 Cleanup
To tear down all resources:
```bash
terraform destroy
```
