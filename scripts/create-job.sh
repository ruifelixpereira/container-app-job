#!/bin/bash

#
# Create/Get a container app job
#
job_query=$(az containerapp job --query "[?name=='$JOB_NAME']")
if [ "$job_query" == "[]" ]; then
    echo -e "\nCreating container app job '$JOB_NAME'"
    az containerapp job create --name "$JOB_NAME" --resource-group "$RESOURCE_GROUP" \
      --environment "$JOB_NAME-env" \
      --trigger-type "Schedule" \
      --replica-timeout 1800 \
      --replica-retry-limit 3 \
      --image "$containerImage" \
      --registry-server $CONTAINER_REGISTRY_NAME.azurecr.io \
      --registry-username $REGISTRY_USERNAME \
      --registry-password $REGISTRY_PASSWORD \
      --cpu "0.25" \
      --memory "0.5Gi" \
      --cron-expression "*/1 * * * *"
else
    echo "Container app job $jobName already exists."
fi

