---
title: "How to Programmatically Manage Website Content Using Strapi CMS"
description: "Learn how to create a Strapi CMS app to programmatically create content types, manage content, and consume the content via the Strapi CLI and APIs."
date: 2023-02-26T22:08:42-05:00
lastmod: 2023-02-26T22:08:42-05:00
keywords : [ "strapi", "CMS", "content management system", "headless cms", "api"]
tags : [ "strapi", "CMS", "API"]
categories : [ "CMS" ]
layout: post
type:  "post"
---

In this Part 2 article, we will build upon the Strapi app we built in the Part 1 article [How to create a Strapi CMS app to manage content](/posts/how-to-create-a-strapi-cms-app-to-manage-content/). But, instead of using the Strapi Dashboard Admin UI to manage content, we will take a deep dive into exploring how we can programmatically create content types, manage content, and consume the content via the Strapi CLI and APIs. We will also look at the anatomy of the Strapi app that is created and explore some of the functionalities that it provides out-of-the-box.
<!--more-->

![Use Strapi CMS APIs to programmatically define, create, and manage content](https://user-images.githubusercontent.com/8188/220255147-26bc9aab-b7d9-42ee-bf6c-87b1db2fb346.png)

In the previous [article](/posts/how-to-create-a-strapi-cms-app-to-manage-content/), we created a `strapi-books-api` Strapi app to create and consume an API for books and authors. In this article, we will create a website with some pages to build our `bookshelf` app. This app will demonstrate how we can programmatically use Strapi CMS to manage content for web pages using the Strapi CLI and APIs.

>[What is Strapi headless CMS?](/glossary/what-is-strapi-headless-cms/)

## What we will learn

We will learn the following things as part of this hands-on lab:

- Create the Strapi app
- Review the Strapi app code
- Define content types
- Expose the content via APIs
- Manage and consume the content via APIs

## Pre-requisites

To follow the article and build the app step-by-step, you will need the following:

- **Node.js** installed
	- Only Maintenance and LTS versions are supported (`v14`, `v16`, and `v18`).
	- Node v18.x is recommended for Strapi `v4.3.9` and above
- Node.js package manager
	-  **npm** (`v6` only) or **yarn** (we will use npm in the lab)
- **Python** (needed for using **SQLite** database)
- The `strapi-bookshelf` app project [source code repository](https://github.com/rupakg/strapi-bookshelf)

**Note**: I will be using Node.js `v18.13.0` and Python `2.7.15` (since we will be using an SQLite database)

## Creating the Strapi app

Let's create the Strapi app named `strapi-bookshelf` which will display the books, and let users manage the books.

I. To create the Strapi project, let's run the following command in a terminal window:

```bash
npx create-strapi-app@4.5.6 strapi-bookshelf --quickstart --no-run
```

The above command will ask to install the `create-strapi-app@4.5.6` package. It will create a folder under the current folder by the project name `strapi-bookshelf`.

II. We are passing in the installation type as  `--quickstart`. This will allow Strapi to use SQLite as the default database. You can choose to use the custom option if you want to use any of the other supported databases. We are passing in the flag `--no-run` so that after the project creation, the app is not automatically run.

III. After the above step you should have the `strapi-bookshelf` app  created under `/<your project path>/strapi-bookshelf`

IV. Now that the app is created, let's run the app by running `npm run develop`.

V. The above command starts the app, and opens a browser window to `http://localhost:1337/admin/auth/register-admin` for creating a new admin user via the UI. We can create an admin user using the UI, but instead, let's create the admin user using the command line.

VI. Let's exit the running app by pressing `CTRL+C` on your terminal window. 

VII. To create a new admin user, run the following command in a terminal window:

```bash
npm run strapi admin:create-user -- --firstname=Book --lastname=Admin --email=admin@test.com --password=<password here>
```
**Note**: You can omit the `--password` option, to set the password interactively via the command line.

VIII. The new admin user is created as seen in the following output:

```bash
> teststrapi@0.1.0 strapi
> strapi admin:create-user --firstname=Book --lastname=Admin --email=admin@test.com --password=<password here>

Successfully created new admin
```
**Note:** This is a local user and is **required** to manage content in the Strapi Dashboard UI.

IX. Let's start the app again by `npm run develop`. You will notice that the output suggests going to url `http://localhost:1337/admin` to open the admin panel.

X. The browser now takes us to the login page for the Strapi Admin site. Use the email and password we used to create the admin user to login.

XI. Now, you are in Strapi's Dashboard Admin UI. The dashboard site can be used for all admin purposes.

This marks the completion of the Strapi app creation process. If you want, you can `CTRL+C` on your terminal window to exit the running Strapi app. We will start the app again in the next section.

>To get in-depth details of using the Strapi Dashboard Admin UI to manage content, please check out my article on [How to create a Strapi CMS app to manage content](/posts/how-to-create-a-strapi-cms-app-to-manage-content/).

## Reviewing the Strapi app code

### Review the project structure 

Let's examine what we got by creating a Strapi app. 

We have a new folder `strapi-bookshelf` created with the following folder structure:

```bash
cd strapi-bookshelf
tree -L 3 -I node_modules

.
├── README.md
├── config
│   ├── admin.js
│   ├── api.js
│   ├── database.js
│   ├── middlewares.js
│   └── server.js
├── database
│   └── migrations
├── favicon.png
├── package-lock.json
├── package.json
├── public
│   ├── robots.txt
│   └── uploads
└── src
    ├── admin
    │   ├── app.example.js
    │   └── webpack.config.example.js
    ├── api
    ├── extensions
    └── index.js
```

### Review the project files

Let's examine each of the sub-folders and their content and details.

1. The `config` folder holds a bunch of JS files that define configurations for different parts of the Strapi app. 
	- The `admin.js` file reads the `env` data and exports the `auth token` and the `apiToken salt`. 
	- The `api.js` file defines some configuration parameters for the REST API.
	- The `database.js` file reads the `env` data and defines the configuration details for the SQLite database.
	- The `middleware.js` file has the configuration details for the Strapi middleware that are included by default.
	- The `server.js` file has the configuration details for the Strapi server.
2. The `database` folder is empty to start with but has an empty folder `migrations` to hold any database migration files. Migrations are a way to incrementally update the database schema with versioning. It allows the developer to upgrade to a new version or downgrade to an older version of the schema. 
3. The `public` folder is empty to start with but will contain any publicly accessible static files or media assets. It has an empty folder `uploads` to hold any uploaded asset files like images or documents. These asset files are shown in the Admin UI under the Media Library and can be used in the app.
4. The `src` folder is where all the source code for the app is stored. All auto-generated code is stored here under separate folders namely, `admin`, `api`, and `extensions`.
	- The `admin` folder holds some example files to customize and configure the admin part of the Strapi app.
	- The `api` folder holds the business logic of the project split into subfolders per API that are defined by the app. We will review the API code structure in the next section after we define the content types.
	- The `extensions` folder holds files to files to extend any installed plugins.
	- The `index.js` file at the root of the project exports two functions: `register` and `bootstrap`.
		- The `register` function is an asynchronous register function that runs before the application is initialized. This gives the developer an opportunity to extend the code.
		- The `bootstrap` function is an asynchronous bootstrap function that runs before the application gets started. This gives the developer an opportunity to set up the data model, run jobs, or perform some special logic.

Now that we understand the basic project structure of a Strapi app, let's dive into working on the demo app, starting with defining the content types.

## Defining content types

Strapi allows us to define content types for different kinds of content you might have. The content types are categorized into two main categories: *Collection* and *Single* types.

Collection types define the kinds of content that can be visualized as a list i.e. a collection of things. Single types define kinds of content that can hold a single data structure.

Let's define the content types for our demo app that will have some web pages. We need a home page for general information about the app, and a bookshelf page to display the various bookshelves with books.

We will take a programmatic approach in this article, to create the content types in Strapi using the Strapi CLI.

If you stopped the app in the previous section, let's start the app by:

```bash
npm run develop
```

### Creating a "Homepage" single content type

The home page is a single structure of content so we will define a `single` content type named `Homepage`. The single content type `Homepage` will have these attributes: `header`, `hero_image`, `sub_header`, `content`, and `footer`.

To create the `Homepage` single content type, let's run:

```bash
npm run strapi generate
```

The output we get is as follows:

```bash
> strapi-bookshelf@0.1.0 strapi
> strapi generate

? Strapi Generators content-type - Generate a content type for an API
? Content type display name Homepage
? Content type singular name homepage
? Content type plural name homepages
? Please choose the model type Single Type
? Use draft and publish? Yes
? Do you want to add attributes? Yes
? Name of attribute header
? What type of attribute string
? Do you want to add another attribute? Yes
? Name of attribute sub_header
? What type of attribute string
? Do you want to add another attribute? Yes
? Name of attribute hero_image
? What type of attribute media
? Choose media type Single
? Name of attribute content
? What type of attribute richtext
? Do you want to add another attribute? Yes
? Name of attribute footer
? What type of attribute string
? Do you want to add another attribute? No
? Where do you want to add this model? Add model to new API
? Name of the new API? homepage
? Bootstrap API related files? Yes
✔  ++ /api/homepage/content-types/homepage/schema.json
✔  +- /api/homepage/content-types/homepage/schema.json
✔  ++ /api/homepage/controllers/homepage.js
✔  ++ /api/homepage/services/homepage.js
✔  ++ /api/homepage/routes/homepage.js
```

Now that the `Homepage` single content type is created, let's go back to the Strapi Dashboard Admin UI site and verify that it was created as we needed.

![The Homepage single content type with all its attributes](https://user-images.githubusercontent.com/8188/218310728-f183fa1b-342a-4fd2-bb18-88c507f27e5d.png)
*The `Homepage` single content type with all its attributes*

### Creating a "Bookshelf" collection content type

The bookshelf page will display a list of shelves which in turn will have a list of books.  So we will define a `collection` content type named `Bookshelf`. The collection content type `Bookshelf` will have these attributes: `name`, and `description`.

To create the `Bookshelf` collection content type, let's run:

```bash
npm run strapi generate
```

The output we get is as follows:

```bash
> strapi-bookshelf@0.1.0 strapi
> strapi generate

? Strapi Generators content-type - Generate a content type for an API
? Content type display name Bookshelf
? Content type singular name bookshelf
? Content type plural name bookshelves
? Please choose the model type Collection Type
? Use draft and publish? Yes
? Do you want to add attributes? Yes
? Name of attribute name
? What type of attribute string
? Do you want to add another attribute? Yes
? Name of attribute description
? What type of attribute richtext
? Do you want to add another attribute? No
? Where do you want to add this model? Add model to new API
? Name of the new API? bookshelf
? Bootstrap API related files? Yes
✔  ++ /api/bookshelf/content-types/bookshelf/schema.json
✔  +- /api/bookshelf/content-types/bookshelf/schema.json
✔  ++ /api/bookshelf/controllers/bookshelf.js
✔  ++ /api/bookshelf/services/bookshelf.js
✔  ++ /api/bookshelf/routes/bookshelf.js
```

Now that the `Bookshelf` collection content type is created, let's go back to the Strapi Dashboard Admin UI site and verify that it was created as we needed.

![The Bookshelf collection content type with all its attributes](https://user-images.githubusercontent.com/8188/218311163-d5ec7a06-1957-4e99-9126-99721698c038.png)
*The `Bookshelf` collection content type with all its attributes*

### Review auto-generated code

Now that we created the `Homepage` and `Bookshelf` content types, let's review the code that Strapi CLI generated automatically for us.

```bash
cd strapi-bookshelf
tree -L 4 src/api

src/api
├── bookshelf
│   ├── content-types
│   │   └── bookshelf
│   │       └── schema.json
│   ├── controllers
│   │   └── bookshelf.js
│   ├── routes
│   │   └── bookshelf.js
│   └── services
│       └── bookshelf.js
└── homepage
    ├── content-types
    │   └── homepage
    │       └── schema.json
    ├── controllers
    │   └── homepage.js
    ├── routes
    │   └── homepage.js
    └── services
        └── homepage.js
```

At this time, we will focus our attention on the `schema.json` file created under the folder `src/api/bookshelf/content-types/bookshelf` and `src/api/homepage/content-types/homepage`.

Let's open the `src/api/bookshelf/content-types/bookshelf/schema.json` file in any code editor and have a look:

```json
// src/api/bookshelf/content-types/bookshelf/schema.json

{
	"kind": "collectionType",
	"collectionName": "bookshelves",
	"info": {
		"singularName": "bookshelf",
		"pluralName": "bookshelves",
		"displayName": "Bookshelf"
	},
	"options": {
		"draftAndPublish": true,
		"comment": ""
	},
	"attributes": {
		"name": {
			"type": "string"
		},
		"description": {
			"type": "richtext"
		}
	}
}
```

You will notice that the above json structure describes the information that we supplied via the Strapi CLIs `generate` command. 

Let's enrich the content type by updating it with some `required` & `unique` constraints, and a `relation` type.

### Update content type schema

At this time, Strapi CLI's `generate` command **does not allow** creating `relation` type attributes and setting advanced settings of `required` and `unique`. 

Let's edit and update the `schema.json` files for both `Homepage` and `Bookshelf` content types to add:
- `required` and `unique` constraints
- `relation` type (`Homepage` has a `one-to-many` relation to `Bookshelf`)

The edited `bookshelf/schema.json` file looks like this:

```json
// Edited src/api/bookshelf/content-types/bookshelf/schema.json

{
	"kind": "collectionType",
	"collectionName": "bookshelves",
	"info": {
		"singularName": "bookshelf",
		"pluralName": "bookshelves",
		"displayName": "Bookshelf"
	},
	"options": {
		"draftAndPublish": true,
		"comment": ""
	},
	"attributes": {
		"name": {
			"type": "string",
			"required": true,   // <=== added
			"unique": true      // <=== added
		},
		"description": {
			"type": "richtext"
		}
	}
}
```

The edited `homepage/schema.json` file looks like this:

```json
// Edited src/api/homepage/content-types/homepage/schema.json

{

	"kind": "singleType",
	"collectionName": "homepages",
	"info": {
		"singularName": "homepage",
		"pluralName": "homepages",
		"displayName": "Homepage"
	},
	"options": {
		"draftAndPublish": true,
		"comment": ""
	},
	"attributes": {
		"header": {
			"type": "string",
			"required": true    // <=== added
		},
		"sub_header": {
			"type": "string"
		},
		"hero_image": {
			"type": "media",
			"allowedTypes": [
				"images",
				"files",
				"videos",
				"audios"
			],
			"multiple": false
		},
		"content": {
			"type": "richtext",
			"required": true    // <=== added
		},
		"footer": {
			"type": "string",
			"required": true    // <=== added
		},
		"bookshelves": {        // <=== added
			"type": "relation",
			"relation": "oneToMany",
			"target": "api::bookshelf.bookshelf"
		}
	}
}
```

Now that the `Bookshelf` and `Homepage` content types are updated, let's go back to the Strapi Dashboard Admin UI site and verify that it was updated as we needed.

>To get in-depth details of using the Strapi Dashboard Admin UI to manage content, please check out my article on [How to create a Strapi CMS app to manage content](/posts/how-to-create-a-strapi-cms-app-to-manage-content/).

That concludes the part of updating the content types. Now, let's see how we can create data for the content types we defined via the APIs Strapi created for us automatically.

## Exposing the content via APIs

Before we can expose the content, we need to set the roles & permissions for the content, so that we can publicly access the content via the APIs.

We want to add content for the homepage and bookshelves. To create and consume the content data via the APIs, we need to make sure that the content is publicly accessible through the API. 

We will allow **authenticated** access to `create`, `update`, and `delete` APIs. We will allow **public** access to `find` and `findOne` APIs.

**Note**: At this time, Strapi CLI **does not allow** setting roles and permissions programmatically. We will have to use the Strapi Dashboard Admin UI to set roles and permissions for our content types.

### Setting roles and permissions for the content

Follow the steps below to give selected permissions to the **Authenticated** role:

1. Click on **General** -> **Settings** at the bottom of the main navigation.
2. Under the **Users & Permissions Plugin**, choose **Roles**.
3. Click the **Authenticated** role.
4. Scroll down under **Permissions**.
5. In the **Permissions** tab, find **Bookshelf** and click on it.
6. Check the **create**, **delete**, and **update** checkboxes.
7. In the **Permissions** tab, find **Homepage** and click on it.
8. Check the **delete** and **update** checkboxes.
9. Click **Save**.

![Setting roles and permissions for the Authenticated role for the Bookshelf content type](https://user-images.githubusercontent.com/8188/218317300-24618c94-a5a0-4a3a-a0e0-5205293fc0ba.png)
*Setting roles and permissions for the Authenticated role for the Bookshelf content type*

Follow the steps below to give selected permissions to the **Public** role:

1. Click on **General** -> **Settings** at the bottom of the main navigation.
2. Under the **Users & Permissions Plugin**, choose **Roles**.
3. Click the **Public** role.
4. Scroll down under **Permissions**.
5. In the **Permissions** tab, find **Bookshelf** and click on it.
6. Check the **find** and **findOne** checkboxes.
7. In the **Permissions** tab, find **Homepage** and click on it.
8. Check the **find** checkbox.
9. Click **Save**.

![image](https://user-images.githubusercontent.com/8188/218317871-6024ca57-5a58-47a2-b00d-840c259623ef.png)
*Setting roles and permissions for the Public role for the Bookshelf content type*

### Create users with roles

Strapi allows different roles for different access control for users to access content data. It allows a **Public** role for public access and an **Authenticated** role for authenticated access. 

Let's create two users: Bob and Alice. Bob will have a Public role and Alice will have an Authenticated role. 

Start the app in a terminal window by `npm run develop`. To create the two new registered users, we will make a `curl` calls from a new terminal window.

Let's create a new registered user Bob:

```bash
curl -X POST 'http://localhost:1337/api/auth/local/register' \
--header 'Content-Type: application/json' \
-d '{
    "username": "bob",
    "email": "bob@test.com",
    "password": "Bob@public"
}'
```

The response to the above call:

```json
{
    "jwt": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9....pvTuY",
    "user": {
        "id": 1,
        "username": "bob",
        "email": "bob@test.com",
        "provider": "local",
        "confirmed": true,
        "blocked": false,
        "createdAt": "2023-02-12T15:41:59.403Z",
        "updatedAt": "2023-02-12T15:41:59.403Z"
    }
}
```

**Note**: By default, the `register` API creates a user with an Authenticated role. To update the role to a Public role, we will have to use the Strapi Dashboard Admin UI by following steps below:

1. Go to **Content Manager** -> **Collection Types** -> **User**.
2. Click on the user `bob`.
3. Notice that under **role**, the role is defaulted to **Authenticated**.
4. Under the **role**, click on the **Add relation** dropdown and select **Public**. The **Authenticated** role is removed.
5. Click **Save**.

Similarly, let's create a new registered user for Alice:

```bash
curl -X POST 'http://localhost:1337/api/auth/local/register' \
--header 'Content-Type: application/json' \
-d '{
    "username": "alice",
    "email": "alice@test.com",
    "password": "Alice@auth"
}'
```

The response to the above call:

```json
{
    "jwt": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9....0fyyw",
    "user": {
        "id": 2,
        "username": "alice",
        "email": "alice@test.com",
        "provider": "local",
        "confirmed": true,
        "blocked": false,
        "createdAt": "2023-02-12T15:58:51.670Z",
        "updatedAt": "2023-02-12T15:58:51.670Z"
    }
}
```

You can verify that the two users got created by going to the Strapi Dashboard Admin UI.

![Registered users Bob and Alice created](https://user-images.githubusercontent.com/8188/218321951-bedc49e3-4c36-402d-b8a7-2b6ab37b3ac8.png)
*Registered users Bob and Alice created*

>To get in-depth details of using the Strapi Dashboard Admin UI to manage content, please check out my article on [How to create a Strapi CMS app to manage content](/posts/how-to-create-a-strapi-cms-app-to-manage-content/).

## Managing and consuming the content via APIs

We will add content for the homepage and bookshelves via the APIs that Strapi automatically created for us. See Strapi's [REST API Endpoints](https://docs.strapi.io/developer-docs/latest/developer-resources/database-apis-reference/rest-api.html#endpoints) documentation for details.

We will look at the authenticated APIs i.e. `create`, `update`, and `delete` APIs, and then the public API i.e. `get` API. See Strapi's [Manage Role Permissions](https://docs.strapi.io/developer-docs/latest/plugins/users-permissions.html#manage-role-permissions) documentation to understand how to make authenticated API calls.

### Authentication

Before we make any authenticated API calls, we need to `login` by passing the `identifier` (can be username or email) and the `password` of a registered user with Authenticated access. This operation has to be done once till the authentication session expires. The `login` call will return a JWT Token which we will be using in our subsequent autheticated calls.

Start the app in a terminal window by `npm run develop`. To login, we will make a `curl` call from a new terminal window.

In our case, let's use user Alice to login since this user has an Authenticated role.

```bash
curl -X POST http://localhost:1337/api/auth/local \
--header 'Content-Type: application/json' \
-d '{
    "identifier":"alice@test.com", 
    "password":"Alice@auth"
}'
```

The response to the above call is successful:

```json
{
    "jwt": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9....pursc",
    "user": {
        "id": 2,
        "username": "alice",
        "email": "alice@test.com",
        "provider": "local",
        "confirmed": true,
        "blocked": false,
        "createdAt": "2023-02-12T15:58:51.670Z",
        "updatedAt": "2023-02-12T15:58:51.670Z"
    }
}
```

From the above response, we need the `jwt` token to be passed in the `Authorization` header for the subsequent API calls as a `Bearer` token. Any authentication failures return a `401 (unauthorized)` error.

### Creating content entry for "Homepage"

Start the app in a terminal window by `npm run develop`. To create a new Homepage entry, we will make a `curl` call from a new terminal window.

Let's try to create the Homepage entry **without** passing in the authentication token.

```bash
curl -X PUT http://localhost:1337/api/homepage \
--header 'Content-Type: application/json' \
-d '{
	"data": {
	    "header": "My Bookcase",
	    "sub_header": "Books are your best friends...",
	    "content": "Fill this area with bookshelves with books.",
	    "footer": "Copyright (c) 2023 Rupak Ganguly"
	}
}'
```

We get a `403 Forbidden` error as a response to the above call. That tells us that we cannot access the creation call publicly and it needs authentication.

```json
{
	"data": null,
	"error": {
		"status": 403,
		"name": "ForbiddenError",
		"message": "Forbidden",
		"details": {}
	}
}
```

Now, let's create the Homepage entry by passing in the authentication token.

```bash
curl -X PUT http://localhost:1337/api/homepage \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer <your_jwt_token_here>' \
-d '{
	"data": {
	    "header": "My Bookcase",
	    "sub_header": "Books are your best friends...",
	    "content": "Fill this area with bookshelves with books.",
	    "footer": "Copyright (c) 2023 Rupak Ganguly"
	}
}'
```

The response from the above call is successful:

```json
{
	"data": {
		"id": 1,
		"attributes": {
			"header": "My Bookcase",
			"sub_header": "Books are your best friends...",
			"content": "Fill this area with bookshelves with books.",
			"footer": "Copyright (c) 2023 Rupak Ganguly",
			"createdAt": "2023-02-12T17:42:49.321Z",
			"updatedAt": "2023-02-12T17:42:49.321Z",
			"publishedAt": "2023-02-12T17:42:49.239Z"
		}
	},
	"meta": {}
}
```

### Consuming content for "Homepage"

Let's make a `curl` call to see if we can retrieve the Homepage content that we just created. Since we allowed retrieval calls (find and findOne) to be publicly accessible, we should not require an authenticated call.

```
curl -X GET http://localhost:1337/api/homepage
```

We get a successful response which is identical to the response from create call we made earlier. It also means that the roles we set are working properly.

### Creating content entries for "Bookshelf"

Similar to Homepage, let's create a couple of bookshelf entries.

```bash
curl -X POST http://localhost:1337/api/bookshelves \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer <your_jwt_token_here>' \
-d '{
	"data": {
	    "name": "Business Books",
	    "description": "A collection of business books."
	}
}'

curl -X POST http://localhost:1337/api/bookshelves \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer <your_jwt_token_here>' \
-d '{
	"data": {
	    "name": "Technical Books",
	    "description": "A collection of technical books."
	}
}'
```

### Consuming content for "Bookshelf"

Let's make a `curl` call to see if we can retrieve the Bookshelf content that we just created. Since we allowed retrieval calls (find and findOne) to be publicly accessible, we should not require an authenticated call.

```
curl -X GET http://localhost:1337/api/bookshelves
```

The successfull response for the above call:

```json
{
	"data": [{
		"id": 1,
		"attributes": {
			"name": "Business Books",
			"description": "A collection of business books.",
			"createdAt": "2023-02-12T18:05:31.168Z",
			"updatedAt": "2023-02-12T18:05:31.168Z",
			"publishedAt": "2023-02-12T18:05:31.160Z"
		}
	}, {
		"id": 2,
		"attributes": {
			"name": "Technical Books",
			"description": "A collection of technical books.",
			"createdAt": "2023-02-12T18:06:04.937Z",
			"updatedAt": "2023-02-12T18:06:04.937Z",
			"publishedAt": "2023-02-12T18:06:04.934Z"
		}
	}],
	"meta": {
		"pagination": {
			"page": 1,
			"pageSize": 25,
			"pageCount": 1,
			"total": 2
		}
	}
}
```

### Updating relations

Last but not the least, we need to associate the Homepage with the two bookshelves that we created. To do that we will make an update call to the Homepage entry and pass it the `relation` data for bookshelves. See Strapi's [Managing relations through the REST API](https://docs.strapi.io/developer-docs/latest/developer-resources/database-apis-reference/rest/relations.html#managing-relations-through-the-rest-api) documentation for details.

```bash
curl -X PUT http://localhost:1337/api/homepage \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer <your_jwt_token_here>' \
-d '{
  "data": {
    "bookshelves": { 
      "connect": [
        { "id": 1 },
        { "id": 2 }
      ], 
    }
  }
}'
```

**Note**: **This above call does not work. Or at least I could not get it to work**. 

For that reason, I used the Strapi Dashboard Admin UI to associate the bookshelves to the homepage.

![Associating the bookshelves to the homepage](https://user-images.githubusercontent.com/8188/218335612-11dda036-0d4e-4306-8199-26a9dd54870c.png)
*Associating the bookshelves to the homepage*

### Consuming data including relations

Let's verify that the relations have been set properly:

```bash
curl -X GET http://localhost:1337/api/homepage?populate=*
```

The response was successful and you will notice that the single call to the homepage retrieves the associated bookshelves data as well:

```json
{
  "data": {
    "id": 1,
    "attributes": {
      "header": "My Bookcase",
      // ... clipped for brevity
      },
      "bookshelves": {
        "data": [{
          "id": 1,
          "attributes": {
            "name": "Business Books",
            // ... clipped for brevity
          }
        }, {
          "id": 2,
          "attributes": {
            "name": "Technical Books",
            // ... clipped for brevity
          }
        }]
      }
    }
  },
  "meta": {}
}
```

Similar to the creation and retrieval calls, we can also make delete calls. This concludes the section for managing content for the content types that we defined.

>To get in-depth details of using the Strapi Dashboard Admin UI to manage content, please check out my article on [How to create a Strapi CMS app to manage content](/posts/how-to-create-a-strapi-cms-app-to-manage-content/)

That concludes the article looking at Strapi CMS for programmatically creating content types, managing content, and consuming the content via the Strapi CLI and APIs. You can follow along with the article and review the [source code repository](https://github.com/rupakg/strapi-bookshelf) for the `strapi-bookshelf` app project we created in this article.

## Summary

To recap, we learned how to create a new Strapi app bookshelf using the Strapi CLI. We created a new admin user to manage content types using the Strapi CLI. We then explored the anatomy of the Strapi app we created by reviewing the project structure, files, and auto-generated code. We then learned how to programmatically generate a single and a collection of content types using the Strapi CLI. We also learned how to update the content schema to add other extra constraints and relations. We learned how to limit access controls for exposing authenticated and public operations by setting roles and permissions. Next, we learned how to create a couple of end users with authenticated and public roles to consume the content. We also learned how to create, update and query content with relations programmatically using the APIs.


If you have questions or feedback, please let me know in the comments below.

