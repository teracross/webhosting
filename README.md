# webhosting
Project utilizing various DevOps tech stacks for web hosting.

# key takeaways
- it is possible to create an s3 bucket without direct public access and utilize CloudFront as CDN to serve content to the public
     - in order to do so s3 SHOULD NOT have website configuration enabled


# references
References that were handy/ useful for this project: [references.md](/references.md)

#  local testing
Note - s3 bucket website is aved on http://<bucket_name>.s3-website.localhost.localstack.cloud:4566

In order to test locally, `tflocal` was used in conjunction with localstack to emulate an AWS-like environment. However, one downside with this approach is that the actual bucket policy permissions will need to be tested on real AWS. 


# TODOs/ future changes

* [ ] move html page and css import to python script 
* [ ] pull changes directly from Google Docs file
* [ ] add deployment configuration for ansible
* [ ] add github actions CI/CD 
* [ ] add AWS CodePipline CI/CD
* [ ] add localstack testing to CI/CD pipeline to verify html page works