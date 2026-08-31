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

variable "gcp_project_id" {
  type        = string
  description = "The Google Cloud Project ID where resources will be deployed."
}

variable "region" {
  type        = string
  description = "Google Cloud region for Cloud Run and supporting services."
  default     = "us-central1"
}

variable "name_prefix" {
  type        = string
  description = "Prefix prepended to resource names."
  default     = "boutique"
}

variable "container_registry" {
  type        = string
  description = "Container image registry path prefix (e.g. gcr.io/google-samples/microservices-demo or your Artifact Registry)."
  default     = "gcr.io/google-samples/microservices-demo"
}

variable "container_image_tag" {
  type        = string
  description = "Image tag for the microservice images."
  default     = "v0.10.1"
}
