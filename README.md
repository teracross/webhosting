# webhosting
Project utilizing various DevOps tech stacks for web hosting.

# key takeaways
- it is possible to create an s3 bucket without direct public access and utilize CloudFront as CDN to serve content to the public
     - in order to do so s3 SHOULD NOT have website configuration enabled
- Google Cloud permissioning for direct access to a single Google Drive file is not so straightforward
- On Github, secrets stored under Secrets and Variables -> Actions can be accessed by anyone with collaborator access. Secrets and Variables -> Codespaces are encrypted, not passed to forks and are not accessible by all collaborators. 
- Github Codespaces secrets are NOT accessible in Github Actions Workflows.
- Github actions/upload-artifact@v4 default working directory cannot be set through `defaults` section in github action YAML.
- Github actions artifacts context is limited to the current workflow being run. In order to access artifacts generated from a previous workflow run the run id, github ref/ branch name and Github PAT (Personal Access Token) with necessary credentials are needed.
- Github actions workflow IDs are based off of the workflow file and unique across the repo. However, they are not unique across branches. For example, the workflow ID of the deploy.yaml file is the same on both branches "main" and "other_branch"
- Github actions called workflow (a.k.a. reusuable workflow) doesn't have access to repository Github actions secrets that calling workflow has access to. Secrets must be passed through individually in either calling workflow in the `with` portion as variables that are passed through -OR- passed through by adding `secrets: inherit` to where the calling workflow calls the called workflow. 

# references
References that were handy/ useful for this project: [references.md](/references.md)

# local testing
Note - s3 bucket website is saved on http://<bucket_name>.s3-website.localhost.localstack.cloud:4566

In order to test locally, `tflocal` was used in conjunction with localstack to emulate an AWS-like environment. However, one downside with this approach is that the actual bucket policy permissions will need to be tested on real AWS. 

# debug steps
In order to enable debugging logging in Github actions, the `ACTIONS_RUNNER_DEBUG` value must be set to true. 

Also, note that in the [download.yaml#L87](.github/workflows/download.yaml#L87) depending on the tag/branch version of the deploy.yaml file to be executed the github branch reference at the end (after the "@") will need to be changed to the desired branch, tag or SHA. 

# TODOs/ future changes

* [X] ~~move html page and css import to python script~~ (downloading file directly from Google Drive)
* [X] pull changes directly from Google Docs file
* [ ] add secure and gated way to delete infra stack 
* [ ] Fix/ Enable WAF with ruleset to allow read-only access
* [ ] add deployment configuration for ansible
* [X] add github actions CI/CD 
* [ ] add AWS CodePipline CI/CD
* ~~[ ] add localstack testing to CI/CD pipeline to verify html page works~~ (using Google Drive direct download to HTML file)
* [ ] explore create repository(s) to build Docker images used for downloading the Google Drive file and another image for deploying resources (justification - potential setup/ startup efficiency gain on CI/CD environment initiation)
* [ ] explore use of semantic versioning triggered through Google AppsScript
* [ ] determine the name of the files cached in the artifact from the download artifact step