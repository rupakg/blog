---
title: "Exploring AI Assisted Development: Building a Feature Rich Web App With Bolt.new"
description: "Generate a feature rich web application from scratch and iteratively add complex features through simple prompts using Bolt.new AI assistant."
date: 2024-12-10T15:00:30-05:00
lastmod: 2024-12-10T15:00:30-05:00
keywords : [ "ai-development", "chatbots", "coding-assistant", "agents", "Bolt.new", "ai-tools" ]
tags : [ "AI", "chatbots", "ai-development", "agents", "Bolt.new", "ai-tools" ]
categories : [ "AI", "Development", "Assistants" ]
layout: post
type:  "post"
---

In the rapidly evolving landscape of software development, AI-powered coding assistants are emerging as powerful tools for accelerating application development. This article explores the capabilities of Bolt.new, an AI coding assistant by StackBlitz, through the practical exercise of building a dynamic Todo List application using Next.js and nothing else but prompts.

The demonstration showcases how Bolt.new can not only generate a basic application from scratch but also iteratively add complex features through simple prompts. We'll examine the assistant's ability to handle various development tasks, from implementing UI components to managing data structures, while also highlighting both its strengths and limitations.

Throughout this hands-on exploration, we'll see how Bolt.new handles different challenges, including error resolution and code refactoring, providing valuable insights into the current state of AI-assisted development and its practical applications in real-world scenarios.
<!--more-->

![a robot flying through the air surrounded by gears](https://plus.unsplash.com/premium_photo-1677094310899-02303289cadf?q=80&w=1632&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D)
*[Photo Credit: [Mariia Shalabaieva](https://unsplash.com/@maria_shalabaieva) at [Unsplash](https://unsplash.com/photos/a-robot-flying-through-the-air-surrounded-by-gears-C4KspT2KypI)]*

## Getting Started

It was fairly easy to sign up on [Bolt.new](http://bolt.new) as a new user via Github. It dropped me into a page with two panels. An area on the left to provide prompts, while the code editor, managed by StackBlitz, sat on the right. The interface is very intuitive & simple to use and needed no documentation to get started. 

Let’s dive in and build a dynamic Todo list app.

## Build the Todo list app

💬 **Prompt**: *Build a todo list app with Next.js and Bootstrap with a primary light blue and secondary purple color theme.*

Bolt went to work and started creating the Next.js Todo application. It was pretty cool to see that it showed its “work” as steps on the left panel while it displayed the code being generated on the right panel. Pretty amazing. 

The interface is pretty slick, and it presents a full code editor with a live preview. A terminal window at the bottom is “watching” the files as they are being changed for the live preview.

![Build a todo list app with Next.js and Bootstrap](https://github.com/user-attachments/assets/882ad7f4-b45f-4a31-8fc3-69847c1c2119)

✨ And, in about a minute, it created the base version of the Todo list application with theme colors that I specified. It complied and ran the app with a live preview. The app is fully functional at this point.

![Base version of the Todo list application](https://github.com/user-attachments/assets/00987a97-559c-4f57-b8b6-a446222b2772)

Let’s go beyond a bit further and iteratively add some features.

## Feature: Add start and end dates to item

💬 **Prompt**: *Add a start date and an end date to a todo item.*

❌ Bolt refactored the code and tried to add the feature but encountered issues.

![Add a start date and an end date to a todo item](https://github.com/user-attachments/assets/b0c485ca-5d48-48db-8a3d-4bba4af99f41)

❌ Bolt encountered errors, then analyzed the error and proposed a fix. But, the fix did not work and it posed new errors while refactoring code. 

✅ Bolt tried one more round to fix the issues, and got it right this time. Pretty cool.

>💡**Note**: Shows the capabilities of Bolt to acknowledge issues/errors by running code live and parsing the errors. And, then understanding the issue and proposing a fix. 

✅ And, now we have a the todo items with a start and end dates.

![Add a start date and an end date to a todo item](https://github.com/user-attachments/assets/36679070-9685-4e95-8967-8742939f1271)

Let’s add another feature to add editing capabilities to a todo item.

## Feature: Editing an existing item

💬 **Prompt**: *Add feature to edit an existing todo item.*

✅ Bolt refactored the code and added the feature without any errors. It added a pencil icon next to the todo item which when pressed allows the item to be edited.

![Add feature to edit an existing todo item](https://github.com/user-attachments/assets/41d9732c-5e11-4fcf-94a2-fe69e42544f3)

Let’s add some categories and then add the capability to assign the category to a todo item.

## Feature: Add category management and assign category to item

💬 **Prompt**: *Add a feature to assign categories like Personal, Work etc. to a todo item. Create a separate screen to add, edit and delete categories.*

❌ First attempt, had some errors, which Bolt analyzed and proposed to fix.

❌ Even with multiple attempts, Bolt could not fix the following error. It went into a loop showing the same errors and not able to fix the errors.

```
Error: A <Select.Item /> must have a value prop that is not an empty string. This is because the Select value can be set to an empty string to clear the selection and show the placeholder.
```

👨🏼‍💻Intervention from an engineer who knew the code was required in this case. The fix was pretty simple, and I manually fixed the code. 

Updated the following lines from:

```
<Select value={value || ''} onValueChange={(val) => onChange(val || null)}>
...
...
<SelectItem value="">No category</SelectItem>
```
to
```
<Select value={value || ''} onValueChange={(val) => onChange(val === "unassigned" ? null : val)}>
...
...
<SelectItem value="unassigned">No category</SelectItem>
```

The above changes fixed the code and we have a working app again. 🎇

![Todo List app created using Bolt.new](https://github.com/user-attachments/assets/4688a4fc-6cdc-47ff-b1d3-55a2fa0e0c09)

😢 Unfortunately, at this point I had used all my remaining tokens so I could not proceed further. 

🎉 But, overall, I had a blast building with Bolt.new. As you can see that in about 5 mins, I had a fully functioning app ready to go, built by just supplying some simple prompts. That is really cool and very powerful.

## What’s Next?

As much fun I had building the app, I was wondering what could I do next. Then I saw that Bolt.new allows you to download the code and also lets you continue to work on the code in the StackBlitz cloud code workspace. If I had to keep using Bolt.new I could subscribe to the Pro version starting at $20/month. 

> ℹ️ Check out the [**full source code**](https://github.com/rupakg/bolt-ai-todo-list) generated by Bolt.new for the Todo list app we built in this article.

## Conclusion

Bolt.new is an excellent full stack AI code assistant that can not only create an app from scratch but help to add features interactively. It successfully added features like start/end dates and item editing capabilities through iterative prompts. 

As far as technical challenges are concerned, Bolt.new encountered and fixed some errors independently, demonstrating its ability to analyze and debug code. It required an engineer's manual intervention for a specific component error that Bolt couldn't resolve. We need to be on a watch out for issues created while refactoring code. 

👉🏼 So, it is important to understand that AI tools are most effective when used by engineers familiar with the domain knowledge, and who can maintain the AI-generated codebase. While non-engineers who can’t code will struggle after a certain point. 

🛑 AI tools are not replacing engineers any time soon!!!

> ❔***What are you going to build today?***

If you build something with Bolt.new, or if you have questions or feedback, please let me know in the comments below.


