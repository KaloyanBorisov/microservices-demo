# Online Boutique on Google Cloud Run

**Online Boutique** is a cloud-first microservices demo application. The application is an e-commerce web store where users can browse items, add them to their shopping cart, and purchase them.

This branch (`GoogleCloudRun`) provides a serverless architecture designed specifically for **Google Cloud Run (v2)**, offering **$0 fixed monthly infrastructure cost** with pure scale-to-zero compute and built-in in-memory session caching.

---

## 🏗 Architecture

Online Boutique is composed of **10 microservices** communicating over **gRPC (HTTP/2 with TLS)** and exposing a web frontend over HTTP/HTTPS:

```
                  ┌────────────────┐
                  │    Frontend    │ (HTTP / Public)
                  └───────┬────────┘
        ┌─────────────────┼──────────────────┐
        │ (gRPC)          │ (gRPC)           │ (gRPC)
        ▼                 ▼                  ▼
┌───────────────┐ ┌───────────────┐  ┌───────────────┐
│ ProductCatalog│ │  CurrencySvc  │  │    CartSvc    │ (In-Memory Session)
└───────────────┘ └───────────────┘  └───────────────┘
        ▲                 ▲                  ▲
        │ (gRPC)          │ (gRPC)           │ (gRPC)
┌───────┴───────┐ ┌───────┴───────┐  ┌───────┴───────┐
│ Recommendation│ │  CheckoutSvc  │──┤  ShippingSvc  │
└───────────────┘ └───────┬───────┘  └───────────────┘
                          │ (gRPC)
                  ┌───────┴───────┐
                  │  PaymentSvc   │
                  └───────────────┘
```

| Service | Language | Description | Port / Protocol |
| :--- | :--- | :--- | :--- |
| **`frontend`** | Go | Web frontend serving HTML, static assets, and user sessions. | Port 8080 (HTTP) |
| **`cartservice`** | C# (.NET) | Stores user cart items using built-in in-memory cache. | Port 7070 (gRPC / HTTP/2) |
| **`productcatalogservice`** | Go | Provides product catalog data and search capabilities. | Port 3550 (gRPC / HTTP/2) |
| **`currencyservice`** | Node.js | Converts money values between currencies (ECB rates). | Port 7000 (gRPC / HTTP/2) |
| **`paymentservice`** | Node.js | Processes mock credit card transactions. | Port 50051 (gRPC / HTTP/2) |
| **`shippingservice`** | Go | Calculates shipping costs and provides mock tracking. | Port 50051 (gRPC / HTTP/2) |
| **`emailservice`** | Python | Sends mock order confirmation emails. | Port 8080 (gRPC / HTTP/2) |
| **`checkoutservice`** | Go | Orchestrates order placement, payments, shipping, and email. | Port 5050 (gRPC / HTTP/2) |
| **`recommendationservice`** | Python | Generates product recommendations based on user cart. | Port 8080 (gRPC / HTTP/2) |
| **`adservice`** | Java | Serves contextual ads based on browsing keywords. | Port 9555 (gRPC / HTTP/2) |

---

## 🌟 Key Cloud Run Features

* **$0 Monthly Fixed Cost (Scale-to-Zero):** When there is no incoming traffic, compute instances scale down to 0 instances. Covered 100% by the Google Cloud Run Free Tier.
* **Auto-TLS gRPC Security:** All inter-service gRPC connections automatically negotiate TLS over port 443 (`*.a.run.app:443`).
* **In-Memory Session Storage:** Uses `cartservice`'s built-in in-memory session cache, eliminating the need for expensive dedicated Redis instances or VPC access connectors.
* **Google Cloud Trace & Logging:** Auto-propagates W3C `traceparent` headers for distributed request tracing and log correlation in the Google Cloud Console.

---

## 🚀 Deployment Instructions

### Prerequisites
* [Google Cloud SDK (`gcloud`)](https://cloud.google.com/sdk/docs/install) installed and authenticated:
  ```bash
  gcloud auth login
  gcloud auth application-default login
  ```
* [Terraform / OpenTofu](https://opentofu.org/docs/intro/install/) (>= 1.5.0).

---

### Step 1: Build & Push Images (Google Cloud Build)
Submit a parallel Cloud Build job to build all 10 microservices and push them to Google Artifact Registry:

```bash
gcloud builds submit --config=cloudbuild.yaml --project=<YOUR_GCP_PROJECT_ID> .
```

---

### Step 2: Deploy with Terraform

1. Navigate to the `terraform/` directory:
   ```bash
   cd terraform
   ```

2. Create your `terraform.tfvars`:
   ```hcl
   gcp_project_id      = "your-gcp-project-id"
   region              = "us-central1"
   name_prefix         = "boutique"
   container_registry  = "us-central1-docker.pkg.dev/your-gcp-project-id/online-boutique"
   container_image_tag = "latest"
   ```

3. Initialize and deploy:
   ```bash
   terraform init
   terraform apply
   ```

4. Retrieve the live frontend URL:
   ```bash
   terraform output frontend_url
   ```

---

## 🧹 Cleanup
To tear down all resources and prevent any unintended usage:
```bash
cd terraform
terraform destroy
```
