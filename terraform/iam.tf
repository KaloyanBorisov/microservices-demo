# Copyright 2026 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Allow unauthenticated public traffic to the frontend web application
resource "google_cloud_run_v2_service_iam_member" "frontend_public" {
  project  = var.gcp_project_id
  location = var.region
  name     = google_cloud_run_v2_service.frontend.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}

# Allow unauthenticated invocation across internal microservices for demo connectivity
# (In a strict production environment, assign dedicated Cloud Run Service Accounts with roles/run.invoker)
locals {
  internal_services = [
    google_cloud_run_v2_service.emailservice.name,
    google_cloud_run_v2_service.paymentservice.name,
    google_cloud_run_v2_service.shippingservice.name,
    google_cloud_run_v2_service.currencyservice.name,
    google_cloud_run_v2_service.productcatalogservice.name,
    google_cloud_run_v2_service.recommendationservice.name,
    google_cloud_run_v2_service.adservice.name,
    google_cloud_run_v2_service.cartservice.name,
    google_cloud_run_v2_service.checkoutservice.name
  ]
}

resource "google_cloud_run_v2_service_iam_member" "internal_invoker" {
  for_each = toset(local.internal_services)

  project  = var.gcp_project_id
  location = var.region
  name     = each.value
  role     = "roles/run.invoker"
  member   = "allUsers"
}
