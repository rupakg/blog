---
title: "How to build long-running serverless apps using Lambda and AWS Fargate with Stackery"
description: "A step-by-step walkthrough of building a serverless application to run a long-running process with AWS Fargate and Lambda. The app will take a video file and generate a thumbnail for a user-defined frame position."
date: 2018-10-16T16:09:02-04:00
lastmod: 2018-10-16T16:09:02-04:00
keywords : [ "serverless", "AWS", "Fargate", "AWS Fargate", "Lambda", "long-running", "Stackery", "S3", "Docker", "ECS"]
tags : [ "serverless", "Fargate", "long-running", "Stackery", "video processing", "thumbnail generation"]
categories : [ "development", "serverless", "platforms", "docker" ]
layout: post
type:  "post"
---

This is a multi-part blog series that explores building serverless applications with Stackery. In the [first part](https://rupakganguly.com/posts/building-serverless-apps-using-stackery/), we discussed why Stackery is a great platform for visually building and deploying serverless applications on AWS. 

The application we will build is a video processing application that will take a video file dropped into a S3 bucket, along with some user-defined parameters and extract a thumbnail of the specified frame, and store it into another S3 bucket. Since the video processing bit is a long-running process, we will use AWS Fargate to process the video. 
<!--more-->

The events of dropping a video file into the S3 bucket and uploading the resulting thumbnail image into another S3 bucket will be captured by our serverless application for raising notifications to us. I have [written about this in a post](https://medium.com/@rupakg/how-to-use-aws-fargate-and-lambda-for-long-running-processes-in-a-serverless-app-c3712e158bb), where I walk through developing the application using AWS Fargate and the Serverless Framework.

> *AWS Fargate is a technology that allows you to use containers as a fundamental compute primitive without having to manage the underlying compute instances.*

In this post, the second part in the series, we will create the same application, but we will build it **visually using Stackery**. I will walk you through the process of creating the application and show you how easy it is to build it using Stackery.

> **Most importantly:** I have built the application in such a way that it's generic enough to be used as a reference template for *any* long-running processes using Stackery. I will share the Github repo with the Stackery template so you can use it as a boilerplate to start your own project involving AWS Fargate.

**What we'll cover:**

* Application Flow
* Designing the application
    * Creating the project
    * Configuring the AWS Fargate Task
    * Triggering a Lambda function to run the ECS Fargate Task
    * Triggering a Lambda function when thumbnail is generated
* Deploying the application
* Running the application
* Error Handling, Health & Operations

## Application Flow

Let's review the application design. The diagram below and the steps that follow, describe the overall workflow of the the application we're building.

![Architecture Diagram for processing video to generate thumbnail in AWS ECS using Fargate](https://user-images.githubusercontent.com/8188/34815433-4b277d74-f67f-11e7-83a0-9ac65d630eab.png)

1. Upload video to S3
2. S3 triggers a Lambda function when the video is uploaded
3. The Lambda function runs the ECS Fargate Task with appropriate parameters
4. The ECS Fargate Task executes the Docker container:
    * that processes the video file to extract the thumbnail,
    * and uploads the thumbnail image to S3
5. S3 triggers another Lambda function when the thumbnail is uploaded
6. The Lambda function writes the url of the thumbnail to the log

Let's get started!

## Implementation

To start developing our application, we will need a blank template to use with the Stackery Dashboard. Stackery can use a link to a code repository that can be used as a stack template. So I created a [blank stack template](https://github.com/rupakg/stackery-empty-stack-template), that we will use here to create our application. So let's get going!

**Feature Request**: It would be really useful if Stackery Dashboard would include an option of creating a stack using a "Blank Stack Template". 

### Create a new stack

Log into Stackery, and click on the **Create New Stack** button. Then using the blank stack template url, create a new stack named `sls-video-processing-with-fargate`, as shown below:

![image](https://user-images.githubusercontent.com/8188/46175123-ee9e0e80-c278-11e8-8f6a-b704c66ceaa0.png)

You should have a stack with an empty design surface, and a new Github repo named `sls-video-processing-with-fargate`. After Stackery creates the stack, it creates the repo with an initial commit.

### Design

We will need some components (AWS resources) that will make up our application and they are as follows:

* AWS S3 bucket for input video files
* AWS S3 bucket for output thumbnail files
* AWS Fargate ECSTask definition
* AWS Lambda function that is triggered on upload of a video file that will in turn call the Fargate task
* AWS Lambda function that is triggered upon thumbnail creation that will in turn log a message

**Let's visually design the application** using the Stackery Dashboard. Yes, that is the coolest part!

We drag the appropriate components from the Stackery Resource palette to the Stackery Dashboard, so it looks like the following:

![image](https://user-images.githubusercontent.com/8188/46177635-9cadb680-c281-11e8-9acf-d0c5a4ae7a4d.png)

The stack has two **Object Storage** components (S3 Buckets), named `rg-stackery-video-files` and `rg-stackery-thumbnails` respectively. Note Stackery does not allow you to configure specific folders under a bucket so we will use two separate buckets for input and output files.

#### Upload Docker Image to AWS ECR

**This step is optional and can be skipped if you want to use my docker image from DockerHub**. You need this step ONLY if you want the docker image to be uploaded to AWS ECR Registry and use it in your Docker ECS Task.

I have the docker image [rupakg/docker-ffmpeg-thumb](https://github.com/rupakg/docker-ffmpeg-thumb) on DockerHub, and you can upload it to AWS ECR as follows:

* Login to the AWS Console and go to AWS ECS page and click on Amazon ECR -> Repositories
* Create a new repository named `docker-ffmpeg-thumb`
* Click on the new repository that was just created. This screen will list the **Repository URI** which you can use in the following command or you can click on the **View Push Commands** button to view the instrcutions to push the image to ECR.

```
$(aws ecr get-login --no-include-email --region us-east-1)
docker pull rupakg/docker-ffmpeg-thumb
docker tag rupakg/docker-ffmpeg-thumb:latest <repository-uri>
docker push <repository-uri>/docker-ffmpeg-thumb:latest
```

Now, you should have the docker image uploaded to AWS ECR.

#### Configure the AWS Fargate Task

I have the docker image [rupakg/docker-ffmpeg-thumb](https://github.com/rupakg/docker-ffmpeg-thumb) on DockerHub and we will be using it in the DockerTask. The stack has a DockerTask component (ECS Fargate Task), named `stackery-video-to-thumb-task-def` and is configured as follows:

![image](https://user-images.githubusercontent.com/8188/46176805-9b2ebf00-c27e-11e8-9100-f2e9335ca3d1.png)

**Note**: Based on your processing requirements, the values for **CPU Units** and **Memory** will need to be adjusted, or your task will fail.

And, then we also add some **Environment Variables**, that will be used to customize the ECS Task definition. The use of environment variables enables us to keep the ECS Task definition pretty generic and customizable.

![image](https://user-images.githubusercontent.com/8188/46176820-a97cdb00-c27e-11e8-89a3-1c29b3647345.png)

The environment variables we added with their initial values are as follows:

```
AWS_REGION - us-east-1
INPUT_VIDEO_FILE_URL - https://s3.amazonaws.com/your-s3-bucket-name/test.mp4
OUTPUT_S3_PATH - your-s3-bucket-name/your-thumbnail-folder-name
OUTPUT_THUMBS_FILE_NAME  - test.png
POSITION_TIME_DURATION - 00:01
```

These environment variables are used in the docker image to keep the functionality very customizable.

Now let's add two Function components (Lambda Function) named `triggerOnUploadVideoStackery` with a **Source Path** of `src/triggerOnUploadVideoStackery` and `triggerOnThumbnailCreationStackery` with a **Source Path** of `triggerOnThumbnailCreationStackery` respectively. Set the **Memory** to `512` and leave the **Timeout** to its default value of `30`.

Before we do anything else, let's **commit** the design to our underlying Github repo. Keep the default commit message or add your own. 

![image](https://user-images.githubusercontent.com/8188/46177738-062dc500-c282-11e8-913f-d9fe1e8aa825.png)

**Feature Request**: I wish Stackery did not rearrange my layout of components after the commit. I would love an option where I can turn it off. 🙏

Let's review what Stackery did for us here. Going back to the repo, you will see a commit [3057430](https://github.com/rupakg/sls-video-processing-with-fargate/commit/305743031d5bc54b1d133020417c4447d56b5f2e) that shows you a diff of the changes. The commit consists of:

* `src/triggerOnThumbnailCreationStackery/README.md`
* `src/triggerOnThumbnailCreationStackery/index.js`
* `src/triggerOnThumbnailCreationStackery/package.json`
* `src/triggerOnUploadVideoStackery/README.md`
* `src/triggerOnUploadVideoStackery/index.js`
* `src/triggerOnUploadVideoStackery/package.json`
* `template.yaml`

Each function is in its own folder and self-sufficient with it's own dependencies. We will explore other ways to structure code in a later post. But, for now it is important to know that you have the flexibility.

The most important file that is the crux of the application is the `template.yaml` file. Note that **Stackery uses AWS SAM under the hood** to create serverless applications. The `template.yaml` file has a wealth of information that describes the components that we added: configuration, required IAM policies and execution roles. 

**Just stop and think for a minute here**. Think what we provided as input while designing and what we got for free as part of the application model. The two S3 ObjectStore definitions and the two Lambda function definitions has been created automatically. Look at the ECS Task definition portion, and you will see that a *LogGroup, an ExecutionRole with appropriate Policies and a TaskRole has been created automatically*. This was the biggest one for me as I had to manually configure the ECSTask when I built the v1 of this application.

Here is the [template.yaml](https://gist.github.com/rupakg/52f98fb95e3a8fe8e495dbff9c2fd14d) that was generated for us.

<script src="https://gist.github.com/rupakg/52f98fb95e3a8fe8e495dbff9c2fd14d.js"></script>

#### Subscribing to S3 events

We will now connect the S3 components to the Lambda function components which will tell Stackery that we want to trigger the functions using S3 events. It's as easy as just connecting the 'connection points' at the edges of the components as shown below:

![image](https://user-images.githubusercontent.com/8188/46178834-750d1d00-c286-11e8-8cb7-69ae9b694966.png)

Let's commit the changes and look at the diff to see what magic Stackery did! 

You will see a new commit [f231d92](https://github.com/rupakg/sls-video-processing-with-fargate/commit/f231d92f82fa3814abf4ef6f11d148945530bc2e) with the changes that were made. You will notice that just by connecting the S3 objects to thier respective functions, an **Events** section was added to the function in the `template.yaml` file that hooked up the `s3:ObjectCreated:*` and `s3:ObjectRemoved:*` events for the corresponding S3 buckets.

Note that you can commit your design changes anytime to keep a nice commit log of changes and compare the diffs done to the `template.yaml` file. **Infrastructure as code FTW!!!**

#### Updating the code directly

Stackery allows you the freedom to update any code directly and have it synced on the Dashboard. For example, on line 28 of the `template.yaml` file, the auto-generated configuration for the DockerTask has the ContainerDefinition Name as '0'. It is not a descriptive name so let's change that to `Name: video-to-thumb-container`. We will reference and use this name when we run the ECS Task later. 

Commit and push your changes. Since we updated the `template.yaml`file, let's go back to the Stackery Dashboard and you will notice that it recognizes that the code has changed. You will see this message:

![image](https://user-images.githubusercontent.com/8188/46769321-6b89a900-ccb9-11e8-8e7f-d92d6740ddc2.png)

Click **refresh** to sync with the latest commit. Note that Stackery allows you to work on feature branches as part of your development team workflow, all from within the Dashboard.

#### IAM Policies and Service Discovery

We want to secure our AWS resources so that we can let the different components talk to each other, but are secured from public access. Here are the permissions that we need:

1. The `triggerOnUploadVideoStackery` Lambda function needs access and permissions to run the Docker ECSTask
2. The Docker ECSTask needs read/write access to the output S3 bucket `rg-stackery-thumbnails`, so only the ECSTask can write to the bucket
3. The `triggerOnUploadVideoStackery` Lambda function needs access and permissions to write to the output S3 bucket `rg-stackery-thumbnails`
4. The output S3 bucket also needs public read access for its objects, so anyone can view the thumbnails
5. Both S3 buckets need public read access

The other thing that we need to make the solution work is service discovery that enables the various resources to discover each other's resource properties. Here are the properties that we need:

1. The `triggerOnUploadVideoStackery` Lambda function also needs to know the details of the Docker ECSTask to run it
2. The `triggerOnUploadVideoStackery` Lambda function, which will generate the thumbnails needs to know the details of the output S3 bucket
3. The `triggerOnUploadVideoStackery` Lambda function, which will process the video file needs to know the details of the input S3 bucket

I will implement the above list of things one by one and you can follow along commit by commit.

### Connecting the Lambda function to the Fargate Task

One of the toughtest thing to do, is figuring out the set of permissions for access control. Stackery solves it in a very elegant way. Stackery has a concept of connections: **solid wire** and **dotted wire**. We saw an example of solid wire connections earlier, when we connected the S3 buckets with the Lambda functions. 

Another cool feature of Stackery's integration with git, is that we can take advantage of the usual development workflow of making changes in a feature branch and doing a pull request. Let's see it action.

Before making any changes, click on the dropdown under **Branch** and select **Create Branch...** and give the branch a name `c1`. Now, let's connect the Lambda function `triggerOnUploadVideoStackery` to the Docker ECSTask. On the Dashboard, let's drag the connection point from the right-hand side of the function to the left-hand side connection point of the Docker ECSTask. You will notice that the connection is a dotted wire. Commit the changes.  

![image](https://user-images.githubusercontent.com/8188/46834955-d5b65280-cd7a-11e8-9e73-6f77377a45e6.png)

Head over to the github project, and create a new Pull Request from the commit. And you can see the changes that Stackery made to the `template.yaml`file. You can create the PR, and follow your company's code review and merge workflow.

On review, we see three [distinct changes](https://github.com/rupakg/sls-video-processing-with-fargate/pull/1/commits/0212df39fb566fcab4af304d593421d63352c42e) made to the `template.yaml` file. The first change is the addition of two policy statements were added that gives the Lambda function permissions to run the Docker ECSTask. The second change is addition of some environment variables that exposes the details of the Docker ECSTask to the Lambda function. The third change is the addition of a reference to the `DefaultVPCSubnets` that is used by the Docker ECSTask. The latter two changes are necessary data that is required to run the Docker ECSTask from within the Lambda function. We will see how these are used later in the post.

**Note**: Apart from seeing the changes in code, you can click on the Lambda function node on the Dashboard and see the changes there as well.

By doing the above connection, we have achieved the following from the list above:

* The `triggerOnUploadVideoStackery` Lambda function needs access and permissions to run the Docker ECSTask
* The `triggerOnUploadVideoStackery` Lambda function also needs to know the details of the Docker ECSTask to run it

Before we move on, make sure to merge your PR, and then on the Dashboard switch back to the `master` branch to be in sync with the lastest code. I love the simplicity of the workflow and the ease of codifying the feature.

#### Connecting the Fargate Task to the output S3 bucket

We will do all our changes in a new branch `c2`. Once you connect the right-hand side of the Docker ECSTask to the left-hand side of the `rg-stackery-thumbnails` S3 bucket, we will have a dotted wire connection.

![image](https://user-images.githubusercontent.com/8188/46836148-5034a180-cd7e-11e8-956a-9203d29192da.png)

On review, we can see two [distinct changes](https://github.com/rupakg/sls-video-processing-with-fargate/pull/2/commits/f5a704028c9ddf4fcbb01f733004f6f583397540) made to the `template.yaml` file. Two new environment variables for the S3 bucket is added to the Docker ECSTask. And, a new IAM policy is added to the Docker ECSTask IAM role to allow read/write access to the S3 bucket.

By doing the above connection, we have achieved the following from the list above:

* The Docker ECSTask needs read/write access to the output S3 bucket (`rg-stackery-thumbnails`), so only the ECSTask can write to the bucket

#### Connecting the Lambda function to output S3 bucket

We will do all our changes in a new branch `c3`. Once you connect the right-hand side of the `triggerOnUploadVideoStackery` Lambda function to the left-hand side of the `rg-stackery-thumbnails` output S3 bucket, we will have a new dotted wire connection.

![image](https://user-images.githubusercontent.com/8188/46837487-7d378300-cd83-11e8-9b9e-242368056a09.png)

On review, we can see two [distinct changes](https://github.com/rupakg/sls-video-processing-with-fargate/pull/3/commits/72b2e9569305affdb71f49f46e07a9cc80021f8e) made to the `template.yaml` file. Under the Lambda function's Policies section, a new policy named [S3CrudPolicy](https://docs.aws.amazon.com/serverlessrepo/latest/devguide/using-aws-sam.html) referencing the S3 output bucket is added, that gives the Lambda function read/write access to the bucket.

By doing the above connection, we have achieved the following from the list above:

* The `triggerOnUploadVideoStackery` Lambda function needs access and permissions to write to the output S3 bucket `rg-stackery-thumbnails`
* The `triggerOnUploadVideoStackery` Lambda function which will generate the thumbnails needs to know the details of the output S3 bucket

#### Connecting the Lambda function to input S3 bucket

We will do all our changes in a new branch `c4`. Once you connect the right-hand side of the `triggerOnUploadVideoStackery` Lambda function to the left-hand side of the `rg-stackery-video-files` input S3  bucket, we will have a new dotted wire connection.

![image](https://user-images.githubusercontent.com/8188/46838459-63983a80-cd87-11e8-9cb9-eb371586388a.png)

On review, we can see two [distinct changes](https://github.com/rupakg/sls-video-processing-with-fargate/pull/4/commits/3dfb25f4a449a11c4022434ee697567274e7136b) made to the `template.yaml` file. Under the Lambda function's Policies section, a new policy named [S3CrudPolicy](https://docs.aws.amazon.com/serverlessrepo/latest/devguide/using-aws-sam.html) referencing the S3 input bucket is added, that gives the Lambda function read/write access to the bucket. And, two new environment variables for the input S3 bucket is added to the function.

By doing the above connection, we have achieved the following from the list above:

- The `triggerOnUploadVideoStackery` Lambda function needs access and permissions to read from the input S3 bucket `rg-stackery-video-files`
- The `triggerOnUploadVideoStackery` Lambda function which will process the video file, needs to know the details of the input S3 bucket `rg-stackery-video-files`

## The Deployment Process

Stackery involves a two-step deployment process. The solution is first prepared for deployment. Stackery will do a few things for us in this step:

* Install dependencies: If you have a `package.json` for a NodeJS app or a `requirements.txt` for a Python app
* Build code: compile code for Java and .NET apps
* Inject Instrumentation: For handling errors centrally through the Stackery Errors resource

If this first-step passes, then the next step is to Deploy. Stackery handles the actual deploy a little differently than other frameworks. The vision is of seperation of concerns. Stackery leads the way till you have the CF template and builds working. It stops at creating a  [CloudFormation Stack Change Set](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/using-cfn-updating-stacks-changesets.html) for all the changes that are made and ready to be executed against an AWS account. 

As far as physically executing the changes into AWS, it takes a step back and allows the user to review the changes, choose the proper account and then execute the change set directly via the CloudFormation console. When you hit the Deploy button, Stackery will open the AWS CloudFormation console for you to take over. **That is I feel a great balance in automating building apps but giving the user the final control.**

In the process of executing the change set, AWS CloudFormation will validate the template for errors, runtime issues etc. and rollback the changeset if there are any issues. If everything goes fine, you will see a new Deployment on the Stackery Dashboard.

#### Prepare the app for Deployment

We have been iterating over the design of our app and I think it is about time we should try deploying the solution. Although, we have not provided any custom logic to our Lambda functions yet, we would still benefit from trying to deploy the solution at its current form. 

To prepare our app for deployment, first switch to the `master` branch, then select an **Environment** (``development` in our case), and then hit the **Prepare Deployment** button on the Stackery Dashboard. Note that you can create and manage your own environments. Here is the current state of the application:

![image](https://user-images.githubusercontent.com/8188/46882886-2fbc2400-ce1e-11e8-8c99-c218343a0771.png)

Let's prepare for deployment. So far so good, and our prepared deployment was successful.

![image](https://user-images.githubusercontent.com/8188/46882995-89245300-ce1e-11e8-8a39-0a0cf54ca4a5.png)

Time to deploy! Hit the **Deploy** button. This will take you to the AWS CloudFormation console and you have to login with the account that you want the application deployed to.

But, alas - **Houston we have a problem!**

![image](https://user-images.githubusercontent.com/8188/46885423-ee2f7700-ce25-11e8-9890-ea92c9e2e980.png)

The validation for the change set failed. Let's dig in and find out why.

#### Circular Dependency Issue

If you go down the page into the **Template** section and select the **View processed template** radio button, you will see the fully resolved CF template yaml file. Reviewing the file here are the circular dependencies that is the problem:

On [line 21](https://gist.github.com/rupakg/e2f32995a7648db76391ab647c4fc7e7#file-aws-cf-circular-dependency-issue-yml-L21), the resource `functionF9A32476objectStore3B0DC7B6Permission` is being described. Then on [line 141](https://gist.github.com/rupakg/e2f32995a7648db76391ab647c4fc7e7#file-aws-cf-circular-dependency-issue-yml-L141) the `rg-stackery-video-files S3 bucket` with Resource Id `objectStore6A12D98C` is being referenced as `{ bucketName: { Ref: objectStore6A12D98C } }`. Same on [line 148](https://gist.github.com/rupakg/e2f32995a7648db76391ab647c4fc7e7#file-aws-cf-circular-dependency-issue-yml-L148).

Now, on [line 201](https://gist.github.com/rupakg/e2f32995a7648db76391ab647c4fc7e7#file-aws-cf-circular-dependency-issue-yml-L201), the bucket resource for the same bucket with Resource Id `objectStore6A12D98C`is being described. And, on [line 221](https://gist.github.com/rupakg/e2f32995a7648db76391ab647c4fc7e7#file-aws-cf-circular-dependency-issue-yml-L221), the `functionF9A32476objectStore3B0DC7B6Permission` resource is under a DependsOn clause. 

The bucket needs the permission to build and the permission references the buclet that it is providing permissions for. This is a classic circular dependency case. AWS has a documented the [issue regarding circular dependency involving Lambda, S3 buckets and CloudFormation](https://aws.amazon.com/premiumsupport/knowledge-center/unable-validate-circular-dependency-cloudformation/), that explain the above issue in further detail.

#### Issue Resolution

The problem areas described above correlates to the following block of SAM template code:

```yaml
  function17279F64:
    Type: AWS::Serverless::Function
    ...
        - S3CrudPolicy:
        BucketName: !Ref objectStore6A12D98C
    ...
```

```yaml
  Environment:
    Variables:
        ...
        BUCKET_NAME: !Ref objectStore3B0DC7B6
        BUCKET_ARN: !GetAtt objectStore3B0DC7B6.Arn		  
        BUCKET_NAME_2: !Ref objectStore6A12D98C
        BUCKET_ARN_2: !GetAtt objectStore6A12D98C.Arn
```

Based on the [AWS workaround to the problem](https://aws.amazon.com/premiumsupport/knowledge-center/unable-validate-circular-dependency-cloudformation/), the solution is to replace the S3 bucket reference from `!Ref objectStore6A12D98C` to `!Sub ${AWS::StackName}-objectstore6a12d98c`. **Big note of caution is that the `objectstore6a12d98c` part of the text needs to be all lowercase**. Also, since we don't really need the Bucket ARN values, we can remove them as well.

Before we make a change let's start a new branch `c5`. We can make the fix in either of the following two ways:

* On the Dashboard, select the `triggerOnUploadVideoStackery` Lambda function node. A dialog box will appear. Scroll down to the **Permissions** section. Update the **S3CrudPolicy** -> **BucketName** values with `!Sub ${AWS::StackName}-objectstore3b0dc7b6` and `!Sub ${AWS::StackName}-objectstore6a12d98c` respectively. And, in the **Environment Variables** section, we make the same changes to the `BUCKET_NAME` and `BUCKET_NAME_2` variables as well. We can also delete the `BUCKET_ARN` and `BUCKET_ARN_2` key/value pairs. Click **Save** to save the changes.
* Directly edit the `template.yaml` file and edit the lines [147](https://github.com/rupakg/sls-video-processing-with-fargate/blob/master/template.yaml#L147) and [149](https://github.com/rupakg/sls-video-processing-with-fargate/blob/master/template.yaml#L149). Then delete lines [165](https://github.com/rupakg/sls-video-processing-with-fargate/blob/master/template.yaml#L165) and [167](https://github.com/rupakg/sls-video-processing-with-fargate/blob/master/template.yaml#L167).

After [committing and merging](https://github.com/rupakg/sls-video-processing-with-fargate/pull/5) the changes, switch back to the master branch on the Dashboard.

*Moment of truth* - let's try to deploy again... 

Click **Prepare Deployment** and then **Deploy**. And this time we look good. The AWS CloudFormation console shows us that the change set was created successfully. You can choose to review the changes under the **Changes** section.

![image](https://user-images.githubusercontent.com/8188/46891303-694d5900-ce37-11e8-8992-60078301c7ec.png)

Once you are happy with the review, go can hit the **Execute** button to deploy the application.

But, we are not done with our application yet so we will wait. I justed wanted to show you how the deployment process, the validation, and resolution works. Let's get to the meat of the application and implement the custom logic code for the Lambda functions.

## Implementing logic for the Lambda functions

Now that we have the design down and validated, let's update the handler functions to add our custom logic of extracting the thumbnail from the incoming video file. In this part of the development process, we will work with the code directly in the editor and commit changes from the terminal.

Reviewing the [source code repo](https://github.com/rupakg/sls-video-processing-with-fargate) for the project, we see that we have a `src`folder with two sub-folders for each of our Lambda functions. Keeping the functions in separate folders not only keeps the code isolated but also let's us include any dependencies.

### Processing video files and extracting thumbnails

Checkout a new branch `c6` and create `src/triggerOnUploadVideoStackery/index.js` file. The following is an excerpt of the code but you find the [full code here](https://github.com/rupakg/sls-video-processing-with-fargate/blob/master/src/triggerOnUploadVideoStackery/index.js).

```js
// src/triggerOnUploadVideoStackery/index.js
...
const DOCKER_TASK_ARN = process.env.DOCKER_TASK_ARN;
const DOCKER_TASK_SUBNETS = process.env.DOCKER_TASK_SUBNETS;
const INPUT_BUCKET_NAME = process.env.BUCKET_NAME_2;
const OUTPUT_BUCKET_NAME = process.env.BUCKET_NAME;
...
const temp = DOCKER_TASK_ARN.split(':');
const ECS_TASK_DEFINITION = `${temp[5].split('/')[1]}:${temp[6]}`;
...

module.exports.handler = function handler (event, context, callback) {
  
  const bucket = event.Records[0].s3.bucket.name;
  const key = event.Records[0].s3.object.key;
  ...
  const s3_video_url = `https://s3.amazonaws.com/${bucket}/${key}`;
  const thumbnail_file = key.substring(0, key.indexOf('_')) + '.png';
  const frame_pos = key.substring(key.indexOf('_')+1, key.indexOf('.')).replace('-',':');
  ...
  runThumbnailGenerateTask(s3_video_url, thumbnail_file, frame_pos);
  callback(null, {});
}

var runThumbnailGenerateTask = (s3_video_url, thumbnail_file, frame_pos) => {

  const docker_subnet_items = DOCKER_TASK_SUBNETS.split(',');

  // run an ECS Fargate task
  var params = {
    cluster: `${ECS_CLUSTER_NAME}`,
    launchType: 'FARGATE',
    taskDefinition: `${ECS_TASK_DEFINITION}`,
    count: 1,
    platformVersion:'LATEST',
    networkConfiguration: {
      awsvpcConfiguration: {
          subnets: [],
          assignPublicIp: 'ENABLED'
      }
    },
    overrides: {
      containerOverrides: [
        {
          name: '0',
          environment: [
            {
              name: 'INPUT_VIDEO_FILE_URL',
              value: `${s3_video_url}`
            },
			...
  };
  // assign the subnets
  params.networkConfiguration.awsvpcConfiguration.subnets = docker_subnet_items;

  // run the ecs task passing in the configuration
  ecsApi.runECSTask(params);
}
```

Line 8-9: Takes the Docker Task ARN and extracts the ECS Task Definition name from it. It will be used to run the ECS Task later.

Line 17-19: Builds up the necessary parameters required by the Docker ECS Task to generate a thumbnail. It parses the video file name to extract the `frame_pos` of the frame that needs to be extracted as a thumbnail. Then, calls the helper method `runThumbnailGenerateTask` with the appropriate parameters.

Line 25-58: Creates the `params` object that is expected by the `runECSTask` method. On line 27 and line 54, we use the `DOCKER_TASK_SUBNETS` values to assign the AWS VPC subnets required by the ECS Task. Finally on line 99, we call the `runECSTask` defined in the `ecs.js` helper file.

Now let's add the code for handling the S3 event when a thumbnail is created and dropped into the output S3 bucket.

### Notification on thumbnail creation

The Lambda function `triggerOnUploadVideoStackery` is triggered when a '.png' file is uploaded to S3. It prints out the name of the thumbnail file into the logs.

Create `src/triggerOnThumbnailCreationStackery/index.js` file and copy the [full code from here](https://github.com/rupakg/sls-video-processing-with-fargate/blob/master/src/triggerOnThumbnailCreationStackery/index.js). 

### Additional permissions to S3 buckets

We need these additional permissions:

- The output S3 bucket also needs public read access for its objects, so anyone can view the thumbnails
- Both S3 buckets need public read access

Let's update the `template.yaml` with these following sections:

```yaml
  ...
  thumbOutputBucketPolicy: 
    Type: AWS::S3::BucketPolicy
    Properties: 
      Bucket: !Ref objectStore16B4761A
      PolicyDocument: 
        Statement: 
          - 
            Action: 
              - "s3:GetObject"
            Effect: "Allow"
            Resource: 
              Fn::Join: 
                - ""
                - 
                  - "arn:aws:s3:::"
                  - 
                    Ref: "objectStore16B4761A"
                  - "/*"
            Principal: "*"      
  ...
```

Add `AccessControl: PublicRead` to both the S3 objects as follows:

```yaml
...
  objectStore6A12D98C:
	...
      BucketName: !Sub ${AWS::StackName}-objectstore6a12d98c
      AccessControl: PublicRead
  objectStore3B0DC7B6:
    ...
      BucketName: !Sub ${AWS::StackName}-objectstore3b0dc7b6
      AccessControl: PublicRead
...
```

Last but not least, let's remove the event `s3:ObjectRemoved:*` from both Lambda functions, so that we don't get our fucntions called when we remove items from the S3 buckets.

Raise and merge the [PR](https://github.com/rupakg/sls-video-processing-with-fargate/pull/6) for branch `c6`. Time to deploy and run our application.

## Running the Application

The lastest version of the application looks like the following:

![image](https://user-images.githubusercontent.com/8188/47038537-ba1ec380-d14f-11e8-97b3-eaa8b4238d02.png)

**Note**: The **Custom** resource is the bucket policy we added in the end to the output S3 bucket/objects.

Refresh the branch on the Dashboard to `master`, and click the **Prepare Deployment** button. When it succeeds, click on the **Deploy** button. You will be taken to the AWS CloudFormation console, and you can review the change set and then click on **Execute** button to execute the changes.

Once we have the **Status** showing as `CREATE_COMPLETE`, you can go to the Stackery Dashboard and flip over to the **Deployments** tab and see the latest deployment displayed.

Let's test our application.

Head over to the AWS S3 console and locate the input S3 bucket with suffix `objectstore6a12d98c` and upload a `.mp4` video file with a format `file_xx-xx.mp4`, where xx-xx is the frame position for the frame that you want to extract as a thumbnail. Grant public read access to this object.

Then head over to the AWS ECS console and click on **Task Definition** and locate the task definition with `dockerTask4259BAF6` string in it. You can clickk through the task revision and review the task we created via our custom logic.

To see the task running, go to the **Cluster** menu, and click on the `default` cluster. You will see our ECS Task running.

![image](https://user-images.githubusercontent.com/8188/47040371-1552b500-d154-11e8-8b4f-24c046257451.png)

Click on the **Task Id**, and then flip to the **Logs** tab. Here you can see the logs generated by the ECS Task, and you can see the thumbnail being generated by the container. Click the refresh button to see updates.

![image](https://user-images.githubusercontent.com/8188/47040516-6b275d00-d154-11e8-9f72-2dd3cb3b0876.png)

Head over to the AWS S3 console and look for the output S3 bucket with a suffix `objectstore3b0dc7b6`. And you will see the thumbnail created as per our expectations. Click on the file and then click on the Link at the bottom of the page. You should be able to view the thumbnail on your browser.

If you are interested in the Lambda logs head over to the AWS Lambda console and locate your two functions. And you can see the logs generated as per our code. 

The logs for the `triggerOnUploadVideoStackery` function:

```
...
2018-10-16T18:58:47.329Z	828abf9a-d175-11e8-8f31-a3496c7e476b	A new video file 'bunny_00-03.mp4' was uploaded to 'stackery-249834123825422-objectstore6a12d98c' for processing.
2018-10-16T18:58:47.329Z	828abf9a-d175-11e8-8f31-a3496c7e476b	Processing file 'https://s3.amazonaws.com/stackery-249834123825422-objectstore6a12d98c/bunny_00-03.mp4' to extract frame from position '00:03' to generate thumbnail 'bunny.png'.
...
END RequestId: 828abf9a-d175-11e8-8f31-a3496c7e476b
REPORT RequestId: 828abf9a-d175-11e8-8f31-a3496c7e476b	Duration: 1439.70 ms	Billed Duration: 1500 ms Memory Size: 512 MB	Max Memory Used: 49 MB	
```

The logs for the `triggerOnThumbnailCreationStackery` function:

```
...
2018-10-16T18:59:52.206Z	a931c549-d175-11e8-8383-8731cad6c9dd	A new thumbnail file was generated at 'https://s3.amazonaws.com/stackery-249834123825422-objectstore3b0dc7b6/bunny.png'.
END RequestId: a931c549-d175-11e8-8383-8731cad6c9dd
REPORT RequestId: a931c549-d175-11e8-8383-8731cad6c9dd	Duration: 5.69 ms	Billed Duration: 100 ms Memory Size: 512 MB	Max Memory Used: 39 MB	
```

You can also view the traces in AWS X-Ray for the `triggerOnUploadVideoStackery` and `triggerOnThumbnailCreationStackery` functions respectively:

![image](https://user-images.githubusercontent.com/8188/47041225-3b795480-d156-11e8-8401-93dc980cabbb.png)

![image](https://user-images.githubusercontent.com/8188/47041287-69f72f80-d156-11e8-887c-2b3c143027c5.png)

## Error Handling

Stackery also provides an Errors resource that emits messages whenever an error occurs in a function in the stack. You can connect it to another Lambda function that can then process those errors. Stackery will capture uncaught exceptions and timeout errors as well. It can be used to send all the errors to an aggregating service of your choice.

## Health & Operations

The Stack Observer view, i.e. the **Deployments** tab on the Stackery Dashboard will show the metrics from AWS for each resource in your application. Here is how the application metrics look like after a few runs:

![image](https://user-images.githubusercontent.com/8188/47042284-dd01a580-d158-11e8-9004-6b68119b6580.png)

![image](https://user-images.githubusercontent.com/8188/47042301-e985fe00-d158-11e8-94b8-9cbc198f25eb.png)

I had to spilt up the screen in the above screenshots. 

**Feature Request**: I should be able to rearrange the boxes for a neater view.

So there you have a serverless application using a long-running process via the AWS Fargate triggered by Lambda functions to process a video file and extract thumbnails from user specified frame position.

You can use the [code for the project](https://github.com/rupakg/sls-video-processing-with-fargate) as your starting template to build your next Stackery application involving long-running processes using AWS Fargate.

## Summary

This is a multi-part blog series that explores building serverless applications with Stackery. In the [first part](https://rupakganguly.com/posts/building-serverless-apps-using-stackery/) of the series, we discussed why Stackery is a great platform for visually building and deploying serverless applications on AWS. 

We looked at the ease of using the Stackery Dashboard to design, configure, build and deploy serverless applications. But, Stackery also has a feature-rich CLI, that can be used interchangeably to develop serverless applications. You can use the CLI extend the development workflow into a full CI/CD solution.

This blog post was focused at walking you through and show you how to build a serverless application to extract a thumbnail from a video file using AWS Fargate, but built visually using Stackery. I had written a [blog post](https://medium.com/@rupakg/how-to-use-aws-fargate-and-lambda-for-long-running-processes-in-a-serverless-app-c3712e158bb) for the same application using the Serverless Framework, but the ECSTask configuration was all done manually using the ECS Console. This version of the application written with Stackery automates that part as well. All of the code for the application is versioned controlled and nothing is left for manual configuration. 

If you have any feedback or questions, feel free to let me know in the comments below.

