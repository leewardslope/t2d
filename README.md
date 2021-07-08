# What is t2d?
t2d aka Talk to Dokku; is a beautiful Terminal User Interface(TUI) powered by dokku. With t2d you will be able to deploy apps in most popular programming languages, link them to most popular databases and all that with almost zero configuration from your side. Apart from all these amazing features it will also save you money along the way.

# Our Vision
We started to work on this because current deployment solutions were expensive or hard to configure. With t2d we plan to provide a solution where deployment experience is smooth, enjoyable and affordable.

# What is Dokku?
Dokku is Docker-powered Heroku-like tool that allows you to deploy complex applications by simply pushing it via Git repository. Behind the scenes it runs on herokuish, which essentially is emulating same functionalities that you are using when you deploy your apps on Heroku. As it supports all the Heroku buildpacks, it is fairly easy for you to transfer your Heroku apps to Dokku using t2d.

# How does it work?
t2d is backed with two types of methods. One being the official managed automatic scripts for quick installations, while the other being a simple interface for manually configuring your app. 

As of now you can build apps in these languages: 
- Javascript, 
- Go, 
- Ruby, 
- PHP, 
- Python, 
- Java, 
- Scala, 
- Clojure 

and link them to any of these databases: 
- PostgreSQL, 
- MongoDB, 
- MySQL, 
- Redis.

In other words, if your application can run in Heroku, it is always possible to make it up and running in Dokku; t2d stands as a medium for you to talk with dokku and configure your app, within your terminal.

# Quick Start Instructions
### Downlaod the Latest t2d Script
```
wget https://raw.githubusercontent.com/akhil-naidu/t2d/master/whip-dokku.sh
```
### Execute it in root
```
bash whip-dokku.sh
```
### Pre-requisites
1. Preferrably Dokku configured VPS.
2. Domain Name pointing to your VPS IP.
3. Keep an eye at your terminal, t2d might need your assistance to move forward.
