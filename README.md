Wade Murdock & Benny Liao

Professor Teng

IT 344

Project 2 Report

Project 2 Report

1.  **Describe your web service. Including purpose, functionality, app
    > screenshots, etc.**

    a.  **Purpose**

> The purpose of our project was to allow a user to use their iPhone to
> store a list of their favorite Pokémon moves in a MySQL database on a
> Raspberry Pi. Our purpose was to also learn how to create our own API
> web service and learn our way around Xcode and Swift, which are used
> to program iPhone apps. Another purpose was to learn to interface our
> Raspberry Pi with output devices like the LED lights and an LCD
> screen.

b.  **Functionality**

> **Screen 1 -- Start Screen:**
>
> An element from **Project 1**. Here, the iPhone directly calls the
> Pokéapi API to receive and parse the JSON of all the different Pokémon
> move types. The **IP** button in the top-right of the screen can
> change the IP address to the IP of the web service API (a.k.a. the
> Raspberry Pi).

![](.//media/image1.png){width="2.361111111111111in"
height="4.112351268591426in"}

![](.//media/image2.png){width="2.8818842957130357in"
height="1.1388888888888888in"}

**Screen 2 -- Strengths & Weaknesses:**

> An element from **Project 1**. Here, the iPhone directly calls the
> Pokéapi API to receive and parse the JSON of the strengths and
> weaknesses of the selected Pokémon move type.

![](.//media/image3.png){width="1.8416666666666666in"
height="3.2083333333333335in"}

![](.//media/image2.png){width="2.8818842957130357in"
height="1.1388888888888888in"}

> **Screen 3 -- Favorites List:**
>
> The iPhone makes an **HTTP GET** request to the Pi for the list of the
> user's saved favorite moves for the selected type. The list of
> favorite moves is stored on the Raspberry Pi in a **MySQL** database.
> If the user wants to delete an entry, they must provide the correct
> credentials to make an **HTTP DELETE** request to the Pi.

![](.//media/image4.png){width="1.3472222222222223in"
height="1.0805369641294837in"}![](.//media/image5.png){width="1.9527777777777777in"
height="3.4027777777777777in"}

![](.//media/image6.png){width="2.1798611111111112in"
height="1.4534722222222223in"}

![](.//media/image7.tiff){width="1.25in" height="1.25in"}

> **Screen 4 -- Add Favorite:**
>
> The iPhone first makes an **HTTP GET** request to Pokéapi to retrieve
> a list of all the possible moves for the selected type. Pokéapi
> returns the results to the iPhone app as JSON. The iPhone app parses
> that JSON to make it appear as a list and displays that list
> on-screen.
>
> When the user taps one of the moves on the list, they are prompted to
> enter credentials. When the correct credentials are entered, an **HTTP
> POST** request is sent to the Pi's [Python+Flask
> API](https://flask.palletsprojects.com/en/1.1.x/api/). This **POST**
> request adds the move to the selected type's **Favorites** table
> within the Pi's **MySQL** database. The iPhone then displays the
> **Favorites List** screen, which shows the list of favorites for the
> selected type, along with the newly-added move.
>
> However, if the move the user is trying to add already exists in the
> selected type's **Favorites** table **within the MySQL database**,
> then the Raspberry Pi's **HTTP POST** request will send back a JSON
> response that triggers the iPhone app to notify the user that the
> entry already exists.

![](.//media/image8.png){width="1.6944444444444444in"
height="1.3383464566929133in"}

![](.//media/image9.png){width="2.72872375328084in"
height="1.0770833333333334in"}![](.//media/image10.png){width="2.138888888888889in"
height="3.725in"}

![](.//media/image6.png){width="2.1798611111111112in"
height="1.4534722222222223in"}

![](.//media/image7.tiff){width="1.25in" height="1.25in"}

![](.//media/image11.png){width="1.6993055555555556in"
height="0.9861111111111112in"}

> **Raspberry Pi Output Devices**

1.  **On Successful HTTP GET, POST, or DELETE:**

```{=html}
<!-- -->
```
1)  **Processing Light:**

> ![](.//media/image12.png){width="1.2584536307961505in"
> height="1.2792891513560805in"}

2)  **Success Light:**

> ![](.//media/image13.png){width="1.291738845144357in"
> height="1.3173195538057743in"}

3)  **LCD Success Message:**

> ![](.//media/image14.png){width="1.0in" height="2.1818186789151355in"}

2.  **On Unsuccessful POST or DELETE (Bad Credentials):**

```{=html}
<!-- -->
```
1)  **Error Light:**

> ![](.//media/image15.png){width="1.4270833333333333in"
> height="1.3785903324584428in"}

2)  **LCD Bad Credentials Message:**

> ![](.//media/image16.png){width="1.0709383202099738in"
> height="2.236930227471566in"}

3.  **On Unsuccessful POST (Entry Already Exists):**

```{=html}
<!-- -->
```
1)  **Error Light:**

> ![](.//media/image15.png){width="1.4270833333333333in"
> height="1.3785903324584428in"}

2)  **LCD Entry Already Exists Message:**

> ![](.//media/image17.png){width="0.9856014873140857in"
> height="2.2027613735783027in"}

a.  **App Screenshots**

> (See Above)

2.  **Technical detail of the web service URL for the API, examples of
    > JSON/XML data, how it\'s been used by your app, etc.**

> RESTful API **POST** and **DELETE** HTTP requests were sent from the
> iPhone with the aid of a plugin called Alamofire. **GET** requests
> used Apple's included RESTful API packages. These requests were sent
> to a Python-powered FLASK API web service hosted on the Raspberry Pi.
> The FLASK API web service takes the arguments given in the URL from
> the iPhone and sends back the corresponding JSON response.

a.  **Web Service URL**

    1.  **HTTP GET (Favorites List):**

> **iPhone \[Send URL\] Example:**
>
> http://192.168.159.225:5000/favs?Poketype=ice
>
> **Pi \[Handle URL\] Code:**
>
> \@app.route(\'/favs\', methods=\[\'GET\'\])
>
> def get\_table():
>
> fav\_arg = request.args.get(\'Poketype\', None)
>
> favsArr = \[\]
>
> if fav\_arg == None:
>
> return jsonify({\'Error\': \'Invalid Type Passed in favs GET\'})
>
> elif fav\_arg not in \[\'normal\', \'fighting\', \'poison\',
> \'flying\', \'ground\', \'bug\', \'ghost\', \'steel\', \'fire\',
> \'rock\', \'water\', \'grass\', \'electric\', \'psychic\', \'ice\',
> \'dragon\', \'dark\', \'fairy\', \'unknown\', \'shadow\'\]:
>
> return jsonify({\'Error\': \'Invalid Type Passed in favs GET\'})
>
> else:
>
> processing\_light()
>
> favs = db.session.query(Favs\_table).filter\_by(Poketype = fav\_arg)
>
> for fav in favs:
>
> favsArr.append(fav.toDict())
>
> return jsonify(favsArr)

2.  **HTTP GET (All Moves List):**

> **iPhone \[Send URL\] Example:**
>
> http://192.168.159.225:5000/favs?Poketype=ice
>
> **Pi \[Handle URL\] Code:**
>
> \@app.route(\'/poketype\', methods=\[\'GET\'\])
>
> def get\_poketype():
>
> \# Example: curl -i \'http://localhost:5000/poketype?Poketype=shadow\'
>
> poketype\_arg = request.args.get(\'Poketype\', None)
>
> pokeapi\_entry = \"\"
>
> if poketype\_arg == None:
>
> pokeapi\_entry = jsonify({\'Pokeapi\_Type\': \'Not Found\'})
>
> elif poketype\_arg not in \[\'normal\', \'fighting\', \'poison\',
> \'flying\', \'ground\', \'bug\', \'ghost\', \'steel\', \'fire\',
> \'rock\', \'water\', \'grass\', \'electric\', \'psychic\', \'ice\',
> \'dragon\', \'dark\', \'fairy\', \'unknown\', \'shadow\'\]:
>
> pokeapi\_entry = jsonify({\'Pokeapi\_Type\': \'Not Found\'})
>
> else:
>
> pokeapi\_url = \"https://pokeapi.co/api/v2/type/\" + poketype\_arg +
> \"/\"
>
> pokeapi\_entry = jsonify(requests.get(pokeapi\_url).json())
>
> return pokeapi\_entry

3.  **HTTP POST:**

> **iPhone \[Send URL\] Example:**
>
> \"Content-Type: application/json\" -X POST -d \'{\"Name\":\"Haze\",
> \"Poketype\":\"Ice\"}\' http://192.168.159.225:5000/favs
>
> **Pi \[Handle URL\] Code:**
>
> \@app.route(\'/favs\', methods=\[\'POST\'\])
>
> \@auth.login\_required
>
> def add\_fav():
>
> if not request.json or not \'Name\' in request.json or not
> \'Poketype\' in request.json:
>
> abort(400)
>
> entry = \"\"
>
> if db.session.query(Favs\_table).filter\_by(Name =
> request.json\[\'Name\'\], Poketype =
> request.json\[\'Poketype\'\]).first():
>
> new\_fav\_json = {\'Error\': \'Entry Already Exists\'}
>
> entry = jsonify(new\_fav\_json)
>
> else:
>
> new\_fav\_json = {
>
> \'Name\': request.json\[\'Name\'\],
>
> \'Poketype\': request.json\[\'Poketype\'\]
>
> }
>
> new\_fav = Favs\_table(0, request.json\[\'Name\'\],
> request.json\[\'Poketype\'\])
>
> db.session.add(new\_fav)
>
> db.session.commit()
>
> entry = jsonify({\'New Entry\': new\_fav\_json})
>
> print(\"global num\_unauth suc =\" + str(num\_unauth))
>
> return entry, 201

4.  **HTTP DELETE:**

> **iPhone \[Send URL\] Example:**
>
> http://localhost:5000/favs/delete?Name=Haze&Poketype=Ice
>
> **Pi \[Handle URL\] Code:**
>
> \@app.route(\'/favs/delete\', methods=\[\'DELETE\'\])
>
> \@auth.login\_required
>
> def delete\_fav():
>
> name\_del = request.args.get(\'Name\', None)
>
> type\_del = request.args.get(\'Poketype\', None)
>
> if name\_del == None:
>
> return jsonify({\'Error\': \'Name not passed for deletion\'})
>
> elif type\_del == None:
>
> return jsonify({\'Error\': \'Type not passed for deletion\'})
>
> elif db.session.query(Favs\_table).filter\_by(Name = name\_del,
> Poketype = type\_del).first():
>
> db.session.query(Favs\_table).filter\_by(Name = name\_del, Poketype =
> type\_del).delete()
>
> db.session.commit()
>
> return jsonify({\'Entry\': \'Deleted\'})
>
> else:
>
> return jsonify({\'Entry\': \'Not Found\'})

b.  **JSON Data & How It's Used**

    1.  **HTTP GET (Favorites List):**

> **Pi \[Send JSON\] Example:**
>
> **Unsuccessful:**
>
> {\'Error\': \'Invalid Type Passed in favs GET\'}
>
> **Successful:**
>
> **{"Name": \"Haze\", "Poketype": \"ice\", "id": "101"},{"Name": \"Ice
> Ball\", "Poketype": \"ice\", id: "103"}**
>
> **iPhone \[Handle JSON\] Code:**
>
> URLSession.shared.dataTask(with: url) { (data, response, err) **in**
>
> **guard** **let** data = data **else** { **return** }
>
> **do** {
>
> **let** fav = **try** JSONDecoder().decode(\[favorites\].**self**,
> from: data)
>
> **self**.favoritesArray = fav
>
> print(**self**.favoritesArray)
>
> DispatchQueue.main.async {
>
> **self**.tblFavorites.reloadData()
>
> }
>
> }**catch** **let** jsonErr {
>
> print(\"Error serializing json:\", jsonErr)
>
> }
>
> }.resume()

2.  **HTTP GET (All Moves List):**

> **Pi \[Send JSON\] Example:**
>
> **Unsuccessful:**
>
> {'Pokeapi\_Type': 'Not Found\'}
>
> **Successful:**
>
> **{"name": \"haze\", "url": \"**
> **https://pokeapi.co/api/v2/move/114/**
>
> **\"},{"name": \"ice-ball\", "url": \"**
> **https://pokeapi.co/api/v2/move/301/**
>
> **\"}**
>
> **\... etc \...**
>
> **iPhone \[Handle JSON\] Code:**
>
> URLSession.shared.dataTask(with: url) { (data, response, err) **in**
>
> **guard** **let** data = data **else** { **return** }
>
> **do** {
>
> **let** add\_fav = **try**
> JSONDecoder().decode(moves\_struct.**self**, from: data)
>
> **let** moves\_array = add\_fav.moves?.compactMap({
> \$0.name?.capitalized }) ?? \[\"Bad data\"\]
>
> **self**.possibleFavsArray = moves\_array.map { individual\_move(name:
> \$0) }
>
> DispatchQueue.main.async {
>
> **self**.AllTbl.reloadData()
>
> }
>
> }**catch** **let** jsonErr {
>
> print(\"Error serializing json:\", jsonErr)
>
> }
>
> }.resume()

3.  **HTTP POST:**

> **Pi \[Send JSON\] Example:**
>
> **Unsuccessful:**
>
> {\'Error\': \'Entry Already Exists\'}
>
> OR
>
> {\'Error\': \'Unauthorized Access\'}
>
> **Successful:**
>
> **{'New Entry': 'haze'}**
>
> **iPhone \[Handle JSON\] Code:**
>
> **if** response.data != **nil** {
>
> **do** {
>
> **let** json = **try** JSON(data: response.data!)
>
> **let** name = json\[\"Error\"\].string
>
> **if** name != **nil** {
>
> response\_string = name!
>
> }
>
> }
>
> **catch** **let** error **as** NSError{
>
> *//error*
>
> }
>
> }
>
> **if** response\_string != \"Unauthorized Access\" && response\_string
> != \"Entry Already Exists\"{
>
> **self**.presentingViewController?.dismiss(animated: **true**,
> completion: **nil**)
>
> }
>
> **else** **if** response\_string == \"Unauthorized Access\"{
>
> tableView.selectRow(at: indexPath, animated: **true**, scrollPosition:
> UITableViewScrollPosition.none)
>
> tableView.delegate!.tableView!(tableView, didSelectRowAt: indexPath)
>
> }
>
> **else** **if** response\_string == \"Entry Already Exists\"{
>
> **let** alreadyExistsAlert = UIAlertController(title: \"Entry Already
> Exists\", message: \"\\n\\\"\" +
> **self**.correctMoveName(not\_corrected:
> **self**.possibleFavsArray\[indexPath.row\].name)! + \"\\\" already
> exists in the table\\n\\\"\\(**self**.subType.capitalized)
> Favorites\\\"\", preferredStyle: UIAlertControllerStyle.alert)
>
> **let** dismissAction = UIAlertAction(title: \"Dismiss\", style:
> UIAlertActionStyle.cancel) { (result : UIAlertAction) -\> Void **in**
>
> print(\"Dismiss\")
>
> }
>
> alreadyExistsAlert.addAction(dismissAction)
>
> **self**.present(alreadyExistsAlert, animated: **true**, completion:
> **nil**)
>
> }

4.  **HTTP DELETE:**

> **Pi \[Send JSON\] Example:**
>
> **Unsuccessful:**
>
> {\'Error\': \'Name not passed for deletion\'}
>
> OR
>
> {\'Error\': \'Type not passed for deletion\'}
>
> OR
>
> {\'Error\': \'Unauthorized Access\'}
>
> **Successful:**
>
> **{\'Entry\': \'Deleted\'}**
>
> **iPhone \[Handle JSON\] Code:**
>
> **if response.data != nil {**
>
> **do {**
>
> **let json = try JSON(data: response.data!)**
>
> **let name = json\[\"Error\"\].string**
>
> **if name != nil {**
>
> **response\_string = name!**
>
> **}**
>
> **}**
>
> **catch let error as NSError{**
>
> ***//error***
>
> **}**
>
> **}**
>
> **if response\_string != \"Unauthorized Access\" && response\_string
> != \"Name not passed for deletion\"{**
>
> **self.tblFavorites.beginUpdates()**
>
> **self.favoritesArray.remove(at: indexPath.row)**
>
> **self.tblFavorites.deleteRows(at: \[indexPath as IndexPath\], with:
> .fade)**
>
> **self.tblFavorites.endUpdates()**
>
> **}**
>
> **else if response\_string == \"Unauthorized Access\"{**
>
> **tableView.dataSource!.tableView!(tableView, commit: .delete,
> forRowAt: indexPath)**
>
> **}**

3.  **Describe other services your code uses, e.g. local database,
    > external data source, external web services.**

    a.  MySQL Database

    b.  Pi API Pokeapi

    c.  Pi Output Devices (LED's, LCD)

    d.  HTTP API Authentication
