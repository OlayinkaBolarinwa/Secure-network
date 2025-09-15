## Secure Network Architecture ##

Overview



This project demonstrates a secure and scalable network setup on Microsoft Azure using Terraform. It includes multiple virtual networks, network security groups, virtual machines, and VNet peering for private communication between resources.



## Features ##



Resource Group: Centralized resource management.



Virtual Networks & Subnets: Separate VNets for peers with dedicated subnets.



Virtual Machines: Two Ubuntu 22.04 LTS VMs with SSH key-based authentication.



Public IPs: Static public IPs for VMs where needed.



Network Security Groups (NSG): Secured access rules ( SSH).



VNet Peering: Allows secure private communication between VNets.



Terraform-based Infrastructure: Fully automated provisioning and management.



## Requirements ##



Terraform >= 1.5.0



Azure CLI installed and authenticated



SSH key pair (secure_network_key and .pub) for VM access



 ## Getting Started ##

Clone the repository

` git clone https://github.com/OlayinkaBolarinwa/Secure-network.git`

cd Secure-network


Initialize Terraform

terraform init
Plan & Apply Infrastructure

terraform plan

terraform apply



## Verify Resources ##


Use az vm list -g <resource-group> -o table to check VM status.



Ping private IPs or SSH into VMs for connectivity testing.



## Security Notes ##

Do not commit private keys or Terraform state files to GitHub.

Ensure NSG rules follow the principle of least privilege.


All SSH access is key-based; passwords are disabled for VMs.



## Project Structure ##

Secure-Network/

│

├─ main.tf                 
         
         
| vm.tf             

├─ secure\_network\_key.pub  
├─ README.md                
└─ .gitignore               



License



 ## This project is licensed under the MIT License. ##

