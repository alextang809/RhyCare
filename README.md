# RhythmCare (Orbital 2021)

A lightweight Android app for users to record their body height and weight.

<br/>

### Disclaimer

All the inputs during Milestone 2 evaluation have been cleared due to a refactor of the database. Please register again and make new records. Thank you!

<br/>

### Proposed Level of Achievement

Gemini

<br/>

### Answer Comments from Milestone 2 Evaluation

1. *"README can be done on Google Docs"*

   If you prefer viewing this in Google Docs, please click [here](https://docs.google.com/document/d/1XzzudgT6EZTC1SsPwSLVZbSPlHsNoM5eIdVm4NhKD0s/edit?usp=sharing).

2. *"creating a Manual-testing flowchart"/ "do be more specific in describing your test cases" / "Include detailed description of testing" / "give evidence of these test cases"*

   Some details of manual system testing will be provided.

3. *"allow user to manually type in their Height/Weight"*

   Sorry, this function will NOT be implemented due to design considerations.

4. *"would the reminders be done through push notifications?"*

   The only reminder currently is done through local notification.

5. *"can have more information about how you think this app would solve user problems, ..." / "..., add a plan to cut out fat ( a very basic ) for people with high BMI, suggesting the problems that come with a high BMI and pushing them to improve it" / "Could focus on alerting user of high BMI" / "Consider colour-labelling of health level (e.g. average, overweight, severely overweight) based on BMI."*

   Hmm, I agree that this app is quite simple, because I just want to make it a simple recorder without many complex functions. Providing suggestions for people with high BMI could be considered, but it has NOT been implemented by Milestone 3. Cards with BMI within different BMI levels are painted with different colors now but I am aware that the meaning of different colors is not clear to users.

6. *"The "so that" part is missing from your documentation."*

   Since I do not list features under the User Stories part, I do not want to add the "so that" part.

7. *"Should add decimals option for weight."*

   Decimals feature is not provided as an option. Instead, weight number is accurate to one decimal place now.

8. *"could implement edit function for records" / "Consider editing of records, in case users input previous records wrongly."*

   Sorry, this function will NOT be implemented. This is because I do not want users to edit their records freely. Instead, users should be careful when making records or deleting wrong records.

9. *"Interactions with database can accompanied with sequence diagrams"*

   Sorry, I am aware that this is a good suggestion but sequence diagrams will NOT be provided since it is above my current level. Instead, I will remove the whole part since it is found not very useful in the documentation.

10. *"Consider providing both slider and +/- buttons. Also consider showing an immediate calculation of BMI before the upload button."*

    Sorry, these features will NOT be implemented due to design considerations.

<br/>

### Motivation

There are some people who care about changes of their body height and weight over time. Instead of taking notes on paper or downloading some complex apps, it is good to have a pure platform to achieve this simple function.

<br/>

### Aim

We hope to provide users with a platform (specifically, an Android mobile app) to record their body height and weight at any time and view all of their records.

<br/>

### User Stories

1. As someone who is trying to lose weight, I want to be able to use the app to keep track of my weight, so that I can know my progress.
2. As someone who is sick, I want to be able to use the app to keep track of my weight, so that I can better know my physical condition.
3. As someone who is growing up, I want to be able to use the app to keep track of my height, so that I can see the process of my physical growth.

<br/>

### Scope of Project & Development Plan

The Android app provides a pure platform for users to (1) record their body height and weight at any time they want (2) view all of their records.

<br/>

Features completed by the end of May:

**Sign up/Login function**

The app requires users to sign up for an account before logging in to use it. Users can then use the same account to login on any Android phone with the app and data will be synced on all devices.

<br/>

Features completed by the end of June [must-have features]:

**Home Page** allows users to make an input of their current height, weight, and age, after which they can upload the data to the database to make a record.

**Records Page** allows users to view all the records (including height, weight, age, and calculated BMI) they have made so far in a list form. The latest record is shown at the top by default. ~~Users can long press a record to delete it.~~

**Settings Page** allows users to sign out.

<br/>

Features completed by the end of July:

**Sign up/Login function**

1. [should-have] The app asks users to verify their email address by sending confirmation emails. In general, an unverified user is signed out automatically in about one minute.
2. [could-have] The app allows users to sign in with Google.

**Home Page**

1. [should-have] The **–** and **+** buttons for adjusting weight and age are able to be long pressed to adjust faster.
2. ~~[won’t-have] The input of age data will be removed if it is proven to be useless.~~ (The age input is kept to serve users' own purposes.)
3. A few UI elements have been improved.

**Records Page**

1. ~~[should-have] The app should have a filter for users to select to only view height/weight/BMI data.~~
2. [could-have] The app has a "filter by time" function for users to select to view records within a specific period.
3. [could-have] The app has a "generate chart" function generating charts to better reflect changes of height/weight/BMI.
4. [could-have] The app has a "sort" function to reverse the order of the list. (Note that the list can only be sorted by time automatically.)
5. [could-have] Each record is clickable. Users can save/share a record as an image or delete the record.
6. A few UI elements have been improved (including coloring cards according to BMI levels).

**Settings Page**

1. [should-have] The app provides a way for users to change their password. This is only applicable to users logging in using email address and password.
2. [should-have] The app provides a way for users to change their email address. This is only applicable to users logging in using email address and password AND when the email address has not been verified. This is to say, once a user has verified his/her email address, he/she will not be able to change it any more.
3. ~~[could-have] The app could allow users to have a nickname and an avatar (for sharing their records).~~
4. [could-have] The app has a "reminder" function to remind users to make records periodically. Currently, only one reminder is provided with a few fixed periods to choose from.
5. [should-have] The app has a "enable/disable specific functions" function for users to enable/disable specific items when making records.
6. A few UI elements have been improved.

<br/>

Features could be implemented in the future:

1. [should-have] The "filter by time" function should allow showing records before/after a specific time.
2. [should-have] The "generate chart" function should allow users to save and/or share the charts generated.
3. [should-have] The "reminder" function should allow more than one reminder. Also, the reminder should be more flexible.
4. [should-have] The "record page" should explain to users the meaning of different colors.
5. [should-have] The "generate chart" function should handle multiple records made on the same date in a better way.
6. [could-have] The "record page" could allow users to select multiple records once to delete and/or share.
7. [could-have] The app could alert users with too low/high BMI.

<br/>

### Development

1. Tech Stack

   Flutter + Firebase

2. Backend database

   We chose Firebase as our backend and database. More specifically, we are using Firebase Authentication and Firestore Database.

   - Database structure:

     Firebase Cloud Firestore simply consists of collections and documents.

     ![Cloud Firestore Structure 1](https://github.com/alextang809/RhyCare/blob/main/pictures/Cloud%20Firestore%20Structure%201.png)

     ![Cloud Firestore Structure 2](https://github.com/alextang809/RhyCare/blob/main/pictures/Cloud%20Firestore%20Structure%202.png)

     ![Cloud Firestore Structure 3](https://github.com/alextang809/RhyCare/blob/main/pictures/Cloud%20Firestore%20Structure%203.png)

     ![Cloud Firestore Structure 4](https://github.com/alextang809/RhyCare/blob/main/pictures/Cloud%20Firestore%20Structure%204.png)

3. Notes

   - Link project with GitHub
     1. create a new GitHub repository
     2. create a new Flutter project locally
     3. git push the project to GitHub

   - Link project with Firebase
     - create a new project on Firebase and link the app to the project following instructions
   - Bottom navigation bar
     - Using variables makes it possible to have different titles on the app bar on different pages with a single navigation bar.

   - Useful packages/plugins/dependencies
     - “fluttertoast” package
       - The app uses the “fluttertoast” package to show toast messages during many situations to provide feedbacks to users’ actions, such as successful registration, invalid email address/password, and successful upload of record, etc.
     - “shared_preferences” package
       - The app uses the “shared_preferences” package to memorize a user’s signed in/out status. When a user has logged in and exits the app, he/she won’t be required to login again next time he/she opens the app. When a user has signed out and exits the app, he/she will be required to login again next time he/she opens the app.
       - The package is also used to memorize any latest changes on the Home Page, time range filter and reverse order preferences on the Records Page, and a few more scenarios.
     - “rflutter_alert” package
       - The app uses the “rflutter_alert” package to pop out an alert message before a user deletes a record. Only when the user confirms the deletion, the record will be deleted.
     - "flutter_easyloading" and "block_ui" packages
       - The app uses the "flutter_easyloading" package and the "block_ui" package to show a loading screen when it may take some time to interact with the backend. It blocks the UI when a loading screen is being shown to prevent users from interacting with the app. Timeout features are also implemented to unblock the UI and cancel the loading screen. **Complicated testing has been done, but there might still be potential bugs for these features. Try force closing the app when your UI is blocked abnormally. Please report any bugs.**
     - "flutter_local_notifications" package
       - The app uses the "flutter_local_notifications" package to schedule local notifications. **Complicated testing has been done to make sure the reminder works normally. If you cannot receive any notifications, check your phone settings to make sure you provide the app with relevant permissions (including notification sounds). You may need to turn off battery optimization for the app to receive notifications when the app is closed.**
     - "syncfusion_flutter_charts" package
       - The app uses the "syncfusion_flutter_charts" package to generate charts. Maybe due to package limitations, the charts may not look very nice when intervals between records are inconsistent and large. You can zoom the chart to view details.
     - "share_plus" package
       - The app uses the "share_plus" package to share a record. **Due to some unknown reasons, the package does not work well when sharing to some platforms. There may be a platform mismatch.**
     - View \<project>/pubspec.yaml for more packages used
   - Generate apk
     - Modify \<project>/android/app/src/main/res/raw/keep.xml to keep the resources for local notifications.
     - To generate apk, run “flutter build apk --split-per-abi”
     - The apk is located at \<project>/build/app/outputs/apk/release/

<br/>

### System Testing

Complicated system tests instead of unit tests have been done. Those listed below are some special test cases and they have been passed or fixed by now unless otherwise stated. (Actual result is not documented.)

![System Testing](https://github.com/alextang809/RhyCare/blob/main/pictures/System%20Testing.png)

<br/>

### User Instructions

It’s very easy to use the app since it has a very simple and clear interface.

To use it on an Android phone:

1. Download the apk [here]() (not the latest version) for Milestone 3 evaluation and install it on your phone
2. Register an account or Sign in with Google
3. Start using the app

Note that the app must be used inside countries where Google services are not banned or you can connect to a stable VPN before opening the app.
