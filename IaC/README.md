3-Tier Architecture Setup with Terraform & Ansible on Azure
This demonstrates how to deploy and secure a 3-tier application architecture (Frontend, Backend, and Database) in Azure using Terraform and Ansible. The infrastructure is secured with Network Security Groups (NSGs), which lock down access to the Frontend tier, and the application is configured using Ansible.

Pre-requisites:
1. Install Terraform
Download and install Terraform.
2. Install Ansible
Download and install Ansible.
3. Azure Subscription
Ensure you have access to an Azure subscription with admin rights.
az account set --subscription <subscription_id>
4. Service Principal for Terraform
Create a Service Principal for Terraform to interact with Azure resources:
az ad sp create-for-rbac --name terraform-sp --role Contributor --scopes /subscriptions/<subscription_id>/resourceGroups/<resource_group_name>
This will output a JSON object with client_id, client_secret, tenant_id, and subscription_id. These credentials are needed for Terraform.

Overview of the Architecture
The architecture consists of three tiers:

Frontend Tier: Exposes a web application (e.g., Nginx) to external users.
Backend Tier: Hosts application logic, which only the Frontend can access.
Database Tier: Stores data, with access restricted to only the Backend.

The network setup includes:
Virtual Network (VNet) with three subnets:
frontend-subnet (Public-facing)
backend-subnet (Private)
db-subnet (Private)
Network Security Groups (NSGs) applied to restrict traffic:
Frontend access is restricted to a specific IP or IP range.
Backend and Database access is isolated.
Virtual Machines (VMs) for each tier are provisioned using Terraform.

Deployment Steps
1. Deploy Infrastructure Using Terraform
Clone the repository to your local machine.
git clone <repository-url>
cd <repository-name>

#Set up your Azure credentials in Terraform by adding your Service Principal credentials to your environment variables:
export ARM_CLIENT_ID=<client_id>
export ARM_CLIENT_SECRET=<client_secret>
export ARM_SUBSCRIPTION_ID=<subscription_id>
export ARM_TENANT_ID=<tenant_id>

#Initialize Terraform: Run the following command to initialize the Terraform configuration:
terraform init
#Review the Terraform Plan: Run the following command to see what resources will be created:
terraform plan
#Apply the Terraform Plan: Deploy the resources in Azure by running:
terraform apply
#Confirm the action when prompted (yes).

Once the infrastructure is provisioned, Terraform will output the Frontend VM IP address, which can be used to access the application.

2. Configure the Application Using Ansible
After the infrastructure is deployed, use Ansible to configure the application on the VMs and apply security settings.

Update the inventory file: In the inventory/ directory, update the inventory file with the IP addresses of the VMs created by Terraform. For example:

ini
Copy code
[frontend]
<frontend_vm_ip>

[backend]
<backend_vm_ip>

[db]
<db_vm_ip>

Run the Ansible Playbook: Execute the following Ansible playbook to secure and configure the application:
ansible-playbook -i inventory/hosts secure-app.yml

3. Configuration Overview
Network Setup (Terraform)
Virtual Network (VNet):

Address Space: 10.0.0.0/16
Subnets:
frontend-subnet: 10.0.1.0/24
backend-subnet: 10.0.2.0/24
db-subnet: 10.0.3.0/24
Network Security Groups (NSGs):

Frontend NSG: Allows HTTP (port 80) access from specific IPs (x.x.x.x/32).
Backend NSG: Allows communication from the Frontend tier on port 8080.
Database NSG: Restricts DB access to only the Backend on port 1433.
VM Setup (Terraform)
Frontend VM:
Installed: Nginx web server
Public IP address assigned
Configured to allow HTTP access on port 80
Backend VM:
Installed necessary backend packages
Configured to communicate with the Frontend and Database VM
Database VM:
Installed database (SQL Server, MySQL, etc.)
Configured to only accept traffic from the Backend VM
Application Configuration (Ansible)

The Ansible playbook configures the VMs as follows:
Frontend: Installs Nginx and configures it to secure HTTP headers, disable server tokens, and ensure secure app configurations.
Backend: Ensures necessary backend packages are installed and secures communication with the Frontend.
Database: Secures database access and configures firewalls to restrict traffic.

4. Security Measures
NSGs: Each subnet has its own Network Security Group to restrict access based on IP and port.
Firewall Rules: Ansible configures firewalls on each VM to allow only required traffic.
Application Security: The Nginx web server is secured by disabling unnecessary HTTP headers.
