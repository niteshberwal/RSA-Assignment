Azure Infrastructure Setup with Terraform
This guide will walk you through the steps to set up an Azure environment using Terraform. It includes the creation of:

Network ACLs via Network Security Groups (NSGs)
Route definitions for application connectivity
An Azure Function App running a simple "Hello World" app
A Bastion Host for secure access to the network
A simple HTTP trigger function to display a "Hello World" message
Prerequisites
Before you begin, make sure you have the following tools installed and configured:

Terraform: Install Terraform
Azure CLI: Install Azure CLI and authenticate using az login
Azure Subscription: Ensure you have admin access to an Azure subscription.
Steps
1. Clone the Repository
git clone https://your-repo-url.git
cd your-repo-name

2. Define the Azure Resources in main.tf

3. Initialize Terraform
terraform init

4. Apply Terraform Configuration
Once you've defined all resources in your main.tf, you can apply the configuration to provision the resources.

Plan the Deployment
Terraform will show you an execution plan, which helps you see what resources will be created, modified, or destroyed.
terraform plan
Apply the Configuration
After reviewing the plan, apply the configuration to provision the resources.
terraform apply

5. Access the Resources
After the resources are provisioned, you can:

Access the Azure Function App via the public URL provided in the Terraform output.
Connect to the Bastion Host to securely access VMs inside the virtual network.
Test the Hello World function by navigating to the Function App's URL or invoking the endpoint via curl.
Accessing the Function App:
Once the function app is deployed, you can access it via the provided endpoint. The function should respond with a "Hello World!" message when accessed via HTTP GET.

Example URL (replace with actual Function URL):
https://my-function-app.azurewebsites.net/api/HelloWorld
Accessing via Bastion:
To access any VM or resource that’s behind the Bastion Host, you can use the Azure Portal to initiate an RDP or SSH session. The Bastion Host will act as a secure jump server.
