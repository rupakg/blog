---
title: "Practical Guide to AI Assisted Development: Enhancing a Web App With Cursor AI"
description: "A hands-on tutorial that explores using Cursor AI Assistant to enhance a web application iteratively with new features and improvements."
date: 2024-12-17T16:44:43-05:00
lastmod: 2024-12-17T16:44:43-05:00
keywords : [ "AI", "chatbots", "development", "agents", "ai-tools", "code-assistants", "ai-development", "CursorAI"]
tags : [ "AI", "chatbots", "development", "agents", "ai-tools", "code-assistants"]
categories : [ "AI", "Development", "Assistants" ]
layout: post
type:  "post"
---

AI-powered development tools are revolutionizing how developers write and maintain code. In this hands-on tutorial, we'll explore how to use Cursor AI Assistant to enhance a simple Todo list application with new features and improvements. Whether you're new to AI coding assistants or looking to level up your development workflow, this guide will show you practical examples of using Cursor AI for iterative development, debugging, and feature implementation.

We'll take an existing Todo list application and walk through adding new functionality like filtering, improving the UI layout, implementing a color theme, and fixing runtime errors - all with the help of Cursor AI. You'll learn how to effectively prompt Cursor AI, review suggested changes, and validate the results. By the end, you'll have a good understanding of how AI assistants like Cursor AI can accelerate your development process while maintaining code quality.
<!--more-->

![robot as an AI agent](https://plus.unsplash.com/premium_photo-1725985758251-b49c6b581d17?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D)
*[Photo by [Philip Oroni](https://unsplash.com/@philipsfuture) on [Unsplash](https://plus.unsplash.com/premium_photo-1725985758251-b49c6b581d17?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D)]*

## Getting Started

Sign up to [Cursor AI](https://www.cursor.com/), download, and install the app on Mac or Windows.

We will start with the Todo list app that I built in a previous article. The starter app was built using Bolt.new and is a fully functional Todo List app.

> Check out the article: [Exploring AI Assisted Development: Building a Feature Rich Web App With Bolt.new](https://rupakganguly.com/posts/exploring-ai-assisted-development-building-a-feature-rich-web-app-with-bolt/)

Since I ran out of free credits on Bolt.new, I thought it would be a good idea to continue working on the Todo list app using another AI Assistant - **Cursor AI**.

Let’s dive in and create our new features.

To start with I made of copy of the Todo list app built using Bolt.new. Then, I added the new app folder into Cursor. Just to make sure everything is working, I ran the following commands in the terminal:

```bash
npm install
npm run dev
```

Then pointed the browser to `localhost:3000` , and voila - we have the app running. I tested the app by adding a few tasks and categories, and everything seems to work fine. With this baseline we will start enhancing the app. If you want to follow along, please get the source code from the previous article linked above.

## Enhancing  the Todo list app

First let’s explore the feature of Cursor that allows a prompt to edit a file.  

So, to get started I selected a portion of the code and hit [CMD + K] to let Cursor analyze the code and show me a prompt. In the prompt I wrote:

💬 **Prompt**: *Put the Todo List and the “Stay organized and productive” items to the center of the screen. Move Manage Categories to the next line and right align it.*

Cursor suggested the changes and showed a diff of the code as shown below.

![image](https://github.com/user-attachments/assets/2b0f2794-a7fb-4d22-8f5d-eb70356912e9)

The suggested change was made correctly and the preview below shows it in action.

![image](https://github.com/user-attachments/assets/d66d02bc-4e62-4335-adf4-d435b296d6ca)

I clicked “Accept”, to accept the suggested code changes.

🫴🏼 **Takeaway**: I like the intuitive and simple interface to prompt an edit, verify changes and accept them.

## Feature: Change the color of a button

💬 **Prompt**: *Change the Add Category button to the blue color in the theme.*

At first, Cursor suggested to add a `variant=”default”` attribute assuming that it will use the primary blue color.

![image](https://github.com/user-attachments/assets/1c11677d-2b25-4c1b-aa13-f312f90e18b8)

❌ But, that suggested change did not work. So, I told cursor that it did not work. So, a new change was suggested.

![image](https://github.com/user-attachments/assets/ac52b8c0-735b-4e4a-aa0f-d1ad76c4cc6b)

✅ And, this time the suggested change worked!

🫴🏼 **Takeaway**: Cursor will sometimes suggest code changes that will not work, but it can re-analyze the code and make new suggestions. 

## Feature: Add a color theme

I wanted to check if there is a color theme defined, so that the app can have a consistent look. I wanted to explore Cursor’s feature to chat with the code base.

💬 **Prompt**: *Does the code base have a color theme defined?*

Here is what Cursor chat responded with. Pretty easy to understand explanation, reasoning and gives me an action to perform.

![image](https://github.com/user-attachments/assets/6821c374-922f-43bb-af1c-2c5045e297c1)

I dragged the `tailwind.config.ts` and the `globals.css files`, and Cursor gave me a suggestion after analyzing these files.

![image](https://github.com/user-attachments/assets/975c58af-5940-44d6-899c-a57b1353af1b)

✅ I accepted the changes and the app looks good. 

🫴🏼 **Takeaway**: Cursor will ask for files that it can analyze to answer questions about your code. It will then suggest changes to your code.

## Fixing Errors

❌ But, I noticed that when I refresh the “Manage Categories” screen, I get some errors. 

![image](https://github.com/user-attachments/assets/c08e62be-68fa-4224-a9ea-857dd98c7853)

Let’s fix these errors using Cursor’s help.

💬 **Prompt**: I am getting these errors on refreshing the Manage Categories screen.

`Unhandled Runtime Error
Error: Hydration failed because the initial UI does not match what was rendered on the server.
Warning: Expected server HTML to contain a matching <div> in <div>.
See more info here: https://nextjs.org/docs/messages/react-hydration-error`

Cursor gave a reasoning for the error and then suggested a fix outlining the changes that it is suggesting.

![image](https://github.com/user-attachments/assets/51d96f77-7720-47b7-907a-c3060909d887)
![image](https://github.com/user-attachments/assets/94ccac8a-2fd0-46fd-9b15-3573f73110eb)

✅ After I accepted the changes, and the errors went away. 

🫴🏼 **Takeaway**: Code changes and other suggestions may cause runtime errors. Always make sure to test the app with the latest code changes. Cursor can definitely help to analyze and fix those errors.

## Feature: Add filter by category

💬 **Prompt**: *Add a feature to filter by category. Add a dropdown for selecting categories and a label "Category". It should be put next to the existing filters.*

![image](https://github.com/user-attachments/assets/d0201cbe-f873-4bcf-a9c7-463a12b295f3)
![image](https://github.com/user-attachments/assets/c0e39b9d-c5e1-4cf3-ab2b-27d799b3fc9a)

I asked Cursor to suggest the necessary code changes to the parent and other components. I dragged in the parent  `TodoApp.tsx` file for it to analyze.

💬 **Prompt**: *Make the necessary changes.*

![image](https://github.com/user-attachments/assets/ec370806-fba6-4f9b-b208-a0f3136f64c6)
![image](https://github.com/user-attachments/assets/4c5a6c1a-6552-4efd-9bae-4b6d1fee949d)
![image](https://github.com/user-attachments/assets/e7adb347-6f59-4730-a537-b45d62988fa9)

With the new filter for categories implemented, here is how it looks:

![image](https://github.com/user-attachments/assets/4a2f24b3-267e-4adf-bd30-c3d1febaa31d)
![image](https://github.com/user-attachments/assets/f4140770-6aea-47de-b918-2648adff3623)

❌ I quickly realized that there was an issue. After the filtering by category feature was added, the existing todo items that I had added, vanished. 

![image](https://github.com/user-attachments/assets/832ede44-f0d4-4891-a303-e78c66a2c616)

So, asked Cursor to investigate.

💬 **Prompt**: *These changes are making the existing todo items that were added to vanish.*

![image](https://github.com/user-attachments/assets/c2b0cff0-3167-49f1-84c5-38d41639079c)
![image](https://github.com/user-attachments/assets/8249ab7b-7dd3-4a92-a71a-6099b543bd72)

✅ On further testing, the issues were fixed and the existing todo items were not wiped off anymore.

🫴🏼 **Takeaway**: Thoroughly test your app for functional issues and/or regression bugs after code refactoring. Code changes can have unwanted consequences. 

I could have kept going but I think I have demonstrated the power of iterative development for adding features, asking questions about the code, fixing errors and getting suggestions about the code base from Cursor. 

I hope you found it useful. Download Cursor AI and try it out for yourself.

> ℹ️ Check out the [**full source code**](https://github.com/rupakg/cursor-ai-todo-list) for the Todo list app I enhanced using Cursor.

## Conclusion

**Overview**

- The article demonstrates how to use Cursor AI Assistant to enhance a Todo list application with new features and improvements while maintaining code quality
- The project builds upon an existing Todo list app originally created with Bolt.new, now being enhanced with Cursor AI

**Key Features Implemented**

- UI improvements including centered layout and right-aligned category management
- Added color theming capabilities and button styling customization
- Implemented category filtering functionality with dropdown menu integration

**Technical Insights**

- Successfully resolved hydration errors that occurred during page refreshes
- Fixed data persistence issues that initially caused existing todo items to vanish after implementing filters

**Key Takeaways**

- Cursor AI provides an intuitive interface for code editing with real-time verification of changes
- While Cursor may occasionally suggest incorrect solutions, it can effectively reanalyze and provide better alternatives
- Test your app thoroughly for functional issues and/or regression bugs after code refactoring. Code changes can have unwanted consequences.

If you get a chance to try out Cursor AI or if you have questions or feedback, please let me know in the comments below.

