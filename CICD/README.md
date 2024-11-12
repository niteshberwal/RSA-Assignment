Node.js Hello World with Docker, SonarCloud, and Azure DevOps Pipeline
This project demonstrates how to build and deploy a simple Node.js "Hello World" application.

GitHub Actions for CI/CD integration.
SonarCloud for code quality analysis.
Docker for containerizing the application.
Azure DevOps Pipeline for automating the build, test, analysis, and deployment process.

Prerequisites
Before setting up the pipeline, ensure you have the following prerequisites:

GitHub Repository: The project is hosted on GitHub.
Docker: Docker should be installed and configured on your local machine.
DockerHub Account: You need a DockerHub account for pushing the Docker image.
Azure DevOps Account: You need access to an Azure DevOps project where you can create pipelines.
SonarCloud Account: A SonarCloud account for code quality analysis.
Steps to Set Up the Project

Clone the Repository:
Clone this repository to your local machine or create your own GitHub repository with the same structure.

git clone https://github.com/<your-github-username>/nodejs-hello-world.git
cd nodejs-hello-world
Fork/Clone the Node.js Hello World App: If you haven't already, you can fork or clone the fhinkel/nodejs-hello-world repository which is a simple Node.js app that will be used in this project.

git clone https://github.com/fhinkel/nodejs-hello-world.git
This repo contains a simple Node.js app and a Dockerfile for building the Docker image.

Azure DevOps Pipeline Configuration: This project uses an Azure DevOps pipeline for automating CI/CD. The pipeline is defined in pipelines.yml and is triggered by changes to the main branch.

Configure Secrets in Azure DevOps: In order to push images to DockerHub and run SonarCloud analysis, you need to configure secrets in Azure DevOps:

DOCKER_USERNAME: Your DockerHub username.
DOCKER_PASSWORD: Your DockerHub password.
SONAR_TOKEN: Your SonarCloud API token.
To add secrets:

Go to Azure DevOps > Project Settings > Pipelines > Library.
Create a Variable Group and add the above secrets.
SonarCloud Setup:

Go to SonarCloud.
Link GitHub account and set up a new project for the fhinkel/nodejs-hello-world repository.
Find the SonarCloud Project Key and Organization Key and add them as variables in the Azure DevOps pipeline YAML.
DockerHub Setup:

Create a DockerHub account.
Create a repository for this app on DockerHub (e.g., yourusername/nodejs-hello-world).
