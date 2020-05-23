# PokéType

## Summary
This app allows users to use their **iPhone** to store a list of their favorite Pokémon moves in a **MySQL** database, which is hosted on a **Raspberry Pi**. **LED lights** and **LCD messages** display upon each **RESTful API** request to the Raspberry Pi.

## Structure
1. **An iPhone app** built using **XCode** + **Swift**
1. **A Raspberry Pi** that hosts a MySQL database
   1. The MySQL database stores tables containing the user's "favorite moves" for each Pokémon type.
1. **A custom-built API web service** running on the Raspberry Pi
   1. The API is built using a Python RESTful API framework called **Flask**.
   1. The API is used to add and delete moves from the MySQL database.
1. **LED lights** that illuminate upon RESTful API requests to the Raspberry Pi
1. **An LCD screen** that displays a message indicating success or failure upon each RESTful API request to the Pi.

## Functionality
### Screen 1 – Start Screen
The iPhone makes an **HTTP GET** request to PokéAPI to receive and parse the JSON of all the different Pokémon move types. The **IP** button in the top-right of the screen is used to specify the IP address of the Raspberry Pi.
The user taps a type to proceed to the next screen.
![Screen1]("/README media/Screen Shot 2020-05-23 at 2.09.08 AM.png")

### Screen 2 – Strengths & Weaknesses
The iPhone makes an **HTTP GET** request to PokéAPI to receive and parse the JSON of the strengths and weaknesses of the selected Pokémon move type.
The user taps on **Favorites** to proceed to the next screen.

### Screen 3 – Favorites List
The iPhone makes an **HTTP GET** request to the Raspberry Pi to retrieve the user's list of favorite moves for the selected type. If the user wants to delete an entry, they must provide the correct credentials to make an **HTTP DELETE** request to the Pi.
The user taps the **+** at the top-right to proceed to the next screen.

### Screen 4 – Add Favorite
The iPhone first makes an **HTTP GET** request to Pokéapi to retrieve a list of all the possible moves for the selected type.
When the user taps one of the moves on the list, they are prompted to enter credentials. When the correct credentials are entered, an **HTTP POST** request is sent to the Pi, which adds the move to the selected type’s Favorites table. The iPhone then displays the **Favorites List** screen, which shows the list of favorites for the selected type, including the newly-added move.
However, if the move the user is trying to add already exists in the selected type’s Favorites table within the MySQL database, then the Raspberry Pi’s **HTTP POST** request will send back a JSON response that triggers the iPhone app to notify the user that the entry already exists.

## LED & LCD Behavior
### Successful HTTP GET, POST, or DELETE:
1. Processing Light:
   
1. Success Light:
 
1. LCD Success Message:

### Unsuccessful POST or DELETE (bad credentials):
1. Error Light:
 
1. LCD Bad Credentials Message:

## Entry already exists:
1.	Error Light:
 
2.	LCD Entry Already Exists Message:
