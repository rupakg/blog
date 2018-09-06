---
title: "Managing Application Code in Linux Containers"
description: "Many developers have heard of Linux containers and Docker. But how do you deploy your code to an application running in Linux containers?"
date: 2014-10-10T13:31:40-04:00
lastmod: 2014-10-10T13:31:40-04:00
keywords: [ "docker", "containers", "wordpress", "development" ]
tags : [ "docker", "containers", "development" ]
categories : [ "docker", "containers" ]
layout: post
type:  "post"
canonical:
  link: "https://www.ctl.io/developers/blog/post/managing-application-code-in-linux-containers"
  text: "CenturyLink Developer Center Blog"
---

Many developers have heard of Linux containers and Docker. But how do you deploy your code to an application running in Linux containers?

Let's go over that in this article, using a very simple yet effective workflow. We'll focus on WordPress, but these principles can be used with Ruby, Python, or even Go applications.

I think most of the time, users need to manage Wordpress for adding/updating plugins, themes etc. Although, the same can be achieved via the WordPress UI, we will use it as a simple use case to demonstrate propogating code changes to the WordPress application.

## Get Panamax

If you're on a Mac, installing [Panamax](http://panamax.io) couldn't be easier:

```
$ brew install http://download.panamax.io/installer/brew/panamax.rb 
$ panamax init
```
If you are on Linux, it is easy too. Just follow the [instructions](https://github.com/CenturyLinkLabs/panamax-ui/wiki/Installing-Panamax)</a> on the wiki. It might also be helpful to peruse the [documentation](http://panamax.io/documentation/)</a> for Panamax.

## The Workflow

We will create an application via Panamax, that will have two containers: one for MySQL, and the other for WordPress. WordPress will be linked to the MySQL container. All that part is done for you if you use the [Wordpress template](https://github.com/CenturyLinkLabs/panamax-public-templates/blob/master/wordpress.pmx) we have.

We will start with an example of how we can update themes and plugins, from our machine without using the WordPress web UI or without getting into the WordPress container.

### Creating the Wordpress application

Assuming that you have Panamax installed and you can see the Panamax UI on your browser, we will get going and create our first application.

We will use a WordPress application created in Panamax to demonstrate our solution. The reason I picked WordPress is due to the nature of simplicity of the solution, familiarity of WordPress across the community and how the code is laid out. But, the concept can be applied to any Panamax application.

From the Dashboard page, click on 'Create a New Application' button to go to the search page. Search for 'WordPress', and pick the official template for WordPress that appears in the search results.

Click on the 'Run Template' button, and Panamax should start the application. It is important to note that the images for WordPress and MySql can take a little while to get downloaded and spun up. Once you see the spinners go away, you should have your application running.

![Application details screen in Panamax showing WordPress app](https://user-images.githubusercontent.com/8188/44743412-6c32fb00-aad0-11e8-8593-808c21bffa78.png)

**Fig 1**: *Application details screen in Panamax showing WordPress app*

To be able to view our applications running inside the host VM, we need to forward the port(s) for our application. You can view instructions on [port forwarding](https://github.com/CenturyLinkLabs/panamax-ui/wiki/How-To%3A-Port-Forwarding-on-VirtualBox#port-forwarding-via-the-terminal-window) on our wiki.

Let's make sure the application is running and we can browse to the WordPress admin screen at `http://localhost:8997` (assumption being you forwarded port 8080 to 8997).

![WordPress admin screen setup Here we can configure the required fields and get WordPress installed. We have a few themes and plugins installed by default, but we would like to add our own](https://user-images.githubusercontent.com/8188/44743664-1b6fd200-aad1-11e8-8cc4-fdb1993c1227.png)

**Fig 2**: *WordPress admin screen setup Here we can configure the required fields and get WordPress installed. We have a few themes and plugins installed by default, but we would like to add our own*

![WordPress admin screen showing themes](https://user-images.githubusercontent.com/8188/44743728-4c500700-aad1-11e8-8c28-c2d91598b9e2.png)
![WordPress admin screen showing plugins](https://user-images.githubusercontent.com/8188/44743757-5ffb6d80-aad1-11e8-8404-953de66847ec.png)

**Fig 3**: *WordPress admin screen showing themes and plugins*

### The lay of the land

To understand the different realms of our application and code, we need to understand how they are mapped across different layers.

![Mapping of folders in Mac/host VM/containers](https://user-images.githubusercontent.com/8188/44743853-9c2ece00-aad1-11e8-93b0-86e85712e79e.png)

**Fig 4**: *Mapping of folders in Mac/host VM/containers*

As shown in the above illustration, the code folder from the physical machine (Mac) is mapped and synced to the host VM (CoreOS) by Vagrant (See Vagrantfile later). Then the code folder from the host VM (CoreOS) is mapped to the folder inside the WP container by the volume mount (See 'Configuring the Application' later).

**The Mac (physical machine)** Code Path: `/my/local/path/wp-content`

**The Host VM (the CoreOS VM)** Code Path: `/Users/username/src/wordpress/app/wp-content`

**The Container (WP)** Code Path: `/app/wp-content`

### Accessing the code

Just accessing the code from within the host VM or within the container, is not sufficient. We want to use our own machine, our own tools, our favorite editor, and manage our code. We need the code on our machine. Let's do that.

We can modify the Vagrantfile that Panamax uses to build the host VM, to further share the `wp-content` folder from inside the host VM to the working folder outside on the physical machine i.e. the Mac in my case.

Add the following lines into the Vagrantfile under `~/.panamax`, to create a NFS share mount:

```
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.network &quot;private_network&quot;, ip: &quot;x.x.x.x&quot;
  config.vm.synced_folder &quot;/my/local/path/wp-content&quot;,
    &quot;/Users/username/src/wordpress/app/wp-content&quot;,
    id: &quot;core&quot;, nfs: true, mount_options: ['nolock,vers=3,udp']
end
```

For the change in the Vagrantfile to have effect, we need to restart Panamax by running `panamax restart`.

Now, we can edit code in the working folder (`/my/local/path/wp-content` as configured in the Vagrantfile above) on the Mac, to propogate the changes to the shared folder (`/Users/username/src/wordpress/app/wp-content`) on the host VM.

### Injecting code into the container

Before, we can mount a volume to map the host VM path to a container path, we need to make sure we have content in it.

Create a code folder in the Panamax VM host, and put the relevant Wordpress code i.e. the contents of the `wp-content` folder in there. Get into the Panamax host VM by `panamax ssh`, and then execute the command at the terminal:

```
$ mkdir -p /home/core/src/wordpress/app
$ cd /home/core/src/wordpress/app
$ curl -O http://wordpress.org/wordpress-3.9.1.tar.gz
$ tar -xzvf wordpress-3.9.1.tar.gz wordpress/wp-content -C --strip-components=1
$ rm wordpress-3.9.1.tar.gz
```

After that, we can `exit` out of the Panamax shell.

That will get the contents of the `wp-content` folder into the `/home/core/src/wordpress/app/wp-content` folder, and we will later volume mount that folder into the Wordpress container.

Note, that the default Wordpress container has all the code that is necessary to run WordPress, but we are selectively replacing the contents of the `wp-content` folder from our working folder, so that we can change the code, without getting inside the container.

### Configuring the application

Let's get back in Panamax and create a volume mount from our working folder at `/home/core/src/wordpress/app/wp-content` to the `/app/wp-content` folder inside the Wordpress container. See the screenshot below to see how to do that in Panamax.

![WordPress container details page with volume mount](https://user-images.githubusercontent.com/8188/44744135-663e1980-aad2-11e8-9e4c-acfc2930a18c.png)

**Fig 5**: *WordPress container details page with volume mount*

Click on 'Save all changes' to commit the change. You will notice that Panamax automatically detects the change and restarts the application. Wait until both of the containers are started.

**Note**: Since volume mounting a path on a container will override the contents from the mapped folders, if you do not have the corresponding folders mapped properly, your WordPress application will either not work or the themes/plugins will not show up properly.

Since, we have not really injected the code at the folder `/home/core/src/wordpress/app/wp-content` on the host, the application is broken as of now.

I promise it will work soon.

## Making code updates

For making code changes, the easiest examples would be to add a new theme and a new plugin on the working folder and see the changes being reflected all the way on the WordPress site running inside the container.

Let's get a theme and a plugin and copy them to the `wp-content/themes` and `wp-content/plugins` folder respectively.

### Installing a theme

I picked one of the responsive themes from the WP Featured gallery named [Vantage](https://wordpress.org/themes/vantage).

Let's download and copy the theme over to the `wp-content/themes` folder by:

```
$ cd /home/core/src/wordpress/app/wp-content/themes
$ curl -O https://wordpress.org/themes/download/vantage.1.2.zip
$ unzip vantage.1.2.zip
$ rm vantage.1.2.zip
```

Also, we wanted to cleanup the other two themes we don't need, so we will delete the `twentytwelve` and the `twentythirteen` themes by:

```
$ cd /home/core/src/wordpress/app/wp-content/themes
$ rm -rf twentytwelve
$ rm -rf twentythirteen
```

Now, let's look at our Wordpress admin screens:

![Theme showing up on WordPress app as you can see we have our new theme installed](https://user-images.githubusercontent.com/8188/44744282-caf97400-aad2-11e8-9ff3-395125613355.png)

**Fig 6**: *Theme showing up on WordPress app as you can see we have our new theme installed*

### Installing a plugin

I picked the [WP Mobile Detector Mobile](http://wordpress.org/plugins/wp-mobile-detector/) plugin to be installed. Let's download and copy the theme over to the `wp-content/plugins` folder by:

```
$ cd /home/core/src/wordpress/app/wp-content/plugins
$ curl -O http://downloads.wordpress.org/plugin/wp-mobile-detector.1.8.zip
$ unzip wp-mobile-detector.1.8.zip
$ rm wp-mobile-detector.1.8.zip
```

Also, we wanted to cleanup the other plugin we don't need, so we will delete the `Hello Dolly` themes by:

```
$ cd /home/core/src/wordpress/app/wp-content/plugins
$ rm -rf hello.php
```

![Plugin showing up on Wordpress app Viola! We have our theme and plugin i.e. our custom code deployed to the containerized WordPress application running under Panamax](https://user-images.githubusercontent.com/8188/44744365-fed49980-aad2-11e8-944d-dbed1cc34f6e.png)

**Fig 7**: *Plugin showing up on Wordpress app* 

Viola! We have our theme and plugin i.e. our custom code deployed to the containerized WordPress application running under Panamax.

## Word of caution

Although, this article talks about mounting a folder from the host into the container, I need to caution you that this makes the container not so portable. If you move your container to a different host system, and if the folder structure on your host that you mounted changes, then your container will not work anymore.

This article tries to demonstrate, the ways to make it easy to develop code for your application using the convenience and comforts of your host system or your physical system. My recommendation is to inject the code permanently inside the container while creating the image for your application.

Let me know in the comments below how creative you have been with containers and managing your development workflow.
