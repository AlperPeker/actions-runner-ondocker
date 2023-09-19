#!/bin/bash

SERVER_URL=$SERVER_URL
ORGANIZATION=$ORGANIZATION
ACCESS_TOKEN=$ACCESS_TOKEN

REG_TOKEN=$(curl -X POST -H "Authorization: token ${ACCESS_TOKEN}" -H "Accept: application/vnd.github.v3+json" ${SERVER_URL}/api/v3/orgs/${ORGANIZATION}/actions/runners/registration-token | jq .token --raw-output)
export REG_TOKEN=${REG_TOKEN}
cd /home/docker/actions-runner
./config.sh --url ${SERVER_URL}/${ORGANIZATION} --token ${REG_TOKEN}

cleanup() {
    echo "Removing runner..."
    ./config.sh remove --unattended --token ${REG_TOKEN}
}

trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

./run.sh & wait $!