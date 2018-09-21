---
title: "Building Serverless Apps Using Stackery"
description: "Explore why Stackery is a great platform and visually building & deploying a serverless application on AWS"
date: 2018-09-21T14:52:28-04:00
lastmod: 2018-09-21T14:52:28-04:00
keywords : [ "serverless", "AWS", "Stackery", "development" ]
tags : [ "serverless", "AWS", "Stackery", "development" ]
categories : [ "serverless", "development", "platforms"]
layout: post
type:  "post"
---

This is a multi-part blog series that will explore building serverless application with Stackery. In this post, the first part in the series, we discuss why Stackery is a great platform for visually building and deploying serverless applications on AWS. We will also look at setting up Stackery, linking an AWS account securely with least priviledges, and using a boilerplate template to build and deploy a serverless application to AWS.

In the second part of the series, I will walk you through and show you [how to build a serverless application to extract a frame from a video file using AWS Fargate](https://medium.com/@rupakg/how-to-use-aws-fargate-and-lambda-for-long-running-processes-in-a-serverless-app-c3712e158bb), but built using Stackery.  

## Why Stackery?

Stackery is a complete serverless toolkit and platform for building production-ready serverless applications. It combines the ease and intuitiveness of visually composing an applicaton (Stackery Console) to using the command line  (Stackery CLI) to get things done quickly. The platform keeps all the operations in sync at all times so you can choose to switch at any time. It comes with seamless Github integration and allows linking to multiple AWS accounts for easy one-click deployments across environments, stages and regions. Stackery's automated build process includes environment management, automatic error handling, and auto-provisioning DNS and SSL certificates without needing to open AWS. Stackery supports Python, Node.js, Java, and .Net/C# giving you a wide variety of choices. Stackery is built on cloud-native standards and builds on [AWS Serverless Application Model](https://www.stackery.io/product/aws-sam/). 

You can read more about the [product features](https://www.stackery.io/product/) on the Stackery website.

## Installation

To start using Stackery, create an account and then follow the simple steps to start building serverless applications. 

### Setting up the CLI

The install [instructions](https://app.stackery.io/) were very clear and precise. You can also take a look at the [quickstart](https://docs.stackery.io/docs/tutorials/quickstart/) documentation. It was a very quick onboarding process. The setup process also automatically created an API key as well as soon you login to the Stackery using the Stackery CLI. This API key will be stored in a `.stackery.toml` file in your home folder and used for all further Stackery access from the command line.

![image](https://user-images.githubusercontent.com/8188/45839693-158d9b00-bce3-11e8-9958-dad464fec161.png)

### Linking an AWS Account

Before we get to linking our AWS Account, it is important to assess what we are getting into. The Stackery docs mentions this important notice:

![image](https://user-images.githubusercontent.com/8188/45841997-6d2f0500-bce9-11e8-9eff-5dae5e306580.png)

This is a very important point that differenciates it from what other serverless frameworks require.

### Setting up a user

As a best practice, **you should never link your root AWS account** to Stackery or any other tool for that matter. It is best to create a new IAM user specifically for this purpose. You need to allow programmatic access when you create the user. Then, create a new group named `stackery` and give it the access as described in the next section. Then AWS provides you with an AWS credential. Don't forget to download the credential `.csv` file to your machine.

### Managing IAM Permissions

Giving **AdminstratorAccess** to the user for using Stackery is not acceptable. So I ventured into finding out what permissions Stackery needed for its initial setup. After 17 attempts, reviewing the errors in the CloudFormation Console, and tweaking the custom policy, I was finally able to get the setup to succeed. 

Here are the permissions for my `stackery` IAM group.

![image](https://user-images.githubusercontent.com/8188/45848287-d9b2ff80-bcfb-11e8-8c1b-fdf59429a068.png)

And, here is how my `stackery-setup` custom IAM policy looks like. Although, it is a huge list of permissions that is needed but it is much safer and secure than giving **AdminstratorAccess** permission.

![image](https://user-images.githubusercontent.com/8188/45848098-3b269e80-bcfb-11e8-9653-57f31d22e425.png)

And, so that you don't have to waste 30 mins of your life doing this, here is the [JSON for the above policy](https://gist.github.com/rupakg/8c14080d20381cf4de51e7b2a0d886e7). Enjoy!

To link AWS and Stackery run `stackery aws setup` on your terminal.

```bash
~ ⚡ stackery aws setup
...
Detected AWS profiles in /Users/rupakg/.aws/credentials
? Which AWS profile should be used: stackery
Fetching AWS account details... Success.

AWS account details:
+ Account ID: XXXXXXXXXXX
+ Default Region: us-east-1 (modify with --region flag)
+ Account Alias Name: xxxxxxxx

Setup Stackery Agent to enable Serverless Operations Console?
Stackery Agent consists of a limited permission IAM role used to propose change
sets and minimal AWS resources used to provide dashboard visibility.  You can
remove these resources via the AWS CloudFormation console at any time.
? Confirm Yes

Initiating Setup...  Done
Stackery Agent setup takes about 1 minute.
Setting up Stackery Agent....................... Success
Stackery Agent setup was successful.
```

Stackery CLI will look for existing AWS credentials in environment variables, `~/.aws/config`, and `~/.aws/credentials`. If it does not find any AWS credentials, then it will prompt you to enter the credentails. Since this is a new user, enter the credentials at the prompt. You can use multiple AWS profiles as needed. You can pick your AWS profile while setting up Stackery as well.

That should take care of setting up Stackery, and we are on our way to building serverless applications.

## Creating our first app in Stackery

Once you have linked your AWS account with Stackery, we can now create our first serverless application.

On the Stackery website, click on the **Stacks** button, and follow the prompts to link your Github, GitLab or AWS CodeCommit account with Stackery. That will allow us to commit code or import code from the repositories. We will be linking our Github account.

![image](https://user-images.githubusercontent.com/8188/45850501-68c41580-bd04-11e8-892c-181d0773b7d5.png)

Select 'GitHub' in the above screen. Then, fill in the details in the following screen as shows:

![image](https://user-images.githubusercontent.com/8188/45850576-a5900c80-bd04-11e8-8b5a-c5594e1af069.png)

Since it is our first application, we will use the *default template* provided by Stackery, but note that you can provide a Github repository with a `template.yaml` file (AWS SAM template file) to create your application. 

Now, hit the **Create Stack** button. And, boom - there we have a shiny new serverless application. 

![image](https://user-images.githubusercontent.com/8188/45851692-361d1b80-bd0a-11e8-9ddc-bb93219278a2.png)

Let's explore what was created by default.

## Visual Representation

First of all, we see that the canvas has been populated with what looks like an architecture diagram. Cool! Really impressive. And, on the left hand side, we see a link to a commit SHA titled **Current Stack**. If you click on it, you will be taken to the Github project for the application that was automatically built, and commited to Github. Is that awesome or what? We will get back to other things like the Environment, Account Details and Deployment a bit later. 

Let's shift our focus back to the right hand side and dig in.

The UI is intuitive enough to tell me that we have the following components stitched together to compose our application:

- An API component with a GET endpoint
- A `getWelcomePage` Lambda function that is connected to the API GET endpoint
- An Errors component
- A `logErrors` Lambda function that is connected to the Errors component

Clicking on the `getWelcomePage` component, you get a popup that shows the details about the Lambda function. 

![image](https://user-images.githubusercontent.com/8188/45851343-6663ba80-bd08-11e8-9e44-b9f0a219fb63.png)

Note, that the **Source Path** is set to `src/getWelcomePage` which is the [code](https://github.com/rupakg/hello-world-stackery/blob/fb58a06d09e27ac62ec06b5c554287e93fc55483/src/getWelcomePage/index.js) for the Lambda function that returns some HTML code for a `welcome.html` page. Similarly, the `logErrors` component is set to `src/logErrors` which is the [code](https://github.com/rupakg/hello-world-stackery/blob/fb58a06d09e27ac62ec06b5c554287e93fc55483/src/logErrors/index.js) for the Lambda function that logs errors to the console. Everything is already hooked up and ready to go. 

## Proposing Changes

On the left hand side panel, we see that the **Environment** is set to `development`. This is the AWS Lambda stage that the application will be deployed. Let's click the **Prepare Deployment** to see what happens next.

![image](https://user-images.githubusercontent.com/8188/45851769-7e3c3e00-bd0a-11e8-86b4-31eb14af6f2b.png) ![image](https://user-images.githubusercontent.com/8188/45851799-ac218280-bd0a-11e8-8b7e-a9adf88d8439.png)

The **Prepared Deployment** section shows that a deployment is being prepared, and then in a few seconds the **Deploy** button is highlighted telling me that it is ready to deploy the application. Exciting!

Let's hit the **Deploy** button to deploy the application to AWS.

## Separation of Concerns

The beauty of the Stackery platform, is that it separates the function of developing an application from the function of deploying the application. It is a very important aspect that allows organizations to keep these two functions seperated out and managed by different teams. While the Development team develops and builds the application, they can only have the ability to **propose a change** to the application. The proposed change can then be reviewed by the DevOps team members and they can **execute the proposed changes**, completing the deployment process. This separation of roles greatly helps in securing the AWS environment. 

By Stackery handing over the baton for the actual deployment of the application to the customer, it keeps things under the control of the customer. 

## Deployment

Put your customer or DevOps hat on! Clicking on the **Deploy** button, actually takes us to the CloudFormation console with the changeset. Let's review what changes are proposed in the changeset.

![image](https://user-images.githubusercontent.com/8188/45851865-f86cc280-bd0a-11e8-9b2d-d9d3179886dc.png)

And, a new **Change Set** has been created.

![image](https://user-images.githubusercontent.com/8188/45851947-51d4f180-bd0b-11e8-8c1a-ce804bf4c65f.png)

Clicking into the change set above, and digging into the **Change set input section** we see the same values we saw under Stackery's Environment section.

![image](https://user-images.githubusercontent.com/8188/45901548-489e6000-bdb1-11e8-9f01-e8053bb7a81b.png)

Digging further into **Changes** section, we see a list of proposed changes that exist in the change set, ready to be executed.

![image](https://user-images.githubusercontent.com/8188/45901597-75527780-bdb1-11e8-8a57-125dc873c892.png)

We can clearly see that an AWS:ApiGetway:RestAPI, a couple of AWS:Lambda:Function, a couple of AWS:IAM:Role, a couple of AWS:Lambda:Permission, a AWS:ApiGetway:Stage and AWS:ApiGetway:Deployment are proposed to be created. You can look at other things like the Details of the changes, and the CF template used to create the changeset.

Moment of truth - let's **Execute** the proposed changeset from the CloudFormation Console. After a confirmation popup, the changeset is executed.

![image](https://user-images.githubusercontent.com/8188/45852366-792cbe00-bd0d-11e8-8c5c-21869eb17e72.png)

The above screen tells me that there were no errors and the stack is deployed successfully. If you are curious to see the final AWS SAM `template.yaml` file, that is the basis for the application we built, you can have look [here](https://github.com/rupakg/hello-world-stackery/blob/master/template.yaml).

## Running the Application

Back on the Stackery site, we see a new tab on the left hand side appear named **Deployments**. And, on the right hand side, the application diagram has been updated with familiar AWS Lambda metrics. 

![image](https://user-images.githubusercontent.com/8188/45852423-c315a400-bd0d-11e8-8d79-8cf2aaadebfa.png)

Clicking on the **/GET endpoint** inside the **Api component**, take note of the **Stage Location**, which is the url for our application. 

![image](https://user-images.githubusercontent.com/8188/45852607-a5950a00-bd0e-11e8-93cc-3b56cdd02404.png)

The display also features the ARN, and links to Metrics & Logs.

Clicking on the url takes us to our deployed application. 

![image](https://user-images.githubusercontent.com/8188/45901662-b64a8c00-bdb1-11e8-825b-5f016f76cf16.png)

Hurray! We have our first serverless application built visually with Stackery, using a simple to use boilerplate template. 

You can access the full [code for the hello-world-stackery](https://github.com/rupakg/hello-world-stackery) project that we built in this blog post. 

Before you start building your own applications, you can try out the awesome tutorials to build a [Simple Serverless Web application](https://docs.stackery.io/docs/tutorials/serverless-form-tutorial/) or building a [Serverless Cron Job](https://docs.stackery.io/docs/tutorials/cron-job-tutorial/) application, using the detailed instructions provided on the Stackery documentation site.

## Summary

We started with setting up Stackery, by creating a new user with least priviledges needed by Stackery, and linking an AWS account. We then created a new serverless application using a boilerplate template and explored the various aspects of the application on the canvas. We then prepared the application to be deployed, reviewed the proposed changeset, and finally deployed the application on AWS. We accessed the application url to view our deployed application. In the process of deploying our applcaition, we also learnt about how the Stackery platform separates the function of developing an application from the function of deploying an application on AWS.

This blog post was focused at introducing you to buidling and deploying applications visually using the Stackery platform. In the second part of the series (coming soon!), I will walk you through and show you [how to build a serverless application to extract a frame from a video file using AWS Fargate](https://medium.com/@rupakg/how-to-use-aws-fargate-and-lambda-for-long-running-processes-in-a-serverless-app-c3712e158bb), but built visually using Stackery. 

If you have any feedback or questions, feel free to let me know in the comments below.

