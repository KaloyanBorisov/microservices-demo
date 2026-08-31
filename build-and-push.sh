#!/usr/bin/env bash
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

set -euo pipefail

# Configuration
PROJECT_ID="${1:-${GCP_PROJECT_ID:-}}"
REGION="${2:-us-central1}"
REPOSITORY="${3:-online-boutique}"
TAG="${4:-latest}"

if [[ -z "${PROJECT_ID}" ]]; then
  echo "Error: GCP Project ID is required."
  echo "Usage: ./build-and-push.sh <PROJECT_ID> [REGION] [REPOSITORY] [TAG]"
  echo "Example: ./build-and-push.sh my-gcp-project us-central1 online-boutique latest"
  exit 1
fi

REGISTRY_PREFIX="${REGION}-docker.pkg.dev/${PROJECT_ID}/${REPOSITORY}"

echo "=========================================================="
echo "Project ID: ${PROJECT_ID}"
echo "Registry:   ${REGISTRY_PREFIX}"
echo "Tag:        ${TAG}"
echo "=========================================================="

# Ensure Artifact Registry repository exists
echo "Checking / creating Artifact Registry repository '${REPOSITORY}'..."
gcloud artifacts repositories describe "${REPOSITORY}" --location="${REGION}" --project="${PROJECT_ID}" >/dev/null 2>&1 || \
gcloud artifacts repositories create "${REPOSITORY}" \
  --repository-format=docker \
  --location="${REGION}" \
  --description="Online Boutique Docker images" \
  --project="${PROJECT_ID}"

# Configure Docker authentication for Artifact Registry
echo "Configuring Docker authentication..."
gcloud auth configure-docker "${REGION}-docker.pkg.dev" --quiet

SERVICES=(
  "adservice"
  "cartservice/src"
  "checkoutservice"
  "currencyservice"
  "emailservice"
  "frontend"
  "paymentservice"
  "productcatalogservice"
  "recommendationservice"
  "shippingservice"
)

for svc_path in "${SERVICES[@]}"; do
  svc_name="$(basename "${svc_path}")"
  if [[ "${svc_path}" == "cartservice/src" ]]; then
    svc_name="cartservice"
  fi

  image_name="${REGISTRY_PREFIX}/${svc_name}:${TAG}"
  echo "--------------------------------------------------------"
  echo "Building and pushing ${svc_name} -> ${image_name}..."
  echo "--------------------------------------------------------"

  docker build -t "${image_name}" -f "src/${svc_path}/Dockerfile" ./src/
  docker push "${image_name}"
done

echo ""
echo "=========================================================="
echo "✅ All images built and pushed successfully!"
echo "Update terraform.tfvars with:"
echo "container_registry  = \"${REGISTRY_PREFIX}\""
echo "container_image_tag = \"${TAG}\""
echo "=========================================================="
