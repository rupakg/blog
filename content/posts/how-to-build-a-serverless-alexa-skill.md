---
title: "How to build a Serverless Alexa Skill"
date: 2018-08-29T17:29:03-04:00
lastmod: 2018-08-29T17:29:03-04:00
tags : [ "serverless", "alexa", "alexa skill", "voice apps" ]
categories : [ "serverless", "alexa skill" ]
layout: post
type:  "post"
---

When I was a kid, I was intrigued by the Starship Enterprise's onboard computer featured in the science fiction series Star Trek. Although cheeky at times in it's portrayal of technologies beyond our imagination, the voice-controlled computer always made me wonder. And, here we are in the same lifetime, realiziing similar technolgies - inside our homes, on a small device... Amazing, I think! 🖖
<!--more-->

Let's build ourselves a custom skill for Alexa. Let me show you how.

![header image](https://user-images.githubusercontent.com/8188/44871267-4ccad800-ac60-11e8-8534-7c53df7c511b.png)

*[Photo by Andres Urena on Unsplash]*

In this post, we will build an Alexa skill to get meetup information. We will be using the Serverless Framework and the [serverless-alexa-skills](https://github.com/marcy-terui/serverless-alexa-skills) plugin.

We will cover:

* Creating a project
* Setting up the plugin
* Creating an Alexa skill
* Building the Interaction model
* Creating Lambda functions for Intents
* Building and deploying the skill
* Testing the skill

We have quite a bit of ground to cover so let's get started.

## Create the project

To start off, let's create a serverless project using the `aws-nodejs` template:

```
$ sls create -t aws-nodejs --name sls-meetup-alexa-skill -p sls-meetup-alexa-skill

Serverless: Generating boilerplate...
Serverless: Generating boilerplate in "/Users/wixmac/Projects/webapps/iot-project/sls-meetup-alexa-skill"
 _______                             __
|   _   .-----.----.--.--.-----.----|  .-----.-----.-----.
|   |___|  -__|   _|  |  |  -__|   _|  |  -__|__ --|__ --|
|____   |_____|__|  \___/|_____|__| |__|_____|_____|_____|
|   |   |             The Serverless Application Framework
|       |                           serverless.com, v1.30.1
 -------'

Serverless: Successfully generated boilerplate for template: "aws-nodejs"
```

## Add the Alexa skills plugin

Next, we will use the [serverless-alexa-skills](https://github.com/marcy-terui/serverless-alexa-skills) plugin by Masashi Terui. It enables us to manage Alexa skills via the Serverless Framework. That is big deal. Without the plugin, you would have to set up the Alexa skill manually using the Amazon Alexa Skill Developer console.

Let's install the `serverless-alexa-skills` plugin by running:

```
$ sls plugin install -n serverless-alexa-skills
```
This will add the plugin to the plugins section of the `serverless.yml` file:

```
plugins:
  - serverless-alexa-skills
```

Under the hood, the `serverless-alexa-skills` plugin uses the [Alexa Skill Management API](https://developer.amazon.com/docs/smapi/ask-cli-intro.html#smapi-intro). To be able to use the API, we will need to set up credentials with Amazon and authenticate with Amazon.

### Set up credentials

**Login with Amazon** is an OAuth2.0 single sign-on (SSO) system using your Amazon.com account.

Get your credentials, by logging into the [Amazon Developer Console](https://developer.amazon.com/). Then, go to **Login with Amazon** from **APPS & SERVICES** menu, and then click on **Create a New Security Profile**. Then, go to **Web Settings** menu item to create a new security profile.

Leave the `Allowed Origins` empty. Enter `http://localhost:9000` in `Allowed Return URLs`. 

Write down your `Client ID`, `Client Secret` and the `Vendor ID` for the new security profile. You can [find](https://developer.amazon.com/mycid.html) your `Vendor ID` as well. You can then set environment variables for each one of these secrets and then reference them in the `serverless.yml` file as shown below:

```
custom:
  alexa:
    vendorId: ${env:AMAZON_VENDOR_ID}
    clientId: ${env:AMAZON_CLIENT_ID}
    clientSecret: ${env:AMAZON_CLIENT_SECRET}
    localServerPort: 9000
```
**Note**: If you change the port number from the default `3000`, then make sure to add an attribute of `localServerPort` to the `custom` block in the `serverless.yml` file, as shown above.

### Authenticating with Amazon

```
$ sls alexa auth
```

This will open the Amazon.com login page in your browser and redirect you to `localhost:9000` after authenticating. If the authentication is successful, you'll see the message: "Thank you for using Serverless Alexa Skills Plugin!!". The authentication call returns a security token that is used in subsequent calls made by the plugin.

**Note**: If you get an error in any of the commands, please execute the `sls alexa auth` command again. This is because the security token expires in 1 hour.

## Create an Alexa Skill

With the setup done, we can now go ahead and create an Alexa skill. 

```
$ sls alexa create --name $YOUR_SKILL_NAME --locale $YOUR_SKILL_LOCALE --type $YOUR_SKILL_TYPE
```
where:

* **name**: Name of the skill
* **locale**: Locale of the skill (`en-US` for English)
* **type**: Type of the skill (`custom` or `smartHome` or `video`)

In our case, to create a new Alexa skill, run:

```
$ sls alexa create --name MeetupEvents --locale en-US --type custom

Serverless: [Skill ID] amzn1.ask.skill.xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxxx
```
**Note**: The `Skill ID` for the newly created skill is printed out. 

### Skill Manifest

Under the hood, the plugin uses the [Create Skill API](https://developer.amazon.com/docs/smapi/skill-operations.html#create-a-skill) to create a skill, which in turn returns a `manifest`.

The `manifest` can be viewed by running:

```
$ sls alexa manifests

Serverless:
----------------
[Skill ID] amzn1.ask.skill.xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxx
[Stage] development
[Skill Manifest]
manifest:
  publishingInformation:
    locales:
      en-US:
        name: MeetupEvents
  apis:
    custom: {}
  manifestVersion: '1.0'
```
**Note**: If you have other skills present, the information about those skills will be shown as well. 

### Add Skill Configuration

In your `serverless.yml` file, add a new `skills` block and paste the `Skill ID` and the `manifest` section into it, as shown below:

```
custom:
  alexa:
    vendorId: ${env:AMAZON_VENDOR_ID}
    clientId: ${env:AMAZON_CLIENT_ID}
    clientSecret: ${env:AMAZON_CLIENT_SECRET}
    localServerPort: 9000
    skills:
      - id: amzn1.ask.skill.xxxxxx-xxxx-xxxx-xxxx-xxxxxxxxx
        manifest:
          publishingInformation:
            locales:
              en-US:
                name: MeetupEvents
          apis:
            custom: {}              
          manifestVersion: '1.0'
```
For details, check out the [full specs](https://developer.amazon.com/docs/smapi/skill-manifest.html#sample-skill-manifests) for the manifest specs.

With the new information added, let's update the skill by running:

```
$ sls alexa update
```
**Note**: You can use the option `--dryRun` to simulate what the command will do instead of actually doing anything.

## Build the Interaction Model

Next up, let's look at building the Interaction model for our skill. Our skill has a custom intent with a few samples as described by the `intents` section. We will also include a few standard Amazon intents namely, Help, Cancel and Stop.

Let's add the interaction model for our skill in the `serverless.yml` file, as shown below:

```
        ...
        models:
          en-US:
            interactionModel:
              languageModel:
                invocationName: meetup events
                intents:
                  - name: MeetupIntent
                    samples:
                    - 'my events'
                    - 'my meetup events'
                    - 'anything interesting in my meetup'
                    - 'give me all my meetup events'
                  - name: AMAZON.HelpIntent
                    samples: []
                  - name: AMAZON.CancelIntent
                    samples: []
                  - name: AMAZON.StopIntent
                    samples: []
```
**Note:** For details, check out the [Interaction Model Operations API](https://developer.amazon.com/docs/smapi/interaction-model-schema.html) and the [interaction model schema](https://developer.amazon.com/docs/smapi/interaction-model-schema.html).

Let's update the skill again by running:

```
$ sls alexa update
```

So now we have the configuration and the interaction model for the skill updated and ready to go. 

But, wait, we don't have any code backing up our skill. Let's do that next.

## Lambda functions for the intents

Before we go any further, we need to write our Lambda function handlers for our skill intents in the `index.js` file. 

You can find the code for the lambda function `meetupHandler` [here](https://github.com/rupakg/sls-meetup-alexa-skill/blob/master/index.js).

Once we are done with that we need to reference those Lambda functions in the `serverless.yml` file as shown below:

```
functions:
  meetupHandler:
    handler: index.meetupHandler
    events:
      - alexaSkill: amzn1.ask.skill.xxxxxx-xxxx-xxxx-xxxx-xxxxxxxxx
```
**Note**: In this case, the Lambda functions are in the `index.js` file and the exported function is called `meetupHandler`.

Now, let's deploy our Alexa Meetup skill app.

### Deploy the Lambda functions

The deploy command will zip up the code, and upload it to AWS. Then, it will map the function handler and give us an endpoint (ARN). 

```
$ cd sls-meetup-alexa-skill 
$ sls deploy

Serverless: Packaging service...
Serverless: Excluding development dependencies...
Serverless: Creating Stack...
Serverless: Checking Stack create progress...
.....
Serverless: Stack create finished...
Serverless: Uploading CloudFormation file to S3...
Serverless: Uploading artifacts...
Serverless: Uploading service .zip file to S3 (1.7 MB)...
Serverless: Validating template...
Serverless: Updating Stack...
Serverless: Checking Stack update progress...
..................
Serverless: Stack update finished...
Service Information
service: sls-meetup-alexa-skill
stage: dev
region: us-east-1
stack: sls-meetup-alexa-skill-dev
api keys:
  None
endpoints:
  None
functions:
  meetupHandler: sls-meetup-alexa-skill-dev-meetupHandler
```

That was easy!!! No clicking through AWS console screens to deploy your Lambda functions.

Now, we need to get ARN for the Lambda function we just deployed. Go to the [AWS Lambda service](https://console.aws.amazon.com/lambda/) and search for the Lambda function `sls-meetup-alexa-skill-dev-meetupHandler`. On the top-right corner of the screen, you will see the ARN. 

Grab the ARN and add it to the `manifest` section of the `serverless.yml` file, as shown below:

```
...
          apis:
            custom:
              endpoint:
                uri: arn:aws:lambda:<AWS Region>:<AWS Account ID>:function:sls-meetup-alexa-skill-dev-meetupHandler
...
```
**Note:** Replace the `<AWS Region>` and `<AWS Account ID>` with real values for your AWS account.

We made a lot updates to the `serverless.yml` file. Here is how it looks at the end:

```
service: sls-meetup-alexa-skill

plugins:
  - serverless-alexa-skills

provider:
  name: aws
  runtime: nodejs8.10
  stage: dev
  region: us-east-1
  environment:
    MEETUP_API_KEY: ${env:MEETUP_API_KEY}

custom:
  alexa:
    vendorId: ${env:AMAZON_VENDOR_ID}
    clientId: ${env:AMAZON_CLIENT_ID}
    clientSecret: ${env:AMAZON_CLIENT_SECRET}
    localServerPort: 9000
    skills:
      - id: <YOUR_SKILL_ID_HERE>
        manifest:
          publishingInformation:
            locales:
              en-US:
                name: MeetupEvents
          apis:
            custom:
              endpoint:
                uri: <YOUR_LAMBDA_FUNCTION_ARN_HERE>
          manifestVersion: '1.0'
        models:
          en-US:
            interactionModel:
              languageModel:
                invocationName: meetup events
                intents:
                  - name: MeetupIntent
                    samples:
                    - 'my events'
                    - 'my meetup events'
                    - 'anything interesting in my meetup'
                    - 'give me all my meetup events'
                  - name: AMAZON.HelpIntent
                    samples: []
                  - name: AMAZON.CancelIntent
                    samples: []
                  - name: AMAZON.StopIntent
                    samples: []

functions:
  meetupHandler:
    handler: index.meetupHandler
    events:
      - alexaSkill: <YOUR_SKILL_ID_HERE>
```

## Build the Skill

We will update the skill again by running:

```
$ sls alexa update
```

And, finally we will build the Alexa skill.

```
$ sls alexa build
```
**Note**: You can use the option `--dryRun` to simulate what the command will do intsead of actually doing it.

### View the Interaction Model

Now that the skill has been built, we can see the interaction model, as follows:

```
$ sls alexa models

Serverless:
-------------------
[Skill ID] amzn1.ask.skill.xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxxxxxx
[Locale] en-US
[Interaction Model]
interactionModel:
  languageModel:
    invocationName: meetup events
    intents:
      - name: MeetupIntent
        samples:
          - my events
          - tmy meetup events
          - anything interesting in my meetup
          - give me all my meetup events
      - name: AMAZON.HelpIntent
        samples: []
      - name: AMAZON.CancelIntent
        samples: []
      - name: AMAZON.StopIntent
        samples: []
```

## Preview the Skill

Let's see what we have achieved so far. We have create a Alexa skill named MeetupEvents. Let's preview the skill we created on the Alexa Developer Console.

![image](https://user-images.githubusercontent.com/8188/44305288-fa291c00-a341-11e8-9dfa-cecaa83579e1.png)

After, the skill is built, we can see the Intents populated:

![image](https://user-images.githubusercontent.com/8188/44305357-46289080-a343-11e8-9ff8-506fe47b2265.png)

And, the MeetupIntent utterances are populated as well:

![image](https://user-images.githubusercontent.com/8188/44305376-9f90bf80-a343-11e8-8931-6b2423beeb38.png)

## Test the Skill

First enable testing for the skill. We will be using the Alexa Simulator to test our skill.

We start by typing **meetup events**, and we hear the welcome response.

Then, we type in **my events**, and we hear the list of events.

![image](https://user-images.githubusercontent.com/8188/44305392-3bbac680-a344-11e8-9660-114e70c02f39.png)

And, we have a working Alexa Skill that speaks out the latest meetup events.

## Logs and Cleanup

If can debug your skill Lambda functions by looking at the logs right from the terminal. And, then you can also cleanup everything after you are done.

### Logs

You can view the AWS CloudWatch logs from the terminal by running:

```
$ sls logs -f meetupHandler
```

### Cleanup

You can delete the Alexa skill, by:

```
$ sls alexa delete --id <skill_id>
```

and, you can also cleanup the Lambda functions deploys to AWS, by:

```
$ sls remove
```

## Summary

We started out to build an Alexa skill using serverless. We looked at creating a serverless project for the skill, created the Alexa skill, added an interaction model with intents, and added a lambda function to implement our skill for retrieving meetup events. Then we built and deployed the skill. Last but not least, we previewed and tested the skill using the Alexa Developer Console. 

You can access to the [full code](https://github.com/rupakg/sls-meetup-alexa-skill) on my Github repo. 

To learn more about building Alexa Skills visit the [learn](https://developer.amazon.com/alexa-skills-kit/learn) section on the Amazon Alexa site.

If you build something cool, or you have any questions or feedback, please let me know in the comments below.


