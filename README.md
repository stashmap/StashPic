# StashPic
StashPic submits screenshots to the stashmap.net site, where they are used to create markers on the map. One marker is a small stash or group of small stashes. The marker stores images of the location of small stash on the ground, images of the location on the map and images of the contents of each small stash.

## Table of contents
* [General info](#general-info)
* [Technologies](#technologies)
* [Setup](#setup)
* [Features](#features)
* [Status](#status)
* [Contact](#contact)

## General info
I love to play Rust. And I like to hide things underground. Sometimes this was the only thing that saved me during the raid. I also like to search for bases for a raid, but uploading screenshots to friends on social networks is not very convenient. I'm also a web developer. This is how the stashmap.net and StashPic appeared, as the sender of screenshots.

## Technologies
* Indy Clients IdHTTP - to send screenshots and communicate with the server
* Registry - to store application config data
* Threads - to upload images quickly 
* Global hotkeys - to take and send screenshots directly from the game

## Setup
For the application to work, you only need a StashPic.exe file and the media directory

## Features
* Sending screenshots to the server
* Launch Rust when the application starts
* Launch Rust and connect to specified server when the application starts
* Close application when Rust close

## Status
Project is: _in progress_  The application cannot take screenshots if the Rust screen is set to exclusive mode

## Contact
Email : stashmap@gmail.com
Discord : [discord.gg/HmSgK9BT](https://discord.gg/HmSgK9BT)

## License
[MIT](https://choosealicense.com/licenses/mit/)
