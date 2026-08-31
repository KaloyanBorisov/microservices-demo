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

# 1. Email Service (gRPC)
resource "google_cloud_run_v2_service" "emailservice" {
  name     = "${var.name_prefix}-emailservice"
  location = var.region
  ingress  = "INGRESS_TRAFFIC_ALL"

  template {
    containers {
      image = "${var.container_registry}/emailservice:${var.container_image_tag}"
      ports {
        name           = "h2c"
        container_port = 8080
      }
      resources {
        limits = {
          cpu    = "1000m"
          memory = "512Mi"
        }
      }
    }
  }

  depends_on = [google_project_service.enabled_apis]
}

# 2. Payment Service (gRPC)
resource "google_cloud_run_v2_service" "paymentservice" {
  name     = "${var.name_prefix}-paymentservice"
  location = var.region
  ingress  = "INGRESS_TRAFFIC_ALL"

  template {
    containers {
      image = "${var.container_registry}/paymentservice:${var.container_image_tag}"
      ports {
        name           = "h2c"
        container_port = 50051
      }
      env {
        name  = "DISABLE_PROFILER"
        value = "1"
      }
      resources {
        limits = {
          cpu    = "1000m"
          memory = "512Mi"
        }
      }
    }
  }

  depends_on = [google_project_service.enabled_apis]
}

# 3. Shipping Service (gRPC)
resource "google_cloud_run_v2_service" "shippingservice" {
  name     = "${var.name_prefix}-shippingservice"
  location = var.region
  ingress  = "INGRESS_TRAFFIC_ALL"

  template {
    containers {
      image = "${var.container_registry}/shippingservice:${var.container_image_tag}"
      ports {
        name           = "h2c"
        container_port = 50051
      }
      resources {
        limits = {
          cpu    = "1000m"
          memory = "512Mi"
        }
      }
    }
  }

  depends_on = [google_project_service.enabled_apis]
}

# 4. Currency Service (gRPC)
resource "google_cloud_run_v2_service" "currencyservice" {
  name     = "${var.name_prefix}-currencyservice"
  location = var.region
  ingress  = "INGRESS_TRAFFIC_ALL"

  template {
    containers {
      image = "${var.container_registry}/currencyservice:${var.container_image_tag}"
      ports {
        name           = "h2c"
        container_port = 7000
      }
      env {
        name  = "DISABLE_PROFILER"
        value = "1"
      }
      resources {
        limits = {
          cpu    = "1000m"
          memory = "512Mi"
        }
      }
    }
  }

  depends_on = [google_project_service.enabled_apis]
}

# 5. Product Catalog Service (gRPC)
resource "google_cloud_run_v2_service" "productcatalogservice" {
  name     = "${var.name_prefix}-productcatalogservice"
  location = var.region
  ingress  = "INGRESS_TRAFFIC_ALL"

  template {
    containers {
      image = "${var.container_registry}/productcatalogservice:${var.container_image_tag}"
      ports {
        name           = "h2c"
        container_port = 3550
      }
      resources {
        limits = {
          cpu    = "1000m"
          memory = "512Mi"
        }
      }
    }
  }

  depends_on = [google_project_service.enabled_apis]
}

# 6. Recommendation Service (gRPC)
resource "google_cloud_run_v2_service" "recommendationservice" {
  name     = "${var.name_prefix}-recommendationservice"
  location = var.region
  ingress  = "INGRESS_TRAFFIC_ALL"

  template {
    containers {
      image = "${var.container_registry}/recommendationservice:${var.container_image_tag}"
      ports {
        name           = "h2c"
        container_port = 8080
      }
      env {
        name  = "PRODUCT_CATALOG_SERVICE_ADDR"
        value = "${replace(google_cloud_run_v2_service.productcatalogservice.uri, "https://", "")}:443"
      }
      env {
        name  = "ENABLE_PROFILER"
        value = "0"
      }
      resources {
        limits = {
          cpu    = "1000m"
          memory = "512Mi"
        }
      }
    }
  }

  depends_on = [google_project_service.enabled_apis]
}

# 7. Ad Service (gRPC)
resource "google_cloud_run_v2_service" "adservice" {
  name     = "${var.name_prefix}-adservice"
  location = var.region
  ingress  = "INGRESS_TRAFFIC_ALL"

  template {
    containers {
      image = "${var.container_registry}/adservice:${var.container_image_tag}"
      ports {
        name           = "h2c"
        container_port = 9555
      }
      resources {
        limits = {
          cpu    = "1000m"
          memory = "512Mi"
        }
      }
    }
  }

  depends_on = [google_project_service.enabled_apis]
}

# 8. Cart Service (gRPC - In-Memory Store)
resource "google_cloud_run_v2_service" "cartservice" {
  name     = "${var.name_prefix}-cartservice"
  location = var.region
  ingress  = "INGRESS_TRAFFIC_ALL"

  template {
    containers {
      image = "${var.container_registry}/cartservice:${var.container_image_tag}"
      ports {
        name           = "h2c"
        container_port = 7070
      }
      resources {
        limits = {
          cpu    = "1000m"
          memory = "512Mi"
        }
      }
    }
  }

  depends_on = [google_project_service.enabled_apis]
}

# 9. Checkout Service (gRPC)
resource "google_cloud_run_v2_service" "checkoutservice" {
  name     = "${var.name_prefix}-checkoutservice"
  location = var.region
  ingress  = "INGRESS_TRAFFIC_ALL"

  template {
    containers {
      image = "${var.container_registry}/checkoutservice:${var.container_image_tag}"
      ports {
        name           = "h2c"
        container_port = 5050
      }
      env {
        name  = "PRODUCT_CATALOG_SERVICE_ADDR"
        value = "${replace(google_cloud_run_v2_service.productcatalogservice.uri, "https://", "")}:443"
      }
      env {
        name  = "SHIPPING_SERVICE_ADDR"
        value = "${replace(google_cloud_run_v2_service.shippingservice.uri, "https://", "")}:443"
      }
      env {
        name  = "PAYMENT_SERVICE_ADDR"
        value = "${replace(google_cloud_run_v2_service.paymentservice.uri, "https://", "")}:443"
      }
      env {
        name  = "EMAIL_SERVICE_ADDR"
        value = "${replace(google_cloud_run_v2_service.emailservice.uri, "https://", "")}:443"
      }
      env {
        name  = "CURRENCY_SERVICE_ADDR"
        value = "${replace(google_cloud_run_v2_service.currencyservice.uri, "https://", "")}:443"
      }
      env {
        name  = "CART_SERVICE_ADDR"
        value = "${replace(google_cloud_run_v2_service.cartservice.uri, "https://", "")}:443"
      }
      env {
        name  = "ENABLE_PROFILER"
        value = "0"
      }
      resources {
        limits = {
          cpu    = "1000m"
          memory = "512Mi"
        }
      }
    }
  }

  depends_on = [google_project_service.enabled_apis]
}

# 10. Frontend Service (HTTP Web Application)
resource "google_cloud_run_v2_service" "frontend" {
  name     = "${var.name_prefix}-frontend"
  location = var.region
  ingress  = "INGRESS_TRAFFIC_ALL"

  template {
    containers {
      image = "${var.container_registry}/frontend:${var.container_image_tag}"
      ports {
        container_port = 8080
      }
      env {
        name  = "PRODUCT_CATALOG_SERVICE_ADDR"
        value = "${replace(google_cloud_run_v2_service.productcatalogservice.uri, "https://", "")}:443"
      }
      env {
        name  = "CURRENCY_SERVICE_ADDR"
        value = "${replace(google_cloud_run_v2_service.currencyservice.uri, "https://", "")}:443"
      }
      env {
        name  = "CART_SERVICE_ADDR"
        value = "${replace(google_cloud_run_v2_service.cartservice.uri, "https://", "")}:443"
      }
      env {
        name  = "RECOMMENDATION_SERVICE_ADDR"
        value = "${replace(google_cloud_run_v2_service.recommendationservice.uri, "https://", "")}:443"
      }
      env {
        name  = "SHIPPING_SERVICE_ADDR"
        value = "${replace(google_cloud_run_v2_service.shippingservice.uri, "https://", "")}:443"
      }
      env {
        name  = "CHECKOUT_SERVICE_ADDR"
        value = "${replace(google_cloud_run_v2_service.checkoutservice.uri, "https://", "")}:443"
      }
      env {
        name  = "AD_SERVICE_ADDR"
        value = "${replace(google_cloud_run_v2_service.adservice.uri, "https://", "")}:443"
      }
      env {
        name  = "SHOPPING_ASSISTANT_SERVICE_ADDR"
        value = "disabled:80"
      }
      env {
        name  = "ENABLE_PROFILER"
        value = "0"
      }
      resources {
        limits = {
          cpu    = "1000m"
          memory = "512Mi"
        }
      }
    }
  }

  depends_on = [google_project_service.enabled_apis]
}
