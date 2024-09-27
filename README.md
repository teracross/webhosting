# webhosting
Project utilizing various DevOps tech stacks for web hosting.


# references
References that were handy/ useful for this project: 
- terraform documenation: https://registry.terraform.io/providers/hashicorp/aws/latest/docs

- checking configs: https://medium.com/@frankpromiseedah/hosting-a-static-website-on-aws-s3-using-terraform-e12addd22d18

- local testing via localstack: https://docs.localstack.cloud/user-guide/integrations/terraform/#:~:text=To%20heuristically%20detect%20whether%20your,available%20on%20the%20Terraform%20Registry.

- localized AWS cli commands for localstack: https://github.com/localstack/awscli-local

- handling css and html files in S3: https://pfertyk.me/2023/01/creating-a-static-website-with-terraform-and-aws/


#  local testing
Note - s3 bucket website is aved on http://<bucket_name>.s3-website.localhost.localstack.cloud:4566

In order to test locally, `tflocal` was used in conjunction with localstack to emulate an AWS-like environment. However, one downside with this approach is that the actual bucket policy permissions will need to be tested on real AWS. 


# TODODs/ future changes

* [ ] move html page and css import to python script 
* [ ] pull changes directly from Google Docs file
* [ ] add deployment configuration for ansible
* [ ] add github actions CI/CD 
* [ ] add AWS CodePipline CI/CD
* [ ] add localstack testing to CI/CD pipeline to verify html page works