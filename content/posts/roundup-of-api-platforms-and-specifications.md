---
title: "Roundup of API Platforms and Specifications"
description: "Comparing some popular API platforms and specification formats."
date: 2018-08-31T12:59:38-04:00
lastmod: 2018-08-31T12:59:38-04:00
keywords: ["API", "OpenAPI", "Swagger", "Apigee", "3scale", "Akana", "Boomi", "Kong", "Mashery", "Mulesoft", "RAML", "API Blueprint", "WADL"]
tags : [ "API", "OpenAPI", "Swagger"]
categories : [ "API" ]
layout: post
type:  "post"
highlight: false
---

While researching for full, end-to-end, lifecycle API management tools, I discovered many that fit the bill. In this post, I compare some popular API platforms and specification formats.
<!--more-->

![image](https://user-images.githubusercontent.com/8188/44551953-a8dcac00-a6f6-11e8-8150-646e1c86a083.png)

*Image Credit: Apigee*

## API Platforms

The market is full of API platforms. Without going into details, here is a feature comparison for some of the popular platforms. I have created a matrix of feature sets that are crucial in deciding on an API platform that will meet the needs.

| Platform       | Design     | Code Gen.   | Documentation | Testing/Portal | Management|
|------------|------------|------------|----------|------|--------------|
| [3Scale](https://www.3scale.net/)     | Supports Swagger | None | ActiveDocs (Swagger compliant) | Developer Portal | Security, Analytics, Monetization, Dashboard, Traffic Mgmt. |
| [Akana](https://www.roguewave.com/products-services/akana)      | Graphical Designer. Supports Swagger, RAML, WADL, WSDL | Build Code | Document | Developer Portal | API Gateway, Security, Analytics, Orchestration, Transformation, Traffic Mgmt.
| [Apigee](https://apigee.com/)     | Edge UI. Supports OpenAPI Specs | None | [Developer Portal](https://apigee.com/api-management/#/product/developer-portal) | [Developer Portal](https://apigee.com/api-management/#/product/developer-portal) | API Gateway, Security, Analytics, Monetization, Orchestration, Transformation, Traffic Mgmt., API Proxy Editor|
| [Boomi](https://boomi.com/)     | [Mediate](https://boomi.com/platform/mediate/) | None | None | None | [Workflow](https://boomi.com/platform/flow/), [B2B/EDI Data Exchange](https://boomi.com/platform/exchange/), [Data Hub](https://boomi.com/platform/hub/), [Data Integration](https://boomi.com/platform/integrate/), Traffic Mgmt., Usage Dashboard
| [Kong](https://konghq.com/)       | None | None | None | None | [API Gateway](https://konghq.com/api-gateway/)
| [Mashery](https://www.mashery.com/)    | Visual API Modeling. Supports OpenAPI Specs | Build Code | [API Developer Portal](https://www.mashery.com/api/portal) | Mocking and Testing | [API Gateway](https://www.mashery.com/api/gateway), [Analytics](https://www.mashery.com/api/analytics), Traffic Mgmt., Security, Monetization, 
| [MuleSoft](https://www.mulesoft.com/)   | [Anypoint Design Center](https://www.mulesoft.com/platform/anypoint-design-center) | [Anypoint Studio](https://www.mulesoft.com/platform/studio), [Anypoint Connector DevKit](https://www.mulesoft.com/platform/devkit) | [Anypoint Design Center](https://www.mulesoft.com/platform/anypoint-design-center) | [MUnit](https://www.mulesoft.com/platform/munit-integration-testing) | [Anypoint Management Center](https://www.mulesoft.com/platform/anypoint-management-center), [CloudHub](https://www.mulesoft.com/platform/saas/cloudhub-ipaas-cloud-based-integration)| [RAML](https://raml.org/)    | [API Workbench](https://raml.org/projects#q:api%20workbench), [API Designer](https://raml.org/projects#q:api%20designer)  | [Generators](https://raml.org/developers/build-your-api) | [Documentation Tools](https://raml.org/developers/document-your-api) | [Testing Tools](https://raml.org/developers/test-your-api) |
| [Swagger](http://swagger.io)    | [Swagger Editor](https://swagger.io/tools/swagger-editor/), [SwaggerHub](https://swagger.io/tools/swaggerhub/) | [Swagger Codegen](https://swagger.io/tools/swagger-codegen/) | [Swagger UI](https://swagger.io/tools/swagger-ui/), [SwaggerHub](https://swagger.io/tools/swaggerhub/), [Swagger Inspector](https://swagger.io/tools/swagger-inspector/) | [Swagger Inspector](https://swagger.io/tools/swagger-inspector/) | None

> See my post about [What Is Swagger and Why It Is Used](/glossary/what-is-swagger-and-why-it-is-used/)

## API Specification Formats

I thought I will mention the popular API Specification formats as well. The OpenAPI Specifications (previously Swagger API Specs) and RAML are the most popular.

* [OpenAPI or Swagger](https://swagger.io/specification/)
* [RAML](https://github.com/raml-org/raml-spec/blob/master/versions/raml-10/raml-10.md/)
* [API Blueprint](https://apiblueprint.org/documentation/specification.html)
* [WADL](https://en.wikipedia.org/wiki/Web_Application_Description_Language)

Hope you liked the comparison of the API platforms and various specification formats. 

I am working on an article that will cover building an API from scratch using the Swagger toolchain. So stay tuned!

If you have any feedback, please let me know in the comments below.
