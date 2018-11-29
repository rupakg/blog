---
title: "AWS reInvent 2018 Announcements"
description: ""
date: 2018-11-29T11:31:26-05:00
lastmod: 2018-11-29T11:31:26-05:00
keywords : [ "announcements", "AWS", "reinvent", "serverless"]
tags : [ "announcements", "AWS", "reinvent", "serverless"]
categories : [ "AWS", "reinvent", "announcements", "serverless"]
layout: post
type:  "post"
---

As usual, AWS announced a slew of new services and updates to it's existing services at reInvent 2018. Here are the most significant ones that I am maintaining a list of. I will be updating the list as more services get announced. Werner Vogels is on stage right now announcing new Serverless services and updates.
<!--more-->

## Serverless Updates

**New Language support**: Ruby (yes!!!), Cobol, C++, Rust

**3rd-party IDE Integrations**: PyCharm, IntelliJ, VSCode - full serverless integration, integrated debugging and more...

**Custom Runtimes**: Bring you own execution environment.

**Lambda Layers**: reusabiliy of code across serverless functions. no duplicated code anymore. versioning code out of box. Includes security.

**Nested applications support** for apps in Serverless Application Repository. Package common functionality into modules that can be referenced from other SAM apps.

**Step-Functions can now orchestrate with 8 new services**: AWS Batch, Fargate, Amazon ECS, Amazon SNS, Amazon SQS, AWS Glue, and Amazon SageMaker.

**Websockets support for API Gateway** - build real-time two-way communication applications

**ALB Support for AWS Lambda**

**Managed Stream for Kafka**: fully managed and higly available Apache Kafka service

**AWS Well-Architected Framework**

## Storage Services

[AWS S3 Glacier Deep Archive](https://aws.amazon.com/about-aws/whats-new/2018/11/s3-glacier-deep-archive/): a new Amazon S3 storage class that provides secure, durable object storage for long-term data retention and offers the lowest price.

[AWS S3 Intelligent-Tiering](https://aws.amazon.com/about-aws/whats-new/2018/11/s3-intelligent-tiering/): a new Amazon S3 storage class designed that optimizes storage costs automatically when data access patterns change, without performance impact or operational overhead.

## Security Services

[AWS Control Tower](https://aws.amazon.com/controltower/): prescriptive guidance for setting up accounts, IAM policies, security, compliance, multi-account/orgs. etc. It is a set of blueprints and set up guardrails.

[AWS Security Hub](https://aws.amazon.com/security-hub/): manage all security and complaince across AWS environment.

[Amazon CloudWatch Logs Insights](https://aws.amazon.com/blogs/aws/new-amazon-cloudwatch-logs-insights-fast-interactive-log-analytics/): fully integrated analytics service to analyze and visualize CloudWatch logs.

## Database Services

[Amazon Timestream](https://aws.amazon.com/timestream/): fully managed time-series database.

[Amazon DynamoDB](https://aws.amazon.com/dynamodb/) On-demand: a flexible new billing option for DynamoDB capable of serving thousands of requests per second without capacity planning. The **on-demand feature is not free-tier eligible** though.

[Amazon DynamoDB Transactions](https://aws.amazon.com/blogs/aws/new-amazon-dynamodb-transactions/): transactions support in DynamoDB.

## Analytics Services

[AWS Lake Formation](https://aws.amazon.com/lake-formation/): create secure data lakes using a console.

[Amazon QuickSight](https://aws.amazon.com/quicksight/): full managed per-per-session business intelligence service.

## Blockchain Services

[Amazon Managed Blockchain](https://aws.amazon.com/managed-blockchain/): full managed blockchain infrastructure. create and manage blockchain networks - Hyperledger (available) and Etherium (coming soon) fabric

[Amazon Quantum Ledger Database (QLDB)](https://aws.amazon.com/qldb/): fully managed ledger database that provides a transparent, immutable, and cryptographically verifiable transaction log, owned by a central trusted authority.

## AI & ML Services

[Amazon Elastic Inference](https://aws.amazon.com/machine-learning/elastic-inference/): GPU-powered deep machine learning inference infrastructure. 

[Amazon SageMaker Ground Truth](https://aws.amazon.com/sagemaker/groundtruth/): Video labeling and annotations framework for training datasets

[AWS Marketplace for Machine Learning](https://aws.amazon.com/marketplace/solutions/machine-learning/): 150 ML algorithms and models that can be used with SageMaker

[Amazon SageMaker RL (Reinforcement Learning)](https://aws.amazon.com/about-aws/whats-new/2018/11/amazon-sagemaker-announces-support-for-reinforcement-learning/): Managed Reinforcement Machine Learning algorithms

[AWS DeepRacer](https://aws.amazon.com/deepracer/): Fully autonomous 1/18th race car powered by ML. Work with a virtual track, develop a strategy and then upload to the physical car. [AWS DeepRacer League](https://aws.amazon.com/deepracer/league/), first global autonomous racing league, open to anyone. Will also have virtual races.

[Amazon Textract](https://aws.amazon.com/textract/): OCR++ service to easily extract text data from documents and forms. It can recognize different data formats like SSN, DOB, addresses etc.

[Amazon Personalize](https://aws.amazon.com/personalize/): Fully managed real-time personalization and recommendations engine/service. They are private models. You feed in activity stream, inventory data, demographics data etc. to Amazon Personalize and you get a personallized recommendations exposed via an API.

[Amazon Forecast](https://aws.amazon.com/forecast/): Accurate time-series forecasting service. Feed historical data and related casual data and forecasts is exposed over an API.

## Infrastructure Services

[VMWare Cloud on AWS](https://cloud.vmware.com/vmc-aws): Extend and migrate VMWare environments to AWS. 

[AWS Outposts](https://aws.amazon.com/outposts/): Run AWS infrastructure on-premise in your datacenter - **AWS VMWare Cloud** or **AWS Native**. That will enable to run AWS software in-premise. It will seamlessly integrate with services on AWS cloud. Installed and optionally maintained by AWS.

[Firecracker](https://aws.amazon.com/blogs/aws/firecracker-lightweight-virtualization-for-serverless-computing/): an open-source virtualization technology built for managing containers and functions based services.

Now you can build *hybrid solutions* using VMWare Cloud on AWS and AWS Outposts.

## Other

[AWS Amplify Console](https://aws.amazon.com/amplify/console/): a continuous deployment and hosting service for modern web applications with serverless backends. 

[AWS Transfer for SFTP](https://aws.amazon.com/sftp/): Fully managed SFTP service.



## In the News

- [Automatic Cost Optimization for Amazon S3 via Intelligent Tiering](https://aws.amazon.com/blogs/aws/new-automatic-cost-optimization-for-amazon-s3-via-intelligent-tiering/)
- [Amazon Elastic Inference – GPU-Powered Deep Learning Inference Acceleration](https://aws.amazon.com/blogs/aws/amazon-elastic-inference-gpu-powered-deep-learning-inference-acceleration/)
- [Amazon SageMaker Ground Truth – Build Highly Accurate Datasets and Reduce Labeling Costs by up to 70%](https://aws.amazon.com/blogs/aws/amazon-sagemaker-ground-truth-build-highly-accurate-datasets-and-reduce-labeling-costs-by-up-to-70/)
- [Amazon SageMaker RL – Managed Reinforcement Learning](https://aws.amazon.com/blogs/aws/amazon-sagemaker-rl-managed-reinforcement-learning-with-amazon-sagemaker/)
- [Amazon Personalize – Real-Time Personalization and Recommendation for Everyone](https://aws.amazon.com/blogs/aws/amazon-personalize-real-time-personalization-and-recommendation-for-everyone/)
- [Amazon Forecast – Time Series Forecasting Made Easy](https://aws.amazon.com/blogs/aws/amazon-forecast-time-series-forecasting-made-easy/)
- [Amazon DynamoDB On-Demand – No Capacity Planning and Pay-Per-Request Pricing](https://aws.amazon.com/blogs/aws/amazon-dynamodb-on-demand-no-capacity-planning-and-pay-per-request-pricing/)
- [New for AWS Lambda – Use Any Programming Language and Share Common Components](https://aws.amazon.com/blogs/aws/new-for-aws-lambda-use-any-programming-language-and-share-common-components/)
- [New – Compute, Database, Messaging, Analytics, and Machine Learning Integration for AWS Step Functions](https://aws.amazon.com/blogs/aws/new-compute-database-messaging-analytics-and-machine-learning-integration-for-aws-step-functions/)