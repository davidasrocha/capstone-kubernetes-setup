You need to have configure some resources to execute correctly this pipeline in Jenkins.

## Requirements

* [Jenkins AWS Pipeline](https://github.com/jenkinsci/pipeline-aws-plugin)

## How to execute

You need to create a new credential `AWS_DEVOPS` using AWS User Credentials.

![alt jenkins credential](./images/jenkins-credential.png)

And, you have a S3 Bucket named `capstone-cicd-storage-eks-configs` in `us-west-2` region.

![alt s3 buckets](./images/aws-s3-buckets.png)
