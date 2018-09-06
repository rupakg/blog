---
title: "Lorry.io: Pathway to Docker Composable Apps"
date: 2015-05-26T13:26:19-04:00
lastmod: 2015-05-26T13:26:19-04:00
keywords: [ "docker", "containers", "docker-compose.yml", "development" ]
tags : [ "docker", "containers", "development"]
categories : [ "docker", "containers" ]
layout: post
type:  "post"
canonical:
  link: "https://www.ctl.io/developers/blog/post/lorry-io-pathway-to-docker-composable-apps"
  text: "CenturyLink Developer Center Blog"
---

![Lorry.io](https://user-images.githubusercontent.com/8188/45174150-1a792780-b1d8-11e8-9eae-2172bde1ad38.png)

Recently, Docker released the [Compose](http://blog.docker.com/tag/docker-compose/) tool for defining and running complex applications with Docker. The basic component of that tool is the file, `docker-compose.yml`. We at CenturyLink were big fans of [Fig](http://www.fig.sh/), the basis for Compose and the `docker-compose.yml`, but always envisioned a utility that could facilitate creating the `docker-compose.yml` files easily and intuitively.

> From that idea, we are happy to announce our latest project, [Lorry.io](https://lorry.io), a `docker-compose.yml` validator, editor and composer.

## Why Lorry?

We were primarily writing the `docker-compose.yml` file by hand and had to keep going back to the [docker-compose YAML reference](https://docs.docker.com/compose/yml/) to get the syntax right. We ran into issues with bad indentation, kept forgetting which keys had string vs sequence values, and found it hard to remember all the keys that were available. We quickly realized that to create multi-container based applications with Docker Compose, a person not only needed an understanding of the YAML format itself but an understanding of the components and options available to create a valid `docker-compose.yml`. Additionally, once a `docker-compose.yml` file was created manually there was not a simple way to validate what was created was actually valid besides running it.

> Recognizing that others could benefit from such a tool, we developed [Lorry.io](https://lorry.io). Lorry allows you to import an existing `docker-compose.yml` file and validate it against a schema based on the rules provided by Docker. 

You can also create a `docker-compose.yml` file from scratch or see some examples of good and bad `docker-compose.yml` files. Once editing is complete the file can easily be copied, shared or downloaded.

## The Lorry Workflow

![Lorry workflow](https://user-images.githubusercontent.com/8188/44745221-20cf1b80-aad5-11e8-8219-7fc9150f6ea1.png)
*Lorry workflow*

### Importing a YAML

If you are working on a "Dockerized" application, you probably already have a `docker-compose.yml` file that you use to run your app. In that case, you can use Lorry to import your YAML file either by pasting the contents of the file or uploading the file from your local machine.

![Lorry import screen](https://user-images.githubusercontent.com/8188/44745301-52e07d80-aad5-11e8-9675-d666dea24e2b.png)

*Lorry import screen*

### Validations

Once you import your YAML file, Lorry performs schema validations on it. The YAML file is then displayed with line numbers and visually broken up into service blocks corresponding to each service in your app. If Lorry finds any issues, it will highlight the appropriate lines with errors. If you get an error, check the info (i) icon to understand what's wrong. In cases where the file has warnings related to the format of the values entered by the user, a squiggly underline with a popup explaining the warning message is displayed.

![Lorry code error](https://user-images.githubusercontent.com/8188/44745347-799eb400-aad5-11e8-97c1-1cf0fc93dc34.png)

*Lorry code error*

### Fixing the YAML

After you have imported your YAML file and seen what Lorry has highlighted for you based on the validations, you can choose to edit the YAML file and fix the issues. You can edit one service block at a time by clicking the pencil icon from the action menu on the far right. You can also choose to delete the whole service block by clicking the delete (X) icon.

![Lorry Edit screen](https://user-images.githubusercontent.com/8188/44745398-a5219e80-aad5-11e8-8a81-6c7caed11e71.png)

*Lorry Edit screen*

Once you are in edit mode for a service block, you can see the errors with invalid keys highlighted in red. To fix the error, you can delete the key and its value by clicking the delete icon next to the item. You can add new key/value pairs by using the 'Add a key' dropdown. You can also add a new sequence value to an existing key, by clicking the appropriate '+ Add xxxxxx' link underneath the sequence. After you have made all your edits, you can save your changes or cancel your changes if you change your mind.

You can also look for help by hovering over the info icon for each key. In case of a service made from an image (as opposed to being built from source with the 'build' key), Lorry provides a convenient feature to search for an image on the Docker Hub, and add it along with the appropriate tag.

### Exporting the YAML

To use the YAML file that was created, you can either export and download it locally, copy it to the clipboard or save it as a Github Gist. As part of saving the YAML as a Github Gist, Lorry also provides a link to the YAML file that you can share with your friends.

## Starting from scratch

If you are new to Docker or new to running apps with Docker Compose, it is likely that you don't have a `docker-compose.yml` file yet. No worries. Lorry lets you create a `docker-compose.yml` file from scratch. Just select that option form the homepage. You can add as many service blocks as you want and then go through the edit/validate workflow as usual.

![Creating a docker-compose.yml file from scratch](https://user-images.githubusercontent.com/8188/44745506-ea45d080-aad5-11e8-8651-e3c41bc94f86.png)

*Creating a docker-compose.yml file from scratch*

If you are still not comfortable to start on your own, we have included some samples on the home page, that will showcase some of the basic uses cases. Feel free to peruse those samples, modify them to your needs and get started.

![Selecting a sample template file](https://user-images.githubusercontent.com/8188/44745565-12cdca80-aad6-11e8-9512-8fc539ab5b18.png)

*Selecting a sample template file*

## Bridging the gap with Panamax

If you have been using our flagship project [Panamax](http://panamax.io/), you will be delighted to hear that Lorry supports importing the Panamax templates that you have already created or the ones that are [publicly](https://github.com/CenturyLinkLabs/panamax-public-templates) available. Just use the 'Import PMX Template' tab in Lorry to import your PMX template file. Lorry will import the PMX template and convert it to a `docker-compose.yml` file, ready for use.

Finally, as with all CenturyLink projects [Lorry.io](https://lorry.io) is open-source and licensed under the Apache 2 license. Please check out our [Github project](https://github.com/CenturyLinkLabs/lorry-ui) and submit a pull request; we welcome all contributions.
