#A simple node app by Kunal Verma. I have written a shell script to build a golden image using packer, and also terraform file for deployment. These can be done automatically with a single shell script (main.sh) -p flag is for packer image building, -a flag for deployment using terraform and -d flag to destroy provisioned items via terraform. -a and -d flags are not to be used together.

Variables Required:

1. Terraform : 
i) account_id: The Account ID of the owner of the image.
ii) key_name: Name of the keypair to be used to create the instance (ensure that you already have created a keypair prior to this via on AWS.)

2. Packer:
You can leave the following three to be defaults if you want Ubuntu Jammy as base image.
i) base_ami_owner : AWS Account ID of the base ami owner (In this case, Canonical for Ubuntu.)
ii) base_ami_name: The address for the base ami
iii) ami_ssh_username: AS the name describes, the username to be used to ssh into the instance.

The below variable is important, and so please review it before proceeding with image-building.

        iv) build_instance_type: Declares the type and size of instance that is used to build the image (Source AWS Instance). I have set t3.medium as a default, but discretion is advised as costs will be incurred.