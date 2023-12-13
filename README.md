# CoolCoolCoffee

## Introduction

2023 Chungang-univ Capstone Design Project Team05

CoolCoolCoffee helps people to control caffeine intake for sleeping well when people want to get to sleep. It provides the user with the information about the amount of caffeine intake and drink time before going to bed.

#### Tag v1.0 : Tag 하나 달아서 적으면 됨

#### Target device: Android

#### OS: Window 10, MacOS

#### Editor: Android Studio

#### Language: Dart

#### Needed: Flutter SDK, Flutter & Dart plugin


## Demo Video about CoolCoolCoffee

[![Demo_video](http://img.youtube.com/vi/lQ6Sh3euh6E/0.jpg)](https://youtu.be/lQ6Sh3euh6E)


## Build
If you want to run this program in your local system, please follow this guide. 

### 1. Prerequisites

Target Device: Android

OS: Windows 10, MacOS

#### Install "Flutter SDK"

- For [Windows](https://docs.flutter.dev/release/archive?tab=windows)
  
Remember to unpack the Flutter SDK file at the appropriate position. Do not unpack the file in folders like Program Files. <br/>
Ex) D:\flutter

Then, set the SDK path to the environment variable. You should set the variable to the path of flutter SDK’s bin folder.<br/>
Ex) D:\flutter\bin


- For [MacOS](https://docs.flutter.dev/release/archive?tab=macos)
  
Open terminal and type commands below.

If your terminal is zsh,

	touch ~/.zshrc
	open ~/.zshrc

If your terminal is bash,

	touch ~/.bash_profile
	open ~/.bash_profile

Then a text editor will pop. You should add the code below with the address of YOUR Flutter SDK folder.

	export PATH=”$PATH:yourFlutterAddress/bin”
Save and close the editor.
<br/>
<br/>
For Windows and MacOs, check whether you have completed all your tasks for using flutter with the command below.

	flitter doctor

#### Download [Android Studio](https://developer.android.com/studio/install?hl=ko) 
After the installation, go to 
#### Install "Flutter & Dart plugin" in Android Studio


### 2. Clone the repository


    git clone https://github.com/CoolCoolCoffee/CoolCoolCoffee.git


This will create a local copy of the repository.

### 3. Build the project

To build Files for development, open the **CoolCoolCoffee_FrontEnd** package in Android Studio.

In the terminal, ‘flutter pub get’ is needed before running the program.

Now, Click the ‘build’ and Enjoy our program!

(If you are using Android Emulator in Android Studio, you can’t use the camera so that you may not use ‘OCR’ function for capturing Starbucks Label.)


## Common Problems

- We use the “Health Connect” app to connect with Samsung Health to get sleep information automatically. But “Health Connect” is still in beta, so it may not work properly in some cases. Therefore, if you can’t recall it, proceed with the setting again, or if an error occurs continuoutsly, please receive sleep information by manual input and use the app.

## Bug Reporting and Feature Request
If you find any bugs, please report it by submitting an issue on our [issue page](https://github.com/CoolCoolCoffee/CoolCoolCoffee/issues) with a detailed explanation. Giving some screenshots would also be very helpful. You can also submit a feature request on our [issue page](https://github.com/CoolCoolCoffee/CoolCoolCoffee/issues) and we will try to implement it as soon as possible.


