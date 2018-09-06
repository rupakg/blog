---
title: "Monitoring Docker Services With Prometheus"
description: "With the advent of the microservices architecture and the evolving trend for using Docker, monolithic applications are being broken up into smaller and independent services. There is a need to monitor these services around the clock. We look at Prometheus, and demonstrate its capabilities by using it to monitor containerized services."
date: 2015-07-21T14:08:43-04:00
lastmod: 2015-07-21T14:08:43-04:00
keywords : [ "docker", "containers", "prometheus", "development", "monitoring", "microservices", "devops" ]
tags : [ "docker", "containers", "prometheus", "development", "monitoring", "microservices", "devops" ]
categories : [ "docker", "containers", "monitoring", "microservices", "devops" ]
layout: post
type:  "post"
canonical:
  link: "https://www.ctl.io/developers/blog/post/monitoring-docker-services-with-prometheus"
  text: "CenturyLink Developer Center Blog"
---

![Prometheus and Docker](https://user-images.githubusercontent.com/8188/45176479-1b14bc80-b1de-11e8-8b8d-c9890e21fabb.png)

With the advent of the 'micro-services' architecture and the evolving trend for using Docker, monolithic applications are being broken up into smaller and independent services. The idea is to keep the services small so that small groups of developers can work on them, upgrade or patch them quickly, and build & release them continuously. Although that vision is promising, it introduces complexity as the number of services grow. With that also grows the need to monitor these services around the clock, to maintain the healthy functioning of the application.

## Overview

Here we look at [Prometheus](http://prometheus.io), and demonstrate its capabilities by using it to monitor [Panamax](http://panamax.io) and its containerized services. Written in Go, Prometheus, is a open-source monitoring service and alerting toolkit build at SoundCloud. It boasts of a variety of [features and components](http://prometheus.io/docs/introduction/overview/) that made it really interesting for me to evaluate it internally at CenturyLink Labs.

## Architecture

Prometheus was written from the ground up, based on real use cases and experiences at SoundCloud, designed to tackle real problems faced in real production systems.

![Prometheus Architecture](https://user-images.githubusercontent.com/8188/44811108-c059e000-aba1-11e8-8c58-304125ebea14.png)

*Prometheus Architecture (Pic Courtesy: prometheus.io)*

In the heart of the system is the **Prometheus server**, backed up by a local database server. Prometheus is based on a 'pull' mechanism, that scrapes metrics from the configured targets. However, for short-lived jobs, it provides an intermediary **push gateway** for scraping metrics. It also provides **PromDash**, a visualization dashboard for the collected data, an **Expression browser** with a **query language** to ease filtering of data, and an **AlertManager** to send notifications based on triggered alerts based on an alert rules engine. You can find more resources on their [media](http://prometheus.io/docs/introduction/media/) page.

## Monitoring Panamax

So to give Prometheus a whirl, I decided to monitor Panamax and its services. The goals were:

* Setup Prometheus
* Configure it to monitor Panamax services
	* use the existing cAdvisor endpoint exposed by Panamax
	* use the 'container-exporter' provided by Prometheus
* Run all components as Dockerized services
* Manage alerts and notifications
	* configure alert rules
	* setup AlertManager to send notifications to Hipchat
* Visualize and query metrics on Prometheus GUI
* Receive notifications on Hipchat So without further ado, let's get on with it.

**Note**: I am assuming that you have a working [Docker installation](https://docs.docker.com/installation/) and a working [installation of Panamax](http://panamax.io/get-panamax/) on your machine, if you want to follow along.

## Setup & Configuration

The goal was to run Prometheus as a Docker service although it can be installed as a binary from the available [releases](https://github.com/prometheus/prometheus/releases), or built from [source](https://github.com/prometheus/prometheus/blob/master/README.md#use-make). Luckily, all the [Prometheus services](https://registry.hub.docker.com/repos/prom/) are available as Docker images.

### Configure Prometheus

In preparation to run Prometheus, we have to create a configuration file named `prometheus.yml` that allows setting up of jobs and targets for scraping. Create a folder named `prometheus` and create a new yaml file named `prometheus.yml` with the contents shown below.

`$ mkdir prometheus && cd prometheus && touch prometheus.yml`

```
## prometheus.yml ##

global:
  scrape_interval: 15s # By default, scrape targets every 15 seconds.
  evaluation_interval: 15s # By default, scrape targets every 15 seconds.
  # scrape_timeout is set to the global default (10s).

  # Attach these extra labels to all time-series collected by this Prometheus instance.
  labels:
    monitor: 'panamax-monitor'

rule_files:
  - '/etc/prometheus/alert.rules'

# A scrape configuration containing exactly one endpoint to scrape:
scrape_configs:
# The job name is added as a label `job=&lt;job_name&gt;` to any timeseries scraped from this config.

  # Panamax
  - job_name: 'panamax'
    scrape_interval: 5s

    # Override the global default and scrape targets from this job every 5 seconds.
    scrape_interval: 5s
    scrape_timeout: 10s

    target_groups:
      - targets: ['10.0.0.200:3002']
        labels:
          group: 'development'
```

The `global` section describes and overrides some defaults. The `labels` section, attaches a specific label to this instance of the Prometheus server. The `rule_files` section lists all rule files ([recording or alert rules](http://prometheus.io/docs/querying/rules/)) that Prometheus needs to load and process. We will look at the rule file described here at a later time. The `scrape_configs` section, describes the job(s) that Prometheus needs to process. In our case, we have a job named `panamax`, with some config items, including the `target_groups` sub-section. We add a target that points to the cAdvisor address running as part of the Panamax application. 

**Note**: The IP address `10.0.0.200` is my Panamax address also aliased as `panamax.local`.

### Configure cAdvisor for Prometheus

If you are already using [cAdvisor](https://github.com/google/cadvisor), version 0.11.0 and above has [Prometheus integration](https://github.com/google/cadvisor/blob/master/docs/prometheus.md). Prometheus can leverage the host and container level metrics exposed by cAdvisor. To see the metrics exposed by cAdvisor, go to:

```
# cAdvisor metrics endpoint
10.0.0.200:3002/metrics
```

Since in the `prometheus.yml` configuration we specified the target as the cAdvisor address, Prometheus will automatically look for the `/metrics` endpoint, to expose the metrics.

### Run container-exporter as a service

If you looking to capture host and container level metrics, Prometheus also provides a [container-exporter](https://registry.hub.docker.com/u/prom/container-exporter/), that can be run side by side to your other docker services. Many other [exporters and third-party integrations](http://prometheus.io/docs/instrumenting/exporters/) are also provided by Prometheus.

```
docker run -d **name PROM_CON_EXP \
              -p 9104:9104 \
              -v /sys/fs/cgroup:/cgroup \
              -v /var/run/docker.sock:/var/run/docker.sock \
              prom/container-exporter
```

In this case, the `target_groups` section of the `prometheus.yml` file will have a target that points to the address of the 'container-exporter' like so:

```
...
     target_groups:
       - targets: ['10.0.0.200:9104']
         labels:
           group: 'development'
...
```

This tells Prometheus to leverage the host and container level metrics exposed by the 'container-exporter' service. To see the metrics exposed by the 'container-exporter' service, go to:

```
# 'container-exporter' service metrics endpoint #
10.0.0.200:9104/metrics
```

**Note**: You only need one target that exposes metrics for your application. In our case, we are using cAdvisor for collecting host and container level metrics for Panamax.

## Setup Alerts and Notifications

Various alert rules can be configured within Prometheus, to detect events that happen based on metric counters that Prometheus tracks. To send notifications based on these alerts, the **AlertManager** component is used. An AlertManager instance can be configured via the `alertmanager.url` flag while starting Prometheus, thus enabling notifications to be sent when alerts are triggered. 

To start off, I wanted to set up a simple alert that detects if Panamax application is down, and notifies me on my Hipchat room.

### Add alert rules to Prometheus

To configure an alert in Prometheus, we need to create an alert rules file. Create a new text file named `alert.rules` with the contents shown below.

`$ cd prometheus && touch alert.rules`

```
## alert.rules ##

# Alert for any instance that is unreachable for &gt;5 minutes.
ALERT pmx_down
  IF up == 0
  FOR 5m
  WITH {
    severity="page"
  }
  SUMMARY "Instance {{$labels.instance}} down"
  DESCRIPTION "{{$labels.instance}} of job {{$labels.job}} has been down for more than 5 minutes."
```

Here we are setting up a alert named `pmx_down`, which specifies a condition `up == 0` using the `IF` clause, and the `FOR` clause specifying that the alert will be triggered after 5m that the condition remains true. In other words, if Panamax is down for 5m, this alert will be triggered. The `WITH` clause attaches an additional label of `severity="page"` to the alert. The `SUMMARY` and the `DESCRIPTION` clauses are self-explanatory, but we will soon see that the text in the `SUMMARY` clause is what gets written as the notification text on Hipchat.

### Configure AlertManager

Adding an alert as we did above, sets up Prometheus to trigger an alert when conditions are met, but to send notifications, Prometheus relies on the **AlertManager** component. So, lets set that up so we can send notifications to Hipchat, when our alert is triggered. To do so, we need to create a configuration file. Create a new text file named `alertmanager.conf` with the contents shown below.

`$ cd prometheus && touch alertmanager.conf`

```
## alertmanager.conf ##

notification_config {
  name: "alertmanager_hipchat"
  hipchat_config {
    auth_token: "&lt;hipchat_token_here&gt;"
    room_id: 123456
    send_resolved: true
  }
}

aggregation_rule {
  repeat_rate_seconds: 3600
  notification_config_name: "alertmanager_hipchat"
}
```

We are setting up a `notification_config` for Hipchat, with some specific keys required by Hipchat. The `send_resolved` setting is used to trigger an additional notification when the alert condition is 'resolved'. in our case, it would be when the Panamax application is back up. The `aggregation_rule` sets up an attribute `repeat_rate_seconds` which configures the notifications to be repeated for the specified duration in seconds. In our case, we want the notifications to be repeated every 2 hours while the Panamax application is down. The notifications are stopped when the alert condition is no longer met or the alert is manually silenced from the Prometheus UI.

### Run AlertManager as a service

Now that we have a configuration for the AlertManager, we can run it is as a container service, passing in the `alertmanager.conf` via the `config.file` flag.

```
docker run -d -p 9093:9093
              -v $PWD/alertmanager.conf:/alertmanager.conf \
              prom/alertmanager \
              -config.file=/alertmanager.conf
```
And, we can see our container running:

```
CONTAINER ID IMAGE             CREATED         PORTS
bd947de3d58c prom/alertmanager 22 hours ago    0.0.0.0:9093-&gt;9093/tcp
```

**Note**: We will record the port where the AlertManager is running as we need it in the next section.

### Run Prometheus as a service

With the `prometheus.yml` setup, the metrics endpoint setup, the alert rules setup and the AlertManager configuration setup, we can finally run the Prometheus server as a container service. As soon as the service starts, it will start scraping the metrics, and make it available on the Prometheus UI.

```
docker run -d -p 9090:9090 \
              -v $PWD/prometheus.yml:/etc/prometheus/prometheus.yml \
              -v $PWD/alert.rules:/etc/prometheus/alert.rules \
              prom/prometheus \
              -config.file=/etc/prometheus/prometheus.yml \
              -alertmanager.url=http://192.168.59.103:9093
```

We expose the Prometheus UI at port 9090, and volume mount the local `prometheus.yml` file & `alert.rules` file to `/etc/prometheus/prometheus.yml`, where it is picked up by Prometheus. We also pass the configuration file path via the `config.file` flag and pass the alert manager url via the `alertmanager.url` flag.

**Note**: The IP address `http://192.168.59.103` is my Docker Host address. And, we can see our container running:

```
CONTAINER ID IMAGE           CREATED          PORTS
34af30279267 prom/prometheus 22 hours ago     0.0.0.0:9090-&gt;9090/tcp
```

This completes our setup and configuration, resulting in running Prometheus server and the AlertManager, both as container services.

### Prometheus UI and Querying

Now, that we are running Prometheus and scraping metrics off Panamax application, we can head over to the Prometheus UI, to visualize the metrics and query them.

**Note**: There is a separate component [PromDash](http://prometheus.io/docs/visualization/promdash/), which is more elaborate Prometheus dashboard, that I talk about at the end of the article.

### Prometheus UI

The Prometheus UI is available at your Docker Host address on port 9090. Click on the 'Graph' menu item to open the Expression Browser.

![PromDash UI](https://user-images.githubusercontent.com/8188/44811644-1da26100-aba3-11e8-8be7-897e41230620.png)

*PromDash UI*

The above screenshot shows you the metric counters that were picked up by Prometheus exposed by cAdvisor.

### Querying

In the query field, paste the following query, and hit 'Execute'. Then click on the 'Graph' tab, to see the visualization of metrics for `memory_usage_bytes` counter for the PMX_UI container.

```
container_memory_usage_bytes{instance="10.0.0.200:3002",job="panamax", name="PMX_UI"}
```

![Graph for Panamax UI container usage by bytes](https://user-images.githubusercontent.com/8188/44811710-56423a80-aba3-11e8-8876-576749590216.png)

*Graph for Panamax UI container usage by bytes*

Next, click on the 'Add Graph' button, and paste the following query, and hit 'Execute'. Then click on the 'Graph' tab, to see the visualization of metrics for `memory_usage_bytes` counter for the PMX_API container.

```
container_memory_usage_bytes{instance="10.0.0.200:3002",job="panamax", name="PMX_API"}
```

![Graph for Panamax API container usage by bytes](https://user-images.githubusercontent.com/8188/44811898-cb157480-aba3-11e8-982b-61a75d0aee4c.png)

*Graph for Panamax API container usage by bytes*

Next, click on the 'Add Graph' button, and paste the following query, and hit 'Execute'. Then click on the 'Graph' tab, to see the visualization of metrics for `memory_usage_bytes` counter for the WP container. The WP container was actually started by Panamax. Here you can see 5 instances of the WP container starting/stopping at different points in time.

```
container_memory_usage_bytes{instance="10.0.0.200:3002",job="panamax",name="WP"}
```
 
![Graph for WP container instances usage by bytes](https://user-images.githubusercontent.com/8188/44811960-fbf5a980-aba3-11e8-95e1-c65a9238989b.png)

*Graph for WP container instances usage by bytes*

**Note**: You can toggle the 'duration' parameter to zoom in/out on the data points across time.

### Status

Click on the 'Status' menu item to see the runtime/build information, configuration, rules, targets and startup flags that are active for the Prometheus server. 

![Status](https://user-images.githubusercontent.com/8188/44812044-395a3700-aba4-11e8-931f-05e26c27adab.png)

*Prometheus Status*

### Alerts and Notifications

We had setup an alert in Prometheus and configured notifications to be sent to Hipchat if Panamax was down. Let's test it out.

### Triggering Alerts

On the Prometheus UI, go to the 'Alerts' menu, and you will see the `pmx_down` alert inactive and green in color. If you click on it, you can see the actual alert condition that we had setup earlier.

![Prometheus Alerts](https://user-images.githubusercontent.com/8188/44812182-91913900-aba4-11e8-8de2-c6c22e762307.png)

*Prometheus Alerts*

To trigger this alert we need to shutdown Panamax. So, lets do that now by doing `panamax pause`. If you click on the 'Alerts' menu, you will see that the alert has now become active, is red in color and the `State` shows as `firing`. 

![Prometheus Alerts firing](https://user-images.githubusercontent.com/8188/44812231-ad94da80-aba4-11e8-9466-7a4ff61c68c2.png)

*Prometheus Alerts firing*

You can also open up the AlertManager at `http://192.168.59.103:9093`, to see the alerts that have been triggered.

![Alert Manager](https://user-images.githubusercontent.com/8188/44812330-f77dc080-aba4-11e8-890e-aedbdf0571a5.png) 

*Alert Manager*

And, view the API endpoint for the AlertManager at `http://192.168.59.103:9093/api/alerts`. 

![AlertManager API call](https://user-images.githubusercontent.com/8188/44812609-b508b380-aba5-11e8-875d-13d899e1b771.png)

*AlertManager API call*

**Note**: The IP address `http://192.168.59.103` is my Docker Host address.

### Getting Notifications

The expectation is to receive a notification on Hipchat and we do so immediately as shown below. The notifications are repeated every 2 hours till Panamax comes back up.

![Alert notifications on Hipchat](https://user-images.githubusercontent.com/8188/44812651-cfdb2800-aba5-11e8-8043-80295b1f3403.png)

*Alert notifications on Hipchat*

When Panamax is back up, the alert is deemed resolved and a new notification to that effect is sent to Hipchat. The alert status is inactive and green in color again.

![Alert notifications on Hipchat](https://user-images.githubusercontent.com/8188/44812697-f6995e80-aba5-11e8-849e-95e6ffbab41d.png)

*Alert notifications on Hipchat*

**Update**:
Based on a few requests, I have created a [docker-compose.yml](https://lorry.io:443/#/?gist=https%3A%2F%2Fgist.githubusercontent.com%2Fanonymous%2Fa317f62c99a626124df0%2Fraw%2F61e789c639fa1a599ab374aa31775b43e7647759%2Fdocker-compose.yml) file in [Lorry.io](http://Lorry.io) for the deployment of the above setup. Note, that the PromDash setup is not included as it needs some manual setup steps.

## Prometheus Dashboard

Prometheus also comes with a graphical dashboard named PromDash. Let's setup PromDash as a container service.

### Creating a local Sqlite3 database

PromDash needs a database to store its data, so let's create a local file based Sqlite3 database for simplicity.

```
$ cd prometheus
$ sqlite3
SQLite version 3.8.5 2014-08-15 22:37:57
Enter ".help" for usage hints.
Connected to a transient in-memory database.
Use ".open FILENAME" to reopen on a persistent database.
sqlite&gt; .open promdash.sqlite3
sqlite&gt; .databases
seq name file
**- **************- **********************************************************
0 main /my/path/prometheus/promdash.sqlite
sqlite&gt; .exit
```

Now, that we have our database created, we need to configure the database with the schema. Since PromDash is a Rails application, we will just run the db migrations.

```
docker run -v $PWD:/tmp/prom \
           -e DATABASE_URL=sqlite3:/tmp/prom/promdash.sqlite3 \
           prom/promdash \
           ./bin/rake db:migrate
```

And, now that the database is all setup, let's run PromDash UI as a container, on port 4000.

```
docker run -d -p 3000:4000 \
              -v $PWD:/tmp/prom \
              -e DATABASE_URL=sqlite3:/tmp/prom/promdash.sqlite3 \
              prom/promdash
```

And, we can see our container running:

```
CONTAINER ID IMAGE             CREATED         PORTS
ee6275f1b625 prom/promdash     22 hours ago    3000/tcp, 0.0.0.0:3000-&gt;4000/tcp
```

We can now head over to `http://192.168.59.103:4000/` to use the PromDash UI.

**Note**: The IP address `http://192.168.59.103` is my Docker Host address. Without getting into details, here is what my PromDash UI looks like:

![PromDash Dahboard](https://user-images.githubusercontent.com/8188/44812817-3eb88100-aba6-11e8-8068-4c4e0737f80c.png)

*PromDash Dahboard*

## Summary

In summary, we looked at running a Prometheus server, configured a metric scraping target, created alerts, enabled notifications to Hipchat, and ran an AlertManager. We then looked at the Prometheus UI and PromDash, to visualize the collected data and performed query operations on them. We triggered alerts and got notifications on Hipchat, by shutting down our monitored application. Prometheus is an excellent monitoring service and alerting toolkit, that could help you better monitor your applications and its containerized services. We have just scratched the surface in this article, but you should find Prometheus able to handle most monitoring scenarios.
