# PokéType

#### Demo: https://youtu.be/nSrh98es2uk

## Summary
This app allows users to use their **iPhone** to store a list of their favorite Pokémon moves in a **MySQL** database, which is hosted on a **Raspberry Pi**. **LED lights** and **LCD messages** display upon each **RESTful API** request to the Raspberry Pi.

## Structure
1. **An iPhone app** built using **XCode** + **Swift**
1. **A MySQL database** hosted on a Raspberry Pi
   1. The MySQL database stores the user's favorite Pokémon moves for each Pokémon type.
1. **A custom-built API web service** running on the Raspberry Pi
   1. The API is built using a Python RESTful API framework called **Flask**.
   1. The API is used to add and delete moves from the MySQL database.
1. **LED lights** that illuminate upon RESTful API requests to the Raspberry Pi
   1. The LED's are on a breadboard.
   1. The Pi is connected to the breadboard via its GPIO (general-purpose input/output) pins.
1. **An LCD screen** that displays a message indicating success or failure upon each RESTful API request to the Pi
   1. The LCD is also on the breadboard.
   1. The Pi also communicates with the LCD through the breadboard via the Pi's GPIO pins.

## Functionality
### Screen 1 – The Start Screen
The iPhone makes an **HTTP GET** request to PokéAPI to receive and parse the JSON of all the different Pokémon move types. The **IP** button in the top-right of the screen is used to specify the IP address of the Raspberry Pi.
The user taps a type to proceed to the next screen.

<img src="https://raw.githubusercontent.com/wad11656/PokeType/master/README%20media/Screen%20Shot%202020-05-23%20at%202.09.59%20AM.png" width="370">

### Screen 2 – Strengths & Weaknesses
The iPhone makes an **HTTP GET** request to PokéAPI to receive and parse the JSON of the strengths and weaknesses of the selected Pokémon move type.
The user taps on **Favorites** to proceed to the next screen.

<img src="https://raw.githubusercontent.com/wad11656/PokeType/master/README%20media/Screen%20Shot%202020-05-23%20at%202.09.41%20AM.png" width="470">

### Screen 3 – Favorites List
The iPhone makes an **HTTP GET** request to the Raspberry Pi to retrieve the user's list of favorite moves for the selected type. If the user wants to delete an entry, they must provide the correct credentials to make an **HTTP DELETE** request to the Pi.
The user taps the **+** at the top-right to proceed to the next screen.

<img src="https://raw.githubusercontent.com/wad11656/PokeType/master/README%20media/Screen%20Shot%202020-05-23%20at%202.09.27%20AM.png" width="370">

### Screen 4 – Add Favorite
The iPhone first makes an **HTTP GET** request to Pokéapi to retrieve a list of all the possible moves for the selected type.
When the user taps one of the moves on the list, they are prompted to enter credentials. When the correct credentials are entered, an **HTTP POST** request is sent to the Pi, which adds the move to the selected type’s Favorites table. The iPhone then displays the **Favorites List** screen, which shows the list of favorites for the selected type, including the newly-added move.
However, if the move the user is trying to add already exists in the selected type’s Favorites table within the MySQL database, then the Raspberry Pi’s **HTTP POST** request will send back a JSON response that triggers the iPhone app to notify the user that the entry already exists.

<img src="https://raw.githubusercontent.com/wad11656/PokeType/master/README%20media/Screen%20Shot%202020-05-23%20at%202.46.45%20AM.png" width="370">

## LED & LCD Behavior
### Successful HTTP GET, POST, or DELETE:
1. Processing Light:

<img src="https://raw.githubusercontent.com/wad11656/PokeType/master/README%20media/transp.png" width="35"><img src="https://raw.githubusercontent.com/wad11656/PokeType/master/README%20media/Screen%20Shot%202020-05-23%20at%202.11.09%20AM.png" width="100">

2. Success Light:

<img src="https://raw.githubusercontent.com/wad11656/PokeType/master/README%20media/transp.png" width="35"><img src="https://github.com/wad11656/PokeType/blob/master/README%20media/Screen%20Shot%202020-05-23%20at%202.11.28%20AM.png" width="100">
 
3. Success Message:

<img src="https://raw.githubusercontent.com/wad11656/PokeType/master/README%20media/transp.png" width="35"><img src="https://raw.githubusercontent.com/wad11656/PokeType/master/README%20media/Screen%20Shot%202020-05-23%20at%202.11.43%20AM.png" width="200">

### Unsuccessful POST or DELETE (bad credentials):
1. Error Light:

<img src="https://raw.githubusercontent.com/wad11656/PokeType/master/README%20media/transp.png" width="35"><img src="https://raw.githubusercontent.com/wad11656/PokeType/master/README%20media/Screen%20Shot%202020-05-23%20at%202.11.54%20AM.png" width="100">
 
2. Bad Credentials Message:

<img src="https://raw.githubusercontent.com/wad11656/PokeType/master/README%20media/transp.png" width="35"><img src="https://raw.githubusercontent.com/wad11656/PokeType/master/README%20media/Screen%20Shot%202020-05-23%20at%202.12.05%20AM.png" width="200">

### Unsuccessful POST (entry already exists):
1.	Error Light:

<img src="https://raw.githubusercontent.com/wad11656/PokeType/master/README%20media/transp.png" width="35"><img src="https://raw.githubusercontent.com/wad11656/PokeType/master/README%20media/Screen%20Shot%202020-05-23%20at%202.12.20%20AM.png" width="100">
 
2.	Entry Already Exists Message:

<img src="https://raw.githubusercontent.com/wad11656/PokeType/master/README%20media/transp.png" width="35"><img src="https://raw.githubusercontent.com/wad11656/PokeType/master/README%20media/Screen%20Shot%202020-05-23%20at%202.12.35%20AM.png" width="200"></center>
