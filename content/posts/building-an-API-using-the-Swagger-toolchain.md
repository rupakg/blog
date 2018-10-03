---
title: "Building an API using the Swagger toolchain"
description: "Exploring the life-cycle and workflow of building an API from scratch using the Swagger toolchain."
date: 2018-10-03T00:29:37-04:00
lastmod: 2018-10-03T00:29:37-04:00
keywords : [ "API", "OpenAPI", "Swagger"]
tags : [ "API", "OpenAPI", "Swagger", "development"]
categories : [ "API" ]
layout: post
type:  "post"
---

We have been building APIs for ages, with varying standards and design styles - [SOAP](https://en.wikipedia.org/wiki/SOAP) web services, [gRPC](https://en.wikipedia.org/wiki/GRPC), [REST](https://en.wikipedia.org/wiki/Representational_state_transfer), and until recently [GraphQL](https://en.wikipedia.org/wiki/GraphQL). Instead of declaring a winning design style, I believe that each one of these design styles stands their ground, and it depends on the use case [when to use which style](https://nordicapis.com/when-to-use-what-rest-graphql-webhooks-grpc/).
<!--more-->

In this post, we will look at the end-to-end lifecycle of a REST API. We will explore using the [Swagger](https://swagger.io/) toolchain to **design**, **build**, **document**, **test** the API and enable **standardization** of the API across teams in the organization. 

> Check out my previous post comparing various [API Platforms and Specification formats](https://rupakganguly.com/posts/roundup-of-api-platforms-and-specifications/).

![image](https://user-images.githubusercontent.com/8188/44542748-b9cbf400-a6db-11e8-859e-d9c84cc9d38b.png)
Credit: swagger.io
 
## Life-cycle of creating an API

In the interest of time, we will be using the [PetStore API](https://petstore.swagger.io/) as our sample API. The focus of the article will be to go through the lifecycle of API development. 

**Note**: If you are interested in creating your own API spec from scratch, please use the [Swagger Editor](https://swagger.io/tools/swagger-editor/).

### Pre-requisites

Since we will be using Swagger tools, please go ahead and create an account on [Swagger.io](https://swagger.io/). Then choose SwaggerHub as your product.

### Designing the API Specs

For the design phase of the life-cycle, we have two options in the Swagger toolchain. You could use the [Swagger Editor](https://swagger.io/) if you prefer a local machine development experience. The Swagger Editor is a [downloadable](https://swagger.io/tools/swagger-editor/download/) tool.

But the [SwaggerHub](https://app.swaggerhub.com/) brings the Swagger Editor, UI, and Codegen tools to the cloud in an integrated API design and documentation, built for API teams working with the Swagger (OpenAPI) specification.

Since we will be using the Editor, UI and the Codegen tools, I will be using SwaggerHub for this post. Let's get started.

#### Create or Import an API

Although you can design your API in SwaggerHub from scratch, we will be creating our sample API using the [Petstore API](https://petstore.swagger.io/) template to save some cycles. 

Let's create a new API by clicking on **Create New** -> **Create New API** menu item, as shown below:

![image](https://user-images.githubusercontent.com/8188/46311198-66c54680-c58f-11e8-9dba-c36d46a2a776.png)

**Note**: You can also import an existing API by specifying the path or URL to your API JSON or YAML spec, or browse to select a local file. Use the **Import and Document API** menu item.

Next, pick the `Petstore` template, give a name `Demo-Petstore` and leave everything else as default. Click the **Create API** button.

![image](https://user-images.githubusercontent.com/8188/46311460-421d9e80-c590-11e8-982a-9a17db4adbe5.png)

**Note**: API Auto Mocking integration creates and maintains a mock of your API using the static responses defined in your spec. You can read about the [Auto-Mocking feature](https://app.swaggerhub.com/help/integrations/api-auto-mocking) in detail. 

The next page is the **Design View** and it is a bit busy. But it is a gold mine. Let's review what we got.

#### The API Design View

The API Design View shows information about your API.

![image](https://user-images.githubusercontent.com/8188/46380453-4caf6500-c670-11e8-9502-5682290fafde.png)

The left-hand side column shows a searchable list of API methods, that you can click on to see the specs in the middle column. The API methods are grouped by categories - Pet, Store, and User in our case. This view also lists the object models that our API spec defines. If you click on a model, you can see the model definition in the middle column.

The middle column shows the full API specs that include the basic info., the method paths, the security definitions, and the model definitions.

The right-hand side column is the API Docs for the Petstore API we just created. You can view it in full screen by clicking on **Preview Docs** menu as shown below:

![image](https://user-images.githubusercontent.com/8188/46312196-5e223f80-c592-11e8-9fb4-87255c4883f5.png)

The Swagger API Docs are not only verbose documentation of the API but they are also an interactive playground to test your APIs. We will learn about that in the testing section later.

#### Standardization

To have a consistent and standard for all APIs within an organization, it is important to have an org-wide style guide of conventions while creating API specs. 

SwaggerHub provides a [Style Validator](https://app.swaggerhub.com/help/integrations/style-validator), that can check if the API matches the guidelines set forth by the company. The style validator lets you define the validation rules, automates all those checks and notifies you of any failed validations or mismatches. The style validator can be added as an Integration and can validate aspects of the basic API info., operations, naming strategies, and object models.
 
### Building the API from Specs

After designing the API, SwaggerHub allows for server and client code generation, and interactive documentation.

#### Code Generation

To test our API locally, SwaggerHub can generate server stub code in many languages. In our case, let's generate a server stub for NodeJS, as shown below:

![image](https://user-images.githubusercontent.com/8188/46375646-f9361a80-c661-11e8-8777-bb838c06f5aa.png)

A file named `nodejs-server-server-generated.zip` will be downloaded to your local machine. Let's unzip the zip file and review the contents. Here are all the files that came with it:

```
├── nodejs-server-server-generated
│   ├── README.md
│   ├── api
│   │   └── swagger.yaml
│   ├── controllers
│   │   ├── Pet.js
│   │   ├── Store.js
│   │   └── User.js
│   ├── index.js
│   ├── package.json
│   ├── service
│   │   ├── PetService.js
│   │   ├── StoreService.js
│   │   └── UserService.js
│   └── utils
│       └── writer.js
```
Based on the README file, let's try the following:

To run the server, run:

```
npm start
```

To view the Swagger UI interface:

```
open http://localhost:8080/docs
```
​
​![image](https://user-images.githubusercontent.com/8188/46378276-17534900-c669-11e8-9bba-0dc3226d191e.png)
​
​​And, we have a local API server running with full interactive API documentation. The server exposes a very similar interface as SwaggerHub. But, the local server code can be updated with custom implementation for further testing. 
​​
​​You can also use the [Swagger UI](https://swagger.io/tools/swagger-ui/) interface to visualize and interact with your API just by having an API spec in place.
​​
​​​​​​Although you can tweak the [code generation options](https://app.swaggerhub.com/help/apis/generating-code/options) in SwaggerHub, if you want a lot of flexibility with code generation you should use the [Swagger Codegen](https://swagger.io/tools/swagger-codegen/) tool. It is an open-source tool with [lot more flexibility](https://github.com/swagger-api/swagger-codegen#public-docker-image) for generating code.

### Team Collaboration & Sharing

SwaggerHub has built-in capabilities to share and collaborate the API specs with the whole team. 

Team members can be made [collaborators](https://app.swaggerhub.com/help/collaboration/collaborators) and [share the API](https://app.swaggerhub.com/help/collaboration/sharing-api) specs with other members. The users can be assigned Editor, Viewer or Commentator roles based on their needs. All collaborators can receive [email notifications](https://app.swaggerhub.com/help/email-notifications) as and when changes are done to the API specs.

Users can edit the API specs concurrently and SwaggerHub provides an elegant way to [compare and merge](https://app.swaggerhub.com/help/apis/compare-and-merge) such changes.

#### Orgs, Teams and Projects

SwaggerHub also provides further flexibility in managing control over the API specs by allowing the creation of [Organizations, Teams, and Projects](https://app.swaggerhub.com/help/organizations/index). This simplifies and structures the different APIs across the organization. Access controls specified at the Org, team or project levels govern permissions allowed for collaborators. 

**Note**: Organizations need a paid-plan based on the number of user and features.

#### Reviewing the API

​SwaggerHub allows adding [comments](https://app.swaggerhub.com/help/collaboration/comments) to any part of the API specs. It allows for team collaboration and discussion regarding the API specs. Once the comments have been discussed they can be resolved. It provides an easy workflow for the team to evolve the API in a very interactive way.

#### API Versioning

​In the real world, while developing an API spec, it is imperative that there is a lot of back and forth that happens which leads to many versions of the API. SwaggerHub recognizes that and allows for [versioning](https://app.swaggerhub.com/help/apis/versioning) of APIs along the way. Team members can edit the API and specify a new version that can later be [compared and merged](https://app.swaggerhub.com/help/apis/compare-and-merge).

Multiple versions of an API can live side-by-side and the design view on SwaggerHub allows users to easily switch between the different versions.

When a particular version is ready to be released, it can be [published](https://app.swaggerhub.com/help/apis/publishing-api). Publishing an API makes the API spec read-only and it is not allowed to be modified after that.

**Note**: An API spec can be unpublished and changes made to it, but that should happen only sparingly and with a lot of caution.

### Testing the API

After designing an API and before the developers actually implement it in code, some initial testing provides a lot of value. This kind of testing involves testing the API methods, requests, response, object models and security aspects. It allows the design team to fine tune and solidifies the API design before the API is implemented in code. It jump starts the process of developers to start writing client code and testing against the stub generated from the API spec.

#### Mock Implementations
 
SwaggerHub provides a cool feature of [Auto Mocking](https://app.swaggerhub.com/help/integrations/api-auto-mocking) as part of its integrations. To make use of auto-mocking, the API spec can specify examples for requests and response schemas for its methods. 

The API spec can define formats for the data types, reference object models in responses and specify request/response headers. 

Authorization on API calls can be mocked by allowing users to send in arbitrary API token along with the requests. 

It also supports CORS requests and can automatically add CORS headers to all responses. 

Rate-limiting can be configured and appropriate error codes can be returned based on API call volume.

### Publishing the API

Once you are ready to release an API, you can choose a particular version and [publish](https://app.swaggerhub.com/help/apis/publishing-api) it. Published APIs are read-only and they are not allowed to be modified. Unpublished APIs can be held as working drafts in SwaggerHub and modified at will. Published versions can be kept private or made public based on readiness. Swagger allows usage of API tokens to access private APIs.

## Leveraging Swagger for existing APIs

Swagger toolchain provides a [Swagger Inspector](https://inspector.swagger.io), a web-based, Postman-style testing of APIs. It allows making requests on your API methods and validates API request/responses. All tests are saved so you can replay them and view the responses later. The Swagger Inspector can test any kind of API including REST, SOAP or GraphQL based APIs.

The best use case for the Inspector is if you have any existing API and you want to create an API definition for it. You can make calls to your API methods and can easily [generate OpenAPI defnitions](https://swagger.io/docs/swagger-inspector/how-to-create-an-openapi-definition-using-swagger/) from the request and responses. You can auto-generate documentation for your API endpoints from the previously saved tests.

Another interesting open-source project useful for Java developers is the [Swagger Inflector](https://github.com/swagger-api/swagger-inflector) that can be used to [parse and generate OpenAPI definitions](https://swagger.io/blog/api-development/writing-apis-with-the-swagger-inflector/) during runtime.

Once you have the API spec generated and saved into SwaggerHub, you can take advantage of the full Swagger toolchain from there on.

## Summary

In this post, we looked at the workflow of building an API using the various tools available in the Swagger toolchain. We looked at designing an API using a template on SwaggerHub. We explored how SwaggerHub allows for standardization of APIs via styling guidelines and validation rules via the Style Validator. Swagger Codegen allows generation of server and client code stubs for easy testing. We looked at the team collaboration and sharing features of SwaggerHub, and explored ways to manage access controls using orgs., teams and projects. Then we looked at versioning and testing the APIs using mock implementations. 

As you can see, the Swagger toolchain has all the tools to help you through the life-cycle of designing, testing and publishing an API from scratch.

If you have any feedback or questions, feel free to let me know in the comments below.