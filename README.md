# RhythmCare (Orbital 2021)

A lightweight Android app that helps record your body height and weight.

<br/>

**NOTE: THIS IS A BRAND NEW APP DUE TO A REFACTOR OF OUR PROJECT IDEA. We apologize for any inconvenience caused, but don't worry since this app is much simpler than the last one.**

<br/>

### Proposed Level of Achievement

~~Apollo 11~~ Gemini

<br/>

### Motivation

There are some people who care about changes of their body height and weight over time. Instead of taking notes on paper or downloading some complex apps, it is good to have a pure platform to achieve this simple function.

<br/>

### Aim

We hope to provide users with a platform (specifically, an Android mobile app) to record their body height and weight at any time and view all of their records.

<br/>

### User Stories

1. As someone who is trying to lose weight, I want to be able to use the app to keep track of my weight, so that I can know my progress.

2. As someone who is growing up, I want to be able to use the app to keep track of my height, so that I can see the process of my physical growth.

<br/>

### Scope of Project & Development Plan

The Android app provides a pure platform for users to (1) record their body height and weight at any time they want (2) view all of their records.

<br/>

Features completed by the end of May:

**Sign up/Login function**

The app requires users to sign up for an account before logging in to use it. Users can then use the same account to login on any Android phone with the app and data will be synced on all devices.

<br/>

Features completed by the end of June [must-have features]:

**Home Page** allows users to make an input of their current height, weight, and age, after which they can upload the data to the system to make a record.

**Records Page** allows users to view all the records (including height, weight, and calculated BMI) they have made so far in a list form. The latest record is shown at the top. Users can long press a record to delete it.

**Settings Page** allows users to sign out.

<br/>

Features to be completed by the end of July:

**Sign up/Login function**

1. [should-have] The app should check that the email users register with is valid by sending confirmation emails to check.

2. [could-have] Users could also use their Google account to sign up.

**Home Page**

1. [should-have] The **–** and **+** buttons for adjusting weight should be able to be long pressed to faster decrease and increase.

2. [won’t-have] The input of age data will be removed if it is proven to be useless.

**Records Page**

1. [should-have] The app should have a filter for users to select to only view height/weight/BMI data.

2. [could-have] The app could have functions to generate graphs to better reflect changes of height/weight.

3. [could-have] Users could share a record (and share graphs generated) to their friends.

**Settings Page**

1. [should-have] The app should provide a way for users to change their password.

2. [could-have] The app could provide a way for users to change their email address.

3. [could-have] The app could allow users to have a nickname and an avatar (for sharing their records).

4. [could-have] The app could have a reminder function to remind users to make records periodically.

<br/>

### Development Processes

1. Tech Stack

   Flutter + Firebase

2. Backend database

   We chose to use Firebase as our backend and database. More specifically, we are using the Authentication function as well as the Firebase Database.

   - Database structure:

     Firebase Cloud Firestore simply consists of collections and documents.

     ![Cloud Firestore Structure](https://github.com/alextang809/RhyCare/blob/main/pictures/structure.png)

   - Interactions with database:
     - A user is created by Firebase Authentication when a user presses the “Register” button.
     - The user will be signed in by Firebase Authentication when he/she presses the “Login” button.
     - The user will be signed out by Firebase Authentication when he/she presses the “Sign out” button.
     - A document is created under collection “users” **when a user registers a new account**, and the document id is the same as the users’ id issued by Firebase Authentication.
     - A document is created under collection “records” **when a user registers a new account**, and the document id is the same as the users’ id issued by Firebase Authentication.
     - A sub-collection named “user_records” with a dummy document (i.e., one dummy record) under it is created, under the above-mentioned document with the users’ id under collection “records”, **when a user registers a new account**.
     - A new document with specific fields and values is created when the user presses the “UPLOAD” button on the Home Page.
     - The specific document is deleted from the database when the user deletes a record.
     - Any changes made to the user’s “user_records” collection are listened to using Streams, so that any upload of records can be immediately shown on the Record Page.

3. A rough development process so far

   1. create a new GitHub repository

   2. create a new Flutter project locally

   3. git push the project to GitHub

   4. create a new project on Firebase and link the app to the Firebase project

   5. Login/Register frontend

      * Design note: The app uses the “fluttertoast” package to show toast messages during many situations to provide feedbacks to users’ actions, such as successful registration, wrong email address/password, and successful upload of record.

   6. Login/Register backend

   7. Settings Page and Sign out

      * Design note: The app uses the “shared_preferences” package to memorize a user’s signed in/out status. When a user has logged in and exits the app, he/she won’t be required to login again next time he/she opens the app. When a user has signed out and exits the app, he/she will be required to login again next time he/she opens the app.

   8. add a bottom navigation bar

      * Implementation note: Using variables makes it possible to have different titles on app bar on different pages with a single navigation bar.

   9. Home Page frontend

   10. Home Page backend

   11. Records Page backend

       * Design note: The app shows a progress indicator when data are being fetched from database.

       * Implementation note: We first developed the backend of Records Page to make sure the system is working since this is more crucial to this page, and then proceeded to develop the frontend.

   12. Records Page frontend

       * Design note: The app uses the “rflutter_alert” package to pop out an alert message when user long presses a record. Only when the user confirms the deletion, the record will be deleted.

   13. Generate apk

       * To generate apk, run “flutter build apk --split-per-abi”

       * The apk is located at <project>/build/app/outputs/apk/release/

<br/>

### System Testing

1. End to end scenario testing: the application works fine and components interact with one another is smooth and bug free
   
2. Many types of input were checked in the text boxes, desired outputs was generated well
   
3. User experience testing: only our team was involved in, but user experience is fine, deriving from the large possibility of extension although the application is super easy to use

<br/>

### User Instructions

It’s very easy to use the app since it has a very simple and clear interface.

To use it on an Android phone:

1. Download the apk at [here](https://drive.google.com/file/d/1wv20UUb5xNFdzZyDafMFh3PBvEQjk8oV/view?usp=sharing) and install it on your phone

2. Register an account and start using it

Note that the app must be used inside countries where Google services are not banned or you can connect to a stable VPN before using it.
