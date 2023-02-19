---
title: "How to create a Strapi CMS app to manage content"
description: "Learn how to create a Strapi-powered app to manage content using the Strapi CMS and consume the content via APIs."
date: 2023-02-19T14:29:05-05:00
lastmod: 2023-02-19T14:29:05-05:00
keywords : [ "strapi", "CMS", "content management system", "headless cms", "api"]
tags : [ "strapi", "CMS", "API"]
categories : [ "CMS" ]
layout: post
type:  "post"
---

In this article, we will create a Strapi-powered app, to manage content using the Strapi CMS. To manage the content, we will use the Strapi Dashboard Admin UI to create the content types, create content data, set roles and permissions, and then expose the content via automatically generated APIs. Finally, we will access the APIs to retrieve the content data. 
<!--more-->

![Use Strapi CMS to define, create, and manage content](https://user-images.githubusercontent.com/8188/219970375-fe82faf0-6706-4e2a-9df0-d85e53bd776e.png)

## What we will learn

We will learn to do the following things as part of this hands-on lab:

- Create the Strapi app
- Create content types
- Manage content and relations
- Set roles and permissions for the content
- Publish the content
- Access the content

>[What is Strapi headless CMS?](/glossary/what-is-strapi-headless-cms/)

## Pre-requisites

To follow the article and build the app step-by-step, you will need the following:

- **Node.js** installed
	- Only Maintenance and LTS versions are supported (`v14`, `v16`, and `v18`).
	- Node v18.x is recommended for Strapi `v4.3.9` and above
- Node.js package manager
	-  **npm** (`v6` only) or **yarn** (we will use npm in the lab)
- **Python** (needed for using **SQLite** database)
- The `strapi-books-api` app project [source code repository](https://github.com/rupakg/strapi-books-api)

**Note**: I am using Node.js `v18.13.0` and Python `2.7.15` (since we will be using an SQLite database)

## Creating the Strapi app

Let's create the Strapi app named `strapi-books-api` that will manage the content for a list of books with their authors, and then expose the data via APIs.

1. To create the Strapi project, let's run the following command in a terminal window:

```bash
npx create-strapi-app@4.5.6 strapi-books-api
```

where,
- `create-strapi-app` is the Strapi package
- `@4.5.6` indicates the version of the Strapi package being used
- `strapi-books-api` is the name of the Strapi project

The above command will ask to install the `create-strapi-app@4.5.6` package. It will also create a folder under the current folder by the project name `strapi-books-api`.

2. Choose the installation type as: `Quickstart (recommended)`. This will allow Strapi to use SQLite as the default database. You can choose to use the `Custom (manual settings)` option if you want to use any of the other supported databases.
3. Here is what the output will look like:

```bash
Need to install the following packages:
  create-strapi-app@4.5.6
Ok to proceed? (y) y
? Choose your installation type Quickstart (recommended)
Creating a quickstart project.
Creating a new Strapi application at /<your project path>/strapi-books-api.
Creating files.
⠇ Installing dependencies: ...
Dependencies installed successfully.

Your application was created at /<your project path>/strapi-books-api.
```

4. At the end of the Strapi app creation process, a set of documentation pointers are generated and displayed on the terminal:

```bash
Available commands in your project:

  npm run develop
  Start Strapi in watch mode. (Changes in Strapi project files will trigger a server restart)

  npm run start
  Start Strapi without watch mode.

  npm run build
  Build Strapi admin panel.

  npm run strapi
  Display all available commands.

You can start by doing:

  cd /<your project path>/strapi-books-api
  npm run develop

Running your Strapi application.

> strapi-books-api@0.1.0 develop
> strapi develop

Building your admin UI with development configuration...
Admin UI built successfully
[2023-01-25 08:17:45.397] info: The Users & Permissions plugin automatically generated a jwt secret and stored it in .env under the name JWT_SECRET.

 Project information

┌────────────────────┬──────────────────────────────────────────────────┐
│ Time               │ Wed Jan 25 2023 08:17:46 GMT-0500 (Eastern Stan… │
│ Launched in        │ 3911 ms                                          │
│ Environment        │ development                                      │
│ Process PID        │ 24703                                            │
│ Version            │ 4.5.6 (node v18.13.0)                            │
│ Edition            │ Community                                        │
└────────────────────┴──────────────────────────────────────────────────┘

 Actions available

One more thing...
Create your first administrator 💻 by going to the administration panel at:

┌─────────────────────────────┐
│ http://localhost:1337/admin │
└─────────────────────────────┘
```

**Note**: For the curious reader, please note the fact that a `jwt` secret was automatically created. `The Users & Permissions plugin automatically generated a jwt secret and stored it in .env under the name JWT_SECRET.`

5. The above creation process automatically triggers running the app, and opens a browser window to `http://localhost:1337/admin/auth/register-admin` for creating a new admin user. Fill in the info. on the screen to create an admin user. 
**Note:** This is a local user and is **required** to manage content in the Strapi Dashboard UI.

![The Welcome to Strapi screen for creating a new admin user](https://user-images.githubusercontent.com/8188/214574738-362f66e0-209c-418a-810b-cc2573e8ab87.png)
*The Welcome to Strapi screen for creating a new admin user*

Once you have completed the form and submitted it, the admin user will be created and you will be redirected to the `http://localhost:1337/admin/` page, which is the Strapi Dashboard UI. We will dig deep into it in the next section. 

6. This marks the completion of the Strapi app creation process. If you want you can `CTRL+C` on your terminal window to exit the running Strapi app. We will start the app again in the next section.

**Note**: If you have different `node` versions installed and use `nvm` to manage them, I suggest you create a `.nvmrc` file at the root of the project. The `.nvmrc` file just contains the version of node e.g. `v18.13.0` in my case. Then, every time you switch to the project folder, run `nvm use <version>` to automatically switch to the `node` version in your `.nvmrc` file.

## Creating content types

Strapi allows us to define content types for different kinds of content you might have. The content types are categorized into two main categories: *Collection* and *Single* types.

Collection types define the kinds of content that can be visualized as a list i.e. a collection of things. Single types define kinds of content that can hold a single data structure.

Let's define the content types for our demo app that will have books and authors. We need a  collection of books so we will define a `collection` content type named `Book`. We also need a  collection of authors so we will define a `collection` content type named `Author`. 

The collection content type `Book` will have these attributes: `name`, `description`, `cover_pic`, `format`, `isbn`, `published_year`, and `buy_url`. 

The collection content type `Author` will have these attributes: `name`, and `bio`.

The `Author` type will have a `Relation` field of type "many-to-many" with `Book`, so we can have multiple authors associated with a book.

Let's jump in and create the above content types using the Strapi Dashboard Admin UI.

### Create a "Book" collection type

We will create a `Book` collection type. Then we will define the attributes to display when adding a new book entry:

1. Go to **Content-type Builder** in the main navigation.
2. Click on **Create new collection type**.
3. Enter `Book` for the _Display name_
4. Click **Continue**.

![Create a collection type screen](https://user-images.githubusercontent.com/8188/215478766-fad54326-a684-4507-8814-cc9877a3c73b.png)
*Create a collection type screen*

4. Click the Text field.

![Select a field for the collection type screen](https://user-images.githubusercontent.com/8188/215478970-c1e671b6-741f-4d6f-8f22-79aee97de678.png)
*Select a field for the collection type screen*

5. Enter `name` in the _Name_ field.

![The Basic settings tab of the Add a new Text field screen](https://user-images.githubusercontent.com/8188/215479705-a5f20d1b-0bc0-4910-83ea-640f3e685e5c.png)
*The Basic settings tab of the Add a new Text field screen*

6. Switch to the _Advanced Settings_ tab, and check the **Required field** and the **Unique field** settings.

![The Advanced Settings tab of the Add a new Text field screen](https://user-images.githubusercontent.com/8188/215479869-e4ad435e-7a4e-4a04-9034-911d0fd11d9b.png)
*The Advanced Settings tab of the Add a new Text field screen*

7. Click on **Add another field**.
8. Choose the Rich text field.
9. Type `description` under the _Name_ field.
10. Repeat, to add the other fields as necessary and click **Finish**.
11. Click **Save** and wait for Strapi to restart.

After adding all the fields for `Book`, the type definition looks like this:

![The Book collection content type with all its attributes](https://user-images.githubusercontent.com/8188/215484106-cf8f6c1a-6a5c-4ffd-8722-df0127fb862a.png)
*The Book collection content type with all its attributes*

### Create an "Author" collection type

We will create an `Author` collection type. Every book has authors, so we will use this type to assign author(s) to a book.

Let's create an `Author` collection type:

1. Go to **Content-type Builder** in the main navigation.
2. Click on **Create new collection type**.
3. Type `Author` for the _Display name_, and click **Continue**.
4. Click the Text field.
5. Type `name` in the _Name_ field.
6. Switch to the _Advanced Settings_ tab, and check the **Required field** and the **Unique field** settings.
7. Click on **Add another field**.
8. Choose the Rich text field.
9. Type `bio` under the _Name_ field.
9. Click on **Add another field**.
10. Choose the Relation field.
11. On the right side, click the _Author_ relational fields box and select "Book".
12. In the center, select the icon that represents "many-to-many". The text should read `Authors has and belongs to many Books`.

![The Relation field for creating a "many-to-many" relationship between books and authors](https://user-images.githubusercontent.com/8188/215486545-4194021c-3227-49f4-be5c-048328366639.png)
*The `Relation` field for creating a "many-to-many" relationship between books and authors*

13. Click **Save** and wait for Strapi to restart.

The Author type definition looks like this:

![The Author collection type with all its attributes](https://user-images.githubusercontent.com/8188/215487158-203d54bc-4aa8-4c45-8b3c-b6748e9b86c2.png)
*The Author collection type with all its attributes*

### Configuring the View

After we have defined the content types, Strapi allows configuring the view to manage the content. You can choose to move the layout of the fields around as you would like it to be displayed to the user managing the content data. 

Let's see what the `Author` type looks like:

1. Go to **Content-type Builder** in the main navigation.
2. Click on the `Author` type from the secondary navigation.
3. Click on the **Configure the view** button on the top-right.
4. You can move the fields around as you wish to show them while managing the content.

![Configuring the view for the Author content type](https://user-images.githubusercontent.com/8188/215489989-a37f4f9f-61fe-4906-a596-ee974964ab77.png)
*Configuring the view for the `Author` content type*

You can similarly, configure the view for the `Book` content type as well.

That concludes the part of creating the content types. Now, let's see how we can create data for the content types we defined.

## Managing content

Now that we have defined the content types for `Book` and `Author`, let's add some content entries.

### Creating content entries for "Book"

For adding a Book entry, follow the steps below:

1. Go to **Content Manager** -> **Collection types** -> **Book** in the navigation.
2. Click on **Add new entry**.
3. Fill in the fields with data.
4. Click **Save**.

![*Content added for a book*](https://user-images.githubusercontent.com/8188/218114915-a12fed37-310a-4ccc-a492-db84916a297c.png)
*Content added for a book*

### Creating content entries for "Author"

For adding an Author entry, follow the steps below:

1. Go to **Content Manager** -> **Collection types** -> **Author** in the navigation.
2. Click on **Add new entry**.
3. Fill in the fields with data.
4. Click **Save**.

![Content added for authors](https://user-images.githubusercontent.com/8188/218115236-c0dfa409-af08-4772-8d96-5b2d277e26fe.png)
*Content added for authors*

### Adding relations for "Author(s)" to a "Book"

We will now add the authors that are related to a book, using the Relation type that we had defined earlier. 

Follow the steps below:

1. Go to **Content Manager** -> **Collection types** -> **Book** in the navigation, and click on the first book listed.
2. In the right sidebar, in the **Authors** drop-down list, select an **Author**. 
3. Click **Save**.

## Setting roles and permissions

We added some books and authors. To consume the content data via the API, we need to make sure that the content is publicly accessible through the API. We will only allow the `find` (get all books) and `fineOne` (get one book) APIs for now.

Follow the steps below to give selected permissions to the Public role:

1.  Click on **General** -> **Settings** at the bottom of the main navigation.
2.  Under the **Users & Permissions Plugin**, choose **Roles**.
3.  Click the **Public** role.
4.  Scroll down under **Permissions**.
5.  In the **Permissions** tab, find **Book** and click on it.
6.  Click the checkboxes next to **find** and **findone**.
7.  Repeat for **Author**: click the checkboxes next to **find** and **findone**.
8.  Click **Save**.

After performing the above steps, the screen will look like this:

![Setting roles and permissions for Book and Author content types](https://user-images.githubusercontent.com/8188/215494306-ff619d3f-02ed-423b-bf92-b8ae7b5f58cd.png)
*Setting roles and permissions for Book and Author content types*

## Publishing the content

To be able to access the content data publicly, we need to publish the content. By default, Strapi keeps all the content data as drafts. This allows content creators to review the content before publishing.

To publish the content, follow the steps below:

1. Go to **Content Manager** -> **Collection types** -> **Book** in the navigation.
2. Click on the book that you want to publish.
3. Click **Publish** button on the top-right corner.

![Draft of the book content, ready to be published](https://user-images.githubusercontent.com/8188/218116094-e6293227-74c8-43ea-b3ee-f3286eab0da5.png)
*Draft of the book content, ready to be published*

Once the book is published, the status of the book will show as **Published**.

![The status of the book changed to Published](https://user-images.githubusercontent.com/8188/218116532-e2d3d26b-bd3c-443a-a2c7-d446eda7f915.png)
*The status of the book changed to Published*

**Note**: Since the `Book` type has a relation to `Author` type, we need to make sure that we go and publish the authors related to the book we published as well.

That concludes the part of creating the data for the content types we defined. Now, let's see how we can access the data.

## Accessing the content

Strapi automatically creates API routes and exposes the content via APIs. Let's look at retrieving the content using the APIs that Strapi created for us.

The general format of the API url is as follows:

```
http://localhost:1337/api/{content_type_plural}
```

### Get Books

Point your browser to this url: `http://localhost:1337/api/books` and you will see the books you have added as shown below:

```json
{"data": 
   [{
	   "id": 1,
	   "attributes": {
	     "name": "Will",
	     "description": "Will Smith’s transformation from a West Philadelphia kid to one of the biggest rap stars of his era, and then one of the biggest...",
	     "format": "Hardcover",
	     "isbn": "0593152301",
	     "published_year": "2022-01-11",
	     "buy_url": "[https://amzn.to/3XeaTzt](https://amzn.to/3XeaTzt)",
	     "createdAt": "2023-02-10T14:19:36.054Z",
	     "updatedAt": "2023-02-10T14:28:12.687Z",
	     "publishedAt": "2023-02-10T14:28:12.675Z"
	   }
    }],
	"meta": {
	  "pagination": {"page": 1,"pageSize": 25,"pageCount": 1,"total": 1}
	}
}
```
**Note**: I have chopped the `description` field for brevity.

### Get Authors

Point your browser to this url: `http://localhost:1337/api/authors` and you will see the authors you have added as shown below:

```json
{"data": 
   [{
	   "id": 1,
	   "attributes": {
	     "name": "Will Smith",
	     "bio": null,
	     "createdAt": "2023-02-10T14:20:12.583Z",
	     "updatedAt": "2023-02-10T14:28:30.556Z",
	     "publishedAt": "2023-02-10T14:28:30.551Z"
	   }
   },
   {
	   "id": 2,
	   "attributes": {
	     "name": "Mark Manson",
	     "bio": null,
	     "createdAt": "2023-02-10T14:20:43.131Z",
	     "updatedAt": "2023-02-10T14:28:19.116Z",
	     "publishedAt": "2023-02-10T14:28:19.109Z"
	   }
   }],
   "meta": {
	   "pagination": {"page": 1,"pageSize": 25,"pageCount": 1,"total": 2}
   }
}
```

### Get Books with Authors

Point your browser to this url: `http://localhost:1337/api/books?populate=*` and you will see the books along with the author data you have added as shown below:

```json
{
  "data": [{
    "id": 1,
    "attributes": {
      "name": "Will",
      "description": "Will Smith’s transformation from a West Philadelphia kid to one of the biggest rap stars of his era...",
      "format": "Hardcover",
      "isbn": "0593152301",
      "published_year": "2022-01-11",
      "buy_url": "https://amzn.to/3XeaTzt",
      // ... clipped for brevity
      "cover_pic": {
        "data": {
          "id": 1,
          "attributes": {
            "name": "will_cover.jpeg",
            // ... clipped for brevity
          }
        }
      },
      "authors": {
        "data": [{
            "id": 1,
            "attributes": {
              "name": "Will Smith",
              "bio": null,
              // ... clipped for brevity
            }
          },
          {
            "id": 2,
            "attributes": {
              "name": "Mark Manson",
              "bio": null,
			        // ... clipped for brevity
            }
          }
        ]
      }
    }
  }],
  "meta": {
    "pagination": {
      "page": 1,
      "pageSize": 25,
      "pageCount": 1,
      "total": 1
    }
  }
}
```

That concludes the article looking at Strapi CMS for managing content and accessing the content via the APIs. You can follow along with the article and review the [source code repository](https://github.com/rupakg/strapi-books-api) for the `strapi-books-api` app project we created in this article.

## Summary

To recap, we explored creating a `strapi-books-api` app using the Strapi CMS. We learned how to create some content types `Book` and `Author` and create data for that content, all using the Strapi Dashboard Admin UI. We then learned how to manage the content and set roles & permissions for the content so that we could publish & access the content publicly via the APIs. Last but not the least, we learned how to use the APIs generated automatically by Strapi CMS to retrieve the content that we created.


If you have questions or feedback, please let me know in the comments below.

