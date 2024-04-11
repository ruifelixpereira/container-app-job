#!/bin/bash

# Display Help message
Help()
{
   # Display Help
   echo "Deploy Azure Container App Job."
   echo
   echo "Syntax: ./action-pre-build.sh [-h|i|t]"
   echo "options:"
   echo "h     Print this Help."
   echo "i     Container image name."
   echo "t     Container image tag."
   echo
}

# Check input options
while getopts "hi:t:" option; do
   case $option in
      h) # display Help
         Help
         exit;;
      i) # Enter the container image name
         imageName=$OPTARG;;
      t) # Enter the container image tag
         imageTag=$OPTARG;;
     \?) # Invalid option
         Help
         exit;;
   esac
done

# mandatory arguments
if [ ! "$imageName" ]; then
  echo "arguments -i with container image name must be provided"
  Help; exit 1
fi

if [ ! "$imageTag" ]; then
  echo "arguments -t with container image tag must be provided"
  Help; exit 1
fi

#
# Create/Get a container app job
#
job_query=$(az containerapp job --query "[?name=='$JOB_NAME-job']")
if [ "$job_query" == "[]" ]; then
    echo -e "\nCreating container app job '$JOB_NAME-job'"
    az containerapp job create --name "$JOB_NAME-job" --resource-group "$RESOURCE_GROUP" \
      --environment "$JOB_NAME-env" \
      --trigger-type "Schedule" \
      --replica-timeout 1800 \
      --replica-retry-limit 3 \
      --image $CONTAINER_REGISTRY_NAME.azurecr.io/$imageName:$imageTag \
      --registry-server $CONTAINER_REGISTRY_NAME.azurecr.io \
      --registry-username $REGISTRY_USERNAME \
      --registry-password $REGISTRY_PASSWORD \
      --cpu "0.25" \
      --memory "0.5Gi" \
      --cron-expression "*/1 * * * *"
else
    echo "Container app job $JOB_NAME-job already exists."
fi

