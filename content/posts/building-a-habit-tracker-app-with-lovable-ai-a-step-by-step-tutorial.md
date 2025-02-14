---
title: "Building a Habit Tracker App With Lovable Ai a Step by Step Tutorial"
description: "Step-by-step tutorial for building a modern habit-tracking application built with Lovable AI code assistant. A deep-dive and walk through the development process, from initial setup to implementing advanced features, while addressing various technical challenges and improvements along the way."
date: 2025-02-14T13:53:04-05:00
lastmod: 2025-02-14T13:53:04-05:00
keywords : [ "AI", "ai-development", "coding-assistant", "Lovable", "ai-tools", "Node.js", "Tailwind", "Vite", "React", "Typescript"]
tags : [ "AI", "ai-development", "Lovable", "ai-tools"]
categories : [ "AI", "Development", "Assistants" ]
layout: post
type:  "post"
---

In this article, we'll explore the development of a modern habit-tracking application built with Node.js. Using **Lovable**, a powerful **AI code assistant** platform, we'll create a feature-rich application that combines intuitive design with practical functionality.

The application showcases essential features like customizable activity scheduling, streak tracking, and a visual calendar interface. We'll walk through the development process, from initial setup to implementing advanced features, while addressing various technical challenges and improvements along the way. We will explore the technical aspects of building an application with Lovable AI coding assistant and provide valuable insights into the development process and the final product.

Through this journey, we'll see how we used Lovable AI to combine thoughtful design, user-friendly features, and robust technical implementation to create a modern habit-tracking app.
<!--more-->

![A lovable robot reaching out to a butterfly](https://plus.unsplash.com/premium_photo-1682308256034-dda4b204f4d2?q=80&w=1601&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D)
*[Photo by [Getty Images](https://unsplash.com/@gettyimages) at [Unsplash](https://unsplash.com/photos/surreal-artwork-of-life-freedom-technology-science-and-hope-concept-idea-robot-with-red-butterfly-imagination-painting-futuristic-art-3d-illustration-ARDnPmA1JzY)]*

> ❤️ **Happy Valentine's Day to all** ❤️

## Getting Started

Getting started was very easy. Just signed up on Lovable and authenticated with Github OAuth.

## Building the app

Let’s jump in and start creating the app in Lovable. The opening page is a welcome page with a simple area to just start entering your prompt to build an app. Clean and simple.

![Lovable AI](https://github.com/user-attachments/assets/0d234e80-28d1-4810-84a3-25b50495a4fc)

**💬 Prompt:** Create a Node.js app to track health and fitness activities. The main goal of the app is to form healthy habits by doing them regularly. The app will allow creation of activities and allow the user to specify a schedule, for e.g. daily, weekly, etc. by providing a calendar interface. The app will track streaks for each activity. 

**💭 Lovable Response:**

I'll help you create a beautiful and functional health and fitness habit tracker! Let's draw inspiration from popular habit tracking apps like Strides and Habitify, while focusing on a clean, motivating design that encourages users to maintain their healthy habits.

For the design, let's use:

- A calming color palette with a primary teal/mint color (#14B8A6) for success and progress indicators
- Soft grays for the background and cards
- Smooth animations for interactions
- Clean, modern typography using the Inter font family
- Subtle gradients for visual interest
- Progress circles and streak counters for motivation

Features for this first version:

1. Activity management (create, edit, delete health activities)
2. Calendar interface for scheduling and tracking
3. Streak tracking with visual indicators
4. Daily view of activities
5. Basic statistics for each habit

Created a beautiful health habit tracker with activity cards, streak tracking, and a clean interface. Users can add new activities, mark them as complete, and track their progress with streaks.

> Note: I love the suggestions. It shows the planning part of the model.

✅ Let’s see the preview and see what it created. The first draft is a beautiful and functional app. 

![First draft of the habit-tracker app](https://github.com/user-attachments/assets/66a4f978-5aa8-4aa9-be92-8e9c0b7c29ea)

### 🫴🏼 **Takeaways**

- Out of the gate, Lovable described a plan with design suggestions for the app
- Built an app with a clean and intuitive UI
- Created a Github repo with the code
- Allows opening and editing the project directly on Github
- Provides desktop and mobile previews
- Publish the app easily
- Uses technologies such as React, Typescript, Vite, shadcn-ui and Tailwind CSS

## Running the app

Let’s give it a twirl, and add some activities.

![Add a new activity to the habit-tracker app](https://github.com/user-attachments/assets/8701eee7-f751-404a-a1c8-3e7f10052842)

✅ And, here is the app with some activities added.

![Habit-tracker app with some activities added](https://github.com/user-attachments/assets/2823dcc6-71cd-4b9f-8748-8c4026fa2382)

Let’s look at the code. Lovable also creates checkpoints with the capability to restore.

![Lovable checkpoints](https://github.com/user-attachments/assets/38165605-954c-4b98-ac68-f9c2b7209d3a)

### 🫴🏼 **Takeaways**

- The app was functional and had the features built-in that I asked for in the initial prompt
- I like the fact that I can set a knowledge, context or custom instructions for every edit in the project
- Supabase integration for backend
- Code can be viewed in Raw or Diff formats
- Creates checkpoints with the capability to restore

## Feature: Updating the schedule

**💬 Prompt:** In the new activity popup, let users pick a day of the week if they choose a "Weekly", "Weekdays" or "Weekends" schedule.

**💭 Lovable Response:**

I'll modify the NewActivityDialog component to add a day picker that appears when the user selects a weekly, weekdays, or weekends schedule.

Added a day picker that appears when users select weekly, weekdays, or weekends schedules, showing only relevant days for each schedule type.

![Updating the schedule for activities](https://github.com/user-attachments/assets/26a46792-90ea-4a10-b39d-9120eca2c29e)

**💬 Prompt:** If a day of the week is picked for a schedule, display that day of the week on the activity card after the activity is added.

**💭 Lovable Response:**

I'll update the ActivityCard component to display the selected day of the week when it's available.

The activity card now shows the day of the week alongside the schedule when available (e.g., "weekly on Monday" or "weekends on Saturday").

![Show selected day on the activity card](https://github.com/user-attachments/assets/9dba6d33-1460-464f-b9cc-f7f135bd7f26)

**💬 Prompt:** In case of "Weekdays" or "Weekends" schedule, allow selection of multiple days of the week.

**💭 Lovable Response:**

I'll modify the NewActivityDialog component to allow multiple day selection for "Weekdays" and "Weekends" schedules using checkboxes instead of radio buttons.

Updated the NewActivityDialog to use checkboxes for multiple day selection in "Weekdays" and "Weekends" schedules, while keeping radio buttons for "Weekly" schedule. Days are now joined with commas when displayed in the ActivityCard.

Note: The `NewActivityDialog.tsx` file is getting quite long (160+ lines). Consider asking me to refactor it into smaller components after you're satisfied with the functionality.

> **Note**: Lovable makes sensible suggestions to streamline code

![Allow selection of multiple days](https://github.com/user-attachments/assets/312f8cd7-2033-4ae8-9225-dc6157ef0918)

✅ Multiple day of the week selection enabled for Weekdays and Weekends.

![Multiple day of the week selection enabled](https://github.com/user-attachments/assets/0dfe685b-636c-449e-bd3d-1dba55f59fb8)

✅ On completion of the activity, the streak counter was updated.

**💬 Prompt:** Use a colored circle for each new activity. Create a panel on the right that display a calendar view with activities marked with the same colored circle as the activity completed on that day. Allow users to navigate the calendar view to view different months.

**💭 Lovable Response:**

I'll help you create a calendar view with colored activity markers. We'll need to modify the existing components and create a new calendar component.

Added a calendar view with colored activity markers, allowing users to navigate between months and see their completed activities marked with corresponding colored dots. The calendar is displayed in a panel on the right side of the screen.

![Add a calendar view](https://github.com/user-attachments/assets/d999c5d1-79c1-40ec-a497-fd4507b1eb69)

**Free Credits and Pricing**

Well, I ran out of credits for the day. But, I think that was pretty generous daily limit.

### Code commits

I love the fact that the code commits are automatically pushed to Github.

![Code commits are automatically pushed to Github](https://github.com/user-attachments/assets/67f18121-736a-47df-a396-601904ef6576)

### 🫴🏼 **Takeaways**

**I really love Lovable**. As you can see the app was created exactly as I instructed, without any major bugs or issues.

Continuing on the next day.

### Bug Fix: Issue with the calendar view

**💬 Prompt:** There is a bug where the calendar view does not refresh to show the correct dates for the month, when the month is changed at the top navigator section.

**💭 Lovable Response**:

Let me check the issue with the calendar view not refreshing correctly when navigating between months.

Fixed the calendar navigation by adding a month prop to the Calendar component and implementing a proper month change handler function.

✅ The issue was promptly fixed in one attempt, without any regressions.

![Calendar view bug fixed](https://github.com/user-attachments/assets/8f3e6d11-d05a-46fb-9922-6fe5e1276bc5)

## Feature: Adding a checkmark for completed activities

**💬 Prompt:** Add a translucent check mark on the date an activity is completed. Make the checkmark icon with 50% opacity.

**💭 Lovable Response:**

I'll add a translucent checkmark icon from lucide-react to show completed activities in the calendar view.

Added a translucent checkmark icon that appears in the top-right corner of calendar dates where activities were completed.

Let me update the opacity of the checkmark icon in the ActivityCalendar component.

Updated the checkmark icon's opacity from 20% to 50% by changing the opacity class from opacity-20 to opacity-50.

![Adding a checkmark for completed activities](https://github.com/user-attachments/assets/80445897-765d-496e-82aa-abbe706e0bdc)

## Chore: Creating a Dockerfile

**💬 Prompt:** Create a Dockerfile for the app so that the application can be run in a container. Update the documentation in the readme file to include instructions to run the app with Docker.

**💭 Lovable Response:**

I'll help create a Dockerfile for containerizing the application and update the README with Docker instructions.

Added a Dockerfile to containerize the application and updated the README with Docker build and run instructions.

A Dockerfile was created and the [README.md](http://README.md) file was updated as instructed.

## Feature: Editing an activity

**💬 Prompt:** Add the capability to edit an activity.

**💭 Lovable Response:**

I'll implement the edit functionality for activities by updating the NewActivityDialog component to handle both creation and editing modes.

Added the ability to edit activities by modifying the NewActivityDialog component to handle both creation and editing modes, updating the ActivityCard to use the dialog for editing, and implementing the edit functionality in the Index page.

### Bug Fix: Issue with editing

❌ I tested editing the activity by changing the icon color and the scheduled days. But, it seems there is a bug. You can see below that I selected Saturday but the display still shows Saturday and Sunday.

![Bug with editing activity](https://github.com/user-attachments/assets/7010b24f-9741-453f-aba7-24dcb6de2a22)

![Bug with editing activity](https://github.com/user-attachments/assets/4c00488b-a42f-4768-8689-acaf41ad76e4)

Let’s ask Lovable to fix it.

**💬 Prompt:** The edit functionality is not working. I changed the Activity Name, the icon color and the Select Days and upon saving the activity, none of those changes were reflected. Fix the issue.

**💭 Lovable Response:**

I'll fix the edit functionality by properly handling the updated activity data in the Index component.

Fixed the edit functionality by properly updating all activity properties (name, schedule, day, and color) when saving edited activities. The changes will now be reflected in the UI immediately after editing.

### Build Error: Build was unsuccessful

❌ When Lovable tried to build the code it was unsuccessful.

![Build error](https://github.com/user-attachments/assets/b2771045-b210-4333-ba83-1be724ac4a7c)

So, it tried to analyze and fix the error.

**💭 Lovable Response:**

Let me analyze the error and fix it step by step.

1. The error occurs because there's a type mismatch in the onEdit prop:
    - The ActivityCard component expects onEdit to be a function that takes a string parameter (id)
    - But we're passing handleSaveActivity which expects an activity data object
2. Looking at the ActivityCard component, we need to align the types between what NewActivityDialog provides and what ActivityCard expects.

I've updated the onEdit prop type in ActivityCard to match the activity data structure that NewActivityDialog provides when saving. This resolves the type mismatch error while maintaining the existing functionality.

✅ The issue was promptly fixed. The edits to the color icon, activity name and the selected days for the schedule was reflected correctly.

![Activity editing bugs fixed](https://github.com/user-attachments/assets/bba9ffdf-0313-4b26-9dd5-dde8c36d9566)

## Feature: Updating calendar positioning

**💬 Prompt:** Update the layout so that the calendar is fixed on the top right side of the screen, and the activities are on the left in a two-column grid. 

**💭 Lovable Response:**

I'll update the layout to have a fixed calendar on the top right and arrange activities in a two-column grid on the left.

The layout has been updated to show the calendar fixed on the right side and activities in a responsive two-column grid on the left, with proper spacing and mobile responsiveness.

**💬 Prompt:** I want the activities to span two-columns and the calendar to span one column. The calendar should be on the right. 

**💭 Lovable Response:**

Looking at the current code, I'll adjust the grid layout to achieve the requested column spans.

The layout now uses a 3-column grid where activities span 2 columns and the calendar takes up 1 column on the right, with the calendar remaining sticky while scrolling.

**💬 Prompt:** Make the minimum width of the calendar to 320px

**💭 Lovable Response:**

I'll update the layout to ensure the calendar has a minimum width of 320px.

Added a minimum width of 320px to the calendar container while maintaining its position and other styling properties.

![Updating calendar positioning](https://github.com/user-attachments/assets/d7e3c697-6f3d-412c-9dff-80e8d956e60a)

✅ The calendar positioning and styling as implemented as instructed.

## Visual editing UI elements

Lovable allows you to “select” any area of the UI and directly ask to make changes to it.

![Select multiple elements for visual editing](https://github.com/user-attachments/assets/7a21dede-ab6d-4485-87dc-5aa831fb08e3)

I want to change the app title and the tagline.

Click on the Select button. And, you can move around the mouse around, and will see the elements highlighted.

![Visual editing](https://github.com/user-attachments/assets/2f6c5026-a3d4-42e9-bd99-4b574abe1d1f)

Select the title element. And, ask to change the text.

![Change text for header](https://github.com/user-attachments/assets/7836981b-6af3-4d80-98c8-a817cb886b3d)

Similarly, update the tagline text as well. 

Or you can actually just visually edit the highlighted text, right there from the UI.

## The Final Cut

✅ Here is the final result of the fully functioning Habit Tracker app.

![Final cut of the habit-tracker app](https://github.com/user-attachments/assets/fdf29ab9-d818-4c57-b138-3fa78bdb9ce9)

I hope you enjoyed the article. **I really love Lovable**. Please try [Lovable](https://lovable.dev/) and share your feedback with the community.

>🧑🏼‍💻 You can find the [source code](https://github.com/rupakg/streaks-for-health) to the Habit Tracker app on GitHub.

## Takeaways

The development experience was amazing, and I enjoyed building the app with Lovable. Here are some key observations:

- Lovable produced a beautiful UI design, and the first draft was implemented flawlessly with minimal prompting
- The code structure was organized based on standard Node.js best practices
- The UI was broken up into pages and components utilizing Tailwind CSS
- Development with Lovable proved efficient, with bugs being promptly fixed and features implemented accurately as instructed
- Build errors were identified from the resulting error messages and automatically fixed

## Summary

Here are some of the key features of the app that were implemented in the article:

- A Node.js habits tracker app was developed to help users form healthy habits through regular activity tracking and scheduling
- Users can create activities with flexible scheduling options (daily, weekly, weekdays, weekends) and select specific days of the week
- The app includes a streak counter that updates upon activity completion
- Activities are displayed with colored circles and a calendar view shows completed activities with matching colors and checkmarks
- Implements activity editing functionality allowing users to modify names, colors, and schedules
- The application was containerized using Docker with documented setup instructions

If you have questions or feedback, please let me know in the comments below.

