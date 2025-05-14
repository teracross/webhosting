- terraform documentation: https://registry.terraform.io/providers/hashicorp/aws/latest/docs

- checking configs: https://medium.com/@frankpromiseedah/hosting-a-static-website-on-aws-s3-using-terraform-e12addd22d18

- local testing via localstack: https://docs.localstack.cloud/user-guide/integrations/terraform/#:~:text=To%20heuristically%20detect%20whether%20your,available%20on%20the%20Terraform%20Registry.

- localized AWS cli commands for localstack: https://github.com/localstack/awscli-local

- handling css and html files in S3: https://pfertyk.me/2023/01/creating-a-static-website-with-terraform-and-aws/

- using CloudFront to serve static website via OAC: https://repost.aws/knowledge-center/cloudfront-serve-static-website

- restrict s3 bucket access through VPC: https://repost.aws/knowledge-center/s3-access-bucket-restricted-to-vpc

- restricting access to s3 origin: https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/private-content-restricting-access-to-s3.html#:~:text=Select%20the%20S3%20origin%20that,Choose%20Save%20changes.

- creating OIDC provider for GitHub Actions to interface with AWS for deployment: 
     - https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_create_oidc.html?icmpid=docs_iam_help_panel_create#manage-oidc-provider-console
     
     - https://mahendranp.medium.com/configure-github-openid-connect-oidc-provider-in-aws-b7af1bca97dd

- composite GitHub Actions: https://medium.com/@gallaghersam95/the-best-terraform-cd-pipeline-with-github-actions-6ecbaa5f3762

- actions/download-artifact@v4 documentation: https://github.com/actions/download-artifact

- actions/upload-artifact@v4 documentation: https://github.com/actions/upload-artifact

- permissions required for Github access token: https://docs.github.com/en/actions/security-for-github-actions/security-guides/automatic-token-authentication#permissions-for-the-github_token

- implementation for obtain previous workflow run id: https://stackoverflow.com/questions/64868918/how-to-download-artifact-release-asset-in-another-workflow

- context avaible under github context in workflows: https://docs.github.com/en/actions/writing-workflows/choosing-what-your-workflow-does/accessing-contextual-information-about-workflow-runs#github-context

- Github CLI (Command Line Interface): https://docs.github.com/en/github-cli/github-cli/github-cli-reference

- JQ the command-line JSON processor (can be used in-line with Github CLI output to filter/ process output data): https://docs.github.com/en/github-cli/github-cli/github-cli-reference