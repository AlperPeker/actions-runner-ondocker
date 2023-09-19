# GitHub Actions Runner on Docker Containers

The purpose of the repo is to create as many self-hosted GitHub actions-runners as system resources allow with a single command and include them in your organization.

This process is completed in 3 stages and uses a file for each stage.

## FILES

### 1. Dockerfile
Dockerfile aims to download the necessary runner files and prepare the environment where the runner will be installed.

_**NOTE**_: The runner version has been made variable in order to facilitate update operations. The RUNNER_VERSION variable in the Dockerfile can be set to the desired version number

### 2. start.sh
The script aims to register and remove the runner to the GitHub server after the environment installation is complete. 

This file contains 3 important variable definitions.

<table>
  <tr>
    <td>SERVER_URL</td>
    <td>URL of your GitHub enterprise server</td>
  </tr>
  <tr>
    <td>ORGANIZATION</td>
    <td>Name of the organization to which the Runner will be added</td>
  </tr>
  <tr>
    <td>ACCESS_TOKEN</td>
    <td>PAT of a user with the necessary permissions to add the Runner
</td>
  </tr>
</table>



### 3. docker-compose.yml
With the Compose file, it is ensured that multiple runners can complete the operations. It is recommended to optimize the number of replicas and resource limits in this file according to the system being worked on.

In addition, the values of the variables defined in start.sh **MUST** be defined in docker-compose.yml.

## USAGE


After cloning the files, these are the steps to be done:

### 1. Image Creation
Create an image using Dockerfile

```
$ cd actions-runner
$ docker build --tag <IMAGE_NAME> .
```

### 2(a). Creating Container by Running Image
It is possible to stand the runners up one by one. While doing this, remember that you need to include the values of the variables we defined in the docker-compose file in the command.

```
$ docker run --detach \
  --env SERVER_URL=<YOUR_GITHUB_SERVER_URL>
  --env ORGANIZATION=<YOUR_GITHUB_ORGANIZATION> \
  --env ACCESS_TOKEN=<YOUR_GITHUB_ACCESS_TOKEN> \
  --name actions-runner <IMAGE_NAME>
```

### 2(b). Creating Containers with Docker-Compose
With docker-compose, you can manage multiple containers at the same time. In this step, make sure that you give the correct image name defined in the compose file.

_**NOTE**_: Keep in mind that you need to review the number of replicas considering the resources of your system. Otherwise, it is possible to experience slowdowns or instabilities in the system.

```
$ docker-compose up -d --scale runner=2

```