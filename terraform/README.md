# Terraform scenarios

dev - gamedragon project
lt - load testing environment
lt2 - load testing environment 2 (for federation testing purposes)
prod - production

templates - configuration templates 

Quick Start
-----------

To start using this scripts:

    # Install latest terraform from https://www.terraform.io/downloads.html 
    wget https://releases.hashicorp.com/terraform/0.11.13/terraform_0.11.13_linux_amd64.zip
    unzip terraform_0.11.13_linux_amd64.zip
    sudo mv terraform /usr/bin/terraform
    
    # Change dir to environment you want to manage
    cd ops/terraform/dev
    
    # Create provider configuration and paste you credentials there
    cp ../templates/provider.tf.template ./provider.tf
    
    # Download plugins
    terraform init    
