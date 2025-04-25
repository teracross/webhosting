# webhosting
Project utilizing various DevOps tech stacks for web hosting.

# key takeaways
- it is possible to create an s3 bucket without direct public access and utilize CloudFront as CDN to serve content to the public
     - in order to do so s3 SHOULD NOT have website configuration enabled
- Google Cloud permissioning for direct access to a single Google Drive file is not so straightforward
- On Github, secrets stored under Secrets and Variables -> Actions can be accessed by anyone with collaborator access. Secrets and Variables -> Codespaces are encrypted, not passed to forks and are not accessible by all collaborators. 
- Github Codespaces secrets are NOT accessible in Github Actions Workflows.
- [Reusable Workflows](https://docs.github.com/en/actions/sharing-automations/reusing-workflows#creating-a-reusable-workflow) as well as more info on [Reusing Workflows](https://docs.github.com/en/actions/sharing-automations/reusing-workflows)
- [Job Outputs](https://docs.github.com/en/actions/writing-workflows/choosing-what-your-workflow-does/passing-information-between-jobs)
Note - most common way to store variables in Github involves using and echo statemnt where a value is stored in variable and then piping the result of that statement into the `$GITHB_OUTPUT` environment variable, ex: 
```
echo "MY_VAR=value" >> $GITHUB_OUTPUT
```
- Workflow Call and Workflow Dispatch events can be triggered on any branch, HOWEVER Workflow Run will ONLY trigger on the main branch [Github Documentation on Workflow Events]
(https://docs.github.com/en/actions/writing-workflows/choosing-when-your-workflow-runs/events-that-trigger-workflows#workflow_call)
- BEWARE of the ":" character when doing command-line substitutions
- Composite actions allow for chaining simple job steps commands together to be executed in a single, reusable step (See [Composite Action](https://docs.github.com/en/actions/sharing-automations/creating-actions/creating-a-composite-action))
- Nested expressions are NOT supported by Github actions and instead requires the use of the `format` function. For more information on evaluating expresssions in workflows and actions, see [here](https://docs.github.com/en/actions/writing-workflows/choosing-what-your-workflow-does/evaluate-expressions-in-workflows-and-actions#format)


# references
References that were handy/ useful for this project: [references.md](/references.md)

#  local testing
Note - s3 bucket website is saved on http://<bucket_name>.s3-website.localhost.localstack.cloud:4566

In order to test locally, `tflocal` was used in conjunction with localstack to emulate an AWS-like environment. However, one downside with this approach is that the actual bucket policy permissions will need to be tested on real AWS. 


# TODOs/ future changes

* [X] ~~move html page and css import to python script~~ (downloading file directly from Google Drive)
* [X] pull changes directly from Google Docs file
* [ ] add deployment configuration for ansible
* [X] add github actions CI/CD 
* [ ] add AWS CodePipline CI/CD
* [x] ~~~add localstack testing to CI/CD pipeline to verify html page works~~ (using Google Drive direct download to HTML file)
* [ ] create repository(s) to build Docker images used for downloading the Google Drive file and another image for deploying resources (justification - potential setup/ startup efficiency gain on CI/CD environment initiation)
* [ ] Refactor the [download.yaml](.github/workflows/download.yaml) and [deploy.yaml](.github/workflows/deploy.yaml) so that the deploy workflow calls the download workflow instead. (Triggering things from the download workflow initially allowed for easier testing.)