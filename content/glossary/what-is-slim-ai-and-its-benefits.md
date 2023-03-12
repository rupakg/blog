---
title: "What is SlimAI and its benefits"
description: "Learn about what is SlimAI, its benefits, and how it can be used to create slim optimized docker images."
date: 2023-03-11T23:06:36-05:00
lastmod: 2023-03-11T23:06:36-05:00
keywords: ["SlimAI", "Slim", "SlimToolkit", "docker", "containers", "DevOps", "security"]
tags: ["SlimAI", "docker", "containers"]
categories: ["docker", "DevOps"]
layout: glossary
type:  "glossary"
---

Containers have been around for a while and Docker commoditized them and brought it into the hands of every developer. The usage was simple and everyone could create a Docker image and run their apps in a container. Docker Swarm and Kubernetes took it further and made it possible for us to deploy and run containerized apps at scale. 

The ease of use and small learning curve to entry for creating and running containers had their shortcomings as well. Lots of developers without a deep knowledge of operating systems, systems administration, packaging, and dependency management have been Docker images and containers without much care. This proliferated docker images and containers that had unnecessary packages & dependencies leading to huge image sizes and vulnerabilities. This resulted in increasing the attack surface area for security hacks and decreased performance due to large image download sizes.
<!--more-->

## Why SlimAI?

Application developers still needed the freedom to create Docker images to run their apps and troubleshoot them but there was a need for DevOps and security teams to make sure that the images were secure with no vulnerabilities, smaller in size, and performant. It was a struggle and inconvenience for developers to impose the restrictions at development time because it hindered creativity, freedom, and ability to troubleshoot their apps without the additional development tools included as part of the images. 

To solve this problem, [DockerSlim](https://dockersl.im/) was created, now known as [SlimToolkit](https://slimtoolkit.org/) or simply Slim. The SaaS version is at [Slim.ai](https://slim.ai). Slim or SlimToolkit is open source and you can find the [source](https://github.com/slimtoolkit/slim) on GitHub.

>**Slim** was created by [Kyle](https://github.com/kcq) [Quest](https://twitter.com/kcqon) and it's been improved by many [contributors](https://github.com/slimtoolkit/slim/graphs/contributors). The project is supported by [Slim.AI](https://slim.ai/).

## What are the benefits of SlimAI?

The advantages of using Slim as cited from the Slim website:

>**Inspect, Optimize and Debug Your Containers**
>You don't have to change anything in your application images to make them smaller! Keep doing what you are doing. Use the base image you want. Use the package manager you want. Don't worry about hand optimizing your Dockerfile. Don't worry about manually creating Seccomp and AppArmor security profiles.

![How Slim makes images smaller, faster and more secure](https://github.com/slimtoolkit/slim/blob/master/assets/images/docs/SlimHow.jpeg?raw=true)
Courtesy and Credit: [Slim GitHub repo](https://github.com/slimtoolkit/slim)

Here are some of the benefits of SlimAI:

- Increased Developer Productivity and Insight
	- Analyzes instructions in Dockerfile
	- Reveals what's inside the image and what makes it fat
	- Optimizes images and generates security profiles
- Increased Agility and Automation
	- No changes to the source code
	- Automated detection, analysis, and remediation
	- Easily augmented into CI/CD pipelines
- Enhanced Efficiency and Cost Savings
	- Reduced container image size
	- Removal of unnecessary dependencies
	- Faster container image downloads
- Improved Security and Compliance
	- Reduced attack surface area
	- Reduced vulnerabilities
	- Reduced license risk

## How can I use SlimAI?

SlimAI offers an open-source [Slim CLI](https://github.com/slimtoolkit/slim) tool and a SaaS product at [Slim.AI](https://slim.ai/).

The following are some key commands that are available as part of the Slim CLI:

- `xray`: Performs static analysis for the target container image. Shows what's inside of your container image, what makes it fat, and reverse engineers its Dockerfile
- `build`: Analyzes, profiles, and optimizes target container image generating the supported Seccomp and AppArmor security profiles.
- `lint`: Analyzes container instructions in Dockerfiles.
- `profile`: Performs basic container image analysis and dynamic container analysis. Collects fat image information and generates a fat container report. But, it doesn't generate an optimized image.
- `run`: Runs one or more containers similar to `docker run`.

For a complete listing of commands and help, use `slim help`.

For an upcoming hands-on lab taking a deep dive into SlimAI, subscribe to my newsletter and keep an eye on future blog posts.




