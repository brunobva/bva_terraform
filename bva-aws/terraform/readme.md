# Terraform Demo by Bruno Moraes

Here we are showing how to create a infrastructure at AWS, using the IaC tool Terraform.

We are creating a t2.micro Ubuntu instance with a custom VPC configuration.

We are doing it follow this steps:

> terraform init # to initialize the configuration and install the depencies required

> terraform plan -out bvaplan* # to keep the changes that are being modified in our AWS Lab

> terraform apply "bvaplan*" # To apply and confirm all changes that was showed into terraform plan.

For pratice and using best pratices, we ran those commands also:

> terraform fmt # to format all files and let them "pretty" :D

> terraform validate # this step is before Terraform Plan, because it show if there is some error os something mispelled on our files.

I hope you enjoy it and please, I know that could be more advance. Fell free to contact me to increase those files and learn together.

Thanks and appreciate your time.

Bruno Moraes
Twitter - brunomor7
Instagram - brunomor7
Skype - bruno@bvaconsultoria.com.br
Mail - bruno@bvaconsultoria.com.br