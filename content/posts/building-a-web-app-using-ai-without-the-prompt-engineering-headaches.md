---
title: "Building a web app using AI without the prompt engineering headaches"
description: "Step-by-step process to build a fully AI-generated landing page web app with Cloving AI."
date: 2024-11-16T15:12:52-05:00
lastmod: 2024-11-16T15:12:52-05:00
keywords: ["AI", "Chatbots", "Cloving.ai"]
tags: ["AI", "Chatbots", "Development", "Cloving.ai"]
categories: ["AI", "Development"]
layout: post
type: "post"
---

With the advent of AI chatbots, many have been using it to write code and develop apps. But, in reality (at least in my experience), it has been a huge disappointment. The technology is great but works well in the hands of people who know how to use it. A lot has been talked about ‘prompt engineering’ which is at the core of making these AI chatbots respond in a more productive way.

I have tried creating apps using these AI chatbots but it is a pain. It is a nerve wreaking back and forth prompt writing in chat, and copy/paste in the code base. And, the code never works as expected. It is tough to progressively build on your app using the chatbots because the chatbots are unaware of your full code base.

<!--more-->

![robots with laptops](https://images.unsplash.com/photo-1684369175809-f9642140a1bd?q=80&w=1542&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D)
_[Photo by [Mohamed Nohassi](https://unsplash.com/@coopery) on [Unsplash](https://unsplash.com/photos/a-group-of-white-robots-sitting-on-top-of-laptops-2iUrK025cec)]_

*Introducing Cloving.ai...*

My friend Lucas Carlson, took up the challenge and created [Cloving.ai](http://Cloving.ai) 👏🏼 and I was so excited to beta test it. I was blown away by the simplicity of it’s usage and the rich output it produced. Beautifully designed interactive CLI. And, the code worked and ran as expected. And, the possibilities are limitless… I want to share the same excitement with you.

> See my article on [Comparing Chat GPT, Gemini, Copilot and Claude AI Chatbots](https://rupakganguly.com/posts/comparing-chatgpt-gemini-copilot-and-claude-ai-chatbots/)

### 🍀 Overview of Cloving.ai

[Cloving.ai](http://Cloving.ai) is a **cutting-edge, open-source command line tool that seamlessly integrates AI into the developer workflow, enhancing productivity and code quality**.

It’s features include:

- AI Generated Code: generate working code for new or old code base
- AI Generated Code Reviews: generate code reviews for instant feedback
- AI Generated Unit Tests: generate units tests for your code
- AI Generated Commit Messages: replace git commit with cloving commit to generate context-aware commit messages

Let’s first look at the setup, configuration and some pre-requisites. Then, we will jump in and build an app from scratch.

## ⚙️ Setup and Configuration

### Pre-requisites

- Node.js (version 20 or higher)
- Git
- API access to AI chat models (e.g., OpenAI GPT-4, Claude, Ollama, etc.)

### Installation

👉🏼 Run the following command to install the latest version of the Cloving CLI:

```bash
> npm install -g cloving@latest
> cloving -V # v0.3.16
```

### Configuration

👉🏼 Run the command below, to configure Cloving CLI:

```bash
> cloving config
```

For more details, see the [Cloving documentation](https://cloving.ai/docs).

## 🚧 Building the web app

We will be building a simple landing page Next.js web application, with a nav bar, hero section, and a footer.

### Create the boilerplate web app

👉🏼 Run this command to create a boilerplate app project:

```bash
> cloving generate shell --prompt "Create a Next.js app called ai-landing-page"
```

And, you get an interactive session with Cloving, that creates the boilerplate Next.js app project for you.

```bash
? Do you want to review the ~153 token prompt before sending it to
https://api.anthropic.com/v1/messages? no
npx create-next-app ai-landing-page

? What would you like to do? Execute
Need to install the following packages:
create-next-app@14.2.15
Ok to proceed? (y) y

✔ Would you like to use TypeScript? … No / Yes Yes
✔ Would you like to use ESLint? … No / Yes Yes
✔ Would you like to use Tailwind CSS? … No / Yes Yes
✔ Would you like to use `src/` directory? … No / Yes Yes
✔ Would you like to use App Router? (recommended) … No / Yes Yes
✔ Would you like to customize the default import alias (@/*)? … No / Yes Yes

Creating a new Next.js app in <your path>/ai-landing-page.

Using npm.

Initializing project with template: app-tw

Installing dependencies:

- react
- react-dom
- next

Installing devDependencies:

- typescript
- @types/node
- @types/react
- @types/react-dom
- postcss
- tailwindcss
- eslint
- eslint-config-next

added 361 packages, and audited 362 packages in 12s

Initialized a git repository.

Success! Created landing-page at <your path>/ai-landing-page
```

After taking your inputs into consideration, Cloving will generate a boilerplate project structure, and even initialize a git repository.

### Initialize the web app project

👉🏼 Run the next command inside the app project folder, to let Cloving analyze the app project structure and build a configuration file for use later.

```bash
> cd <your path>/ai-landing-page
> cloving init
```

Cloving will send the AI model a request to summarize the technologies used in this project. This will provide better context for future Cloving requests. As output, Cloving will create a `cloving.json` file in the root of the project folder.

```bash
Cloving will analyze the list of files and the contents of the following files:

 - package.json
 - tsconfig.json
 - .eslintrc.json

Cloving will send AI a request to summarize the technologies used in this project.

This will provide better context for future Cloving requests.

? Do you want to review the ~1,114 token prompt before sending it to
https://api.anthropic.com/v1/messages? no

Project data saved to cloving.json
? Do you want to review the generated data? no
```

### Autogenerate commit messages

Cloving has a cool feature of auto generating commit messages based on your latest changes. Let’s give it a shot.

👉🏼 Run the following command to generate a commit message for the latest changes.

```ruby
> git add cloving.json
> cloving commit
```

As usual the commit message will open up in your default editor. It is amazing to see the details of the commit message that it produces.

```bash
Add cloving.json configuration file

- Define TypeScript and JavaScript as primary languages
- Specify Next.js and React as main frameworks
- Include ESLint as the linter
- Set npm as the package manager
- Configure project as a web application
```

### Create the landing page web app

👉🏼 Let’s run the `generate code` command and give it a descriptive prompt which describes the landing page that we want to create. Here is the prompt that I thought of:

*Build me a responsive landing web app with tailwind styled with a blue theme. It should have a navigation bar with a placeholder for a logo on the left. The nav bar should have a Features, Pricing, and About menu items. The main area should have a hero section with a placeholder for a hero image and a hero text. Below that it should have 3 placeholder sections in a horizontal layout. Below that it should have a footer with a copyright message.*

👉🏼 Let's pass the above prompt to Cloving:

```bash
> cloving generate code --prompt "Build me a responsive landing web app with tailwind styled with a blue theme. It should have a navigation bar with a placeholder for a logo on the left. The nav bar should have a Features, Pricing, and About menu items. The main area should have a hero section with a placeholder for a hero image and a hero text. Below that it should have 3 placeholder sections in a horizontal layout. Below that it should have a footer with a copyright message."
```

And, here is the interactive output from Cloving:

```bash
? Enter the relative path of a file or directory you would like to include as context (or press enter to continue):

Building AI prompt context...

📁 Loaded context from: app
   ✅ Added 3 file(s) to context
   📊 Total tokens in context: 1,296

? Do you want to review the ~3,578 token prompt before sending it to
https://api.anthropic.com/v1/messages? no

Certainly! I'll create a responsive landing web app with a blue theme using Tailwind CSS, based on the Next.js project structure you've provided. I'll modify the existing files and create new ones as needed. Let's start by updating the necessary files.

First, let's update the `globals.css` file to include our blue theme colors:

<...code snippet removed for brevity...>

Now, let's update the `layout.tsx` file to use the Geist font throughout the app:

<...code snippet removed for brevity...>

Now, let's update the `page.tsx` file with our new landing page content:

<...code snippet removed for brevity...>

These changes will create a responsive landing page with a blue theme, including a navigation bar, hero section, feature sections, and a footer. The layout uses Tailwind CSS classes for styling and responsiveness.

To complete the setup, you may want to add a favicon and adjust the metadata in the `layout.tsx` file. You can also replace the placeholder logo and hero image with actual images when they're available.

Is there anything else you'd like me to modify or add to this landing page?? What would you like to do? (Use arrow keys)
  Revise
  Explain
  Save a Source Code File
❯ Save All Source Code Files
  Copy Source Code to Clipboard
  Copy Entire Response to Clipboard
  Done
```

🪄 ✨This is INCREDIBLE or what !!! ✨

It not only creates the code for you, it also suggests other modifications. Then at the end it gives an interactive prompt to do several other things. For now, let’s pick the `Save All Source Code Files` option. We will explore the other options later.

### Run the landing page web app

👉🏼 Let’s run these commands to run our landing page web app:

```bash
> npm install
> npm run dev
```

```bash
  ▲ Next.js 14.2.15
  - Local:        http://localhost:3000

 ✓ Starting...
 ✓ Ready in 2.1s
```

**Get ready to be blown away by what was created by Cloving AI using a simple prompt**.

Have a look! Open up a browser window and point it to `http://localhost:3000`.

![Landing page built by Cloving.AI](https://github.com/user-attachments/assets/b075ce41-b480-45f5-b7d9-9ec4b962f331)
_[Landing page built by Cloving.AI]_

Let’s autogenerate a commit message, by running `cloving commit`:

```bash
Implement blue theme landing page with responsive design

- Add color variables for primary, secondary, and background colors
- Update dark mode color scheme
- Remove unused font and simplify body class
- Update metadata with new title and description
- Replace default Next.js content with custom landing page layout
- Add navigation, hero section, feature sections, and footer
```

🤯 I will leave you with your jaw dropped and drooling, and imagining all the cool apps you can build with Cloving. This is just the tip of the iceberg of what we can do with Cloving.

Oh, and you might be thinking how much did it all cost in AI API fees - **it is less than a $1** !!!

🧑🏼‍💻 **Source Code**: https://github.com/rupakg/ai-landing-page

In my next series of posts, I will showcase the other features of Cloving, like the built-in chat module, code reviews and generating unit tests.

Let me know what cool things you build with Cloving, and leave a comment to share with others.

## 📋 Summary

**Introduction to Cloving AI**

- Cloving AI is an open-source command line tool that integrates AI into the developer workflow, enhancing productivity and code quality⁠⁠
- It offers features like AI-generated code, code reviews, unit tests, and commit messages⁠⁠

**Building a Landing Page with Cloving AI**

- The process involves creating a boilerplate Next.js app, initializing the project, and using Cloving to generate code⁠⁠
- A simple prompt to Cloving AI generated a responsive landing page with a navigation bar, hero section, and a footer⁠⁠
- The generated landing page includes Tailwind CSS styling with a blue theme⁠⁠

**Key Advantages of Cloving AI**

- Cloving AI simplifies the development process and produces working code, addressing the limitations of traditional AI chatbots⁠⁠
- It can auto-generate detailed commit messages based on recent changes⁠⁠
- The cost of using Cloving AI for this project was less than $1 in AI API fees⁠**⁠**

If you have questions or feedback, please let me know in the comments below.
