from app import app
import sys
sys.path.insert(0, '/home/pi/api-service/app')
import lcd
import requests, time
import RPi.GPIO as GPIO
GPIO.setmode(GPIO.BCM)
GPIO.setwarnings(False)
GPIO.setup(14,GPIO.OUT)
GPIO.setup(15,GPIO.OUT)
GPIO.setup(18,GPIO.OUT)
from flask import Flask, jsonify, abort, make_response, request, url_for
from flask_httpauth import HTTPBasicAuth
from flask_sqlalchemy import SQLAlchemy, inspect
auth = HTTPBasicAuth()


app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['SECRET_KEY'] = 'mysecret'
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+pymysql://wad11656:cristonala321@127.0.0.1/pokemon'
db = SQLAlchemy(app)

num_unauth = 0

def error_light():
    for x in range(3):
        GPIO.output(14,GPIO.HIGH)
        time.sleep(.06)
        GPIO.output(14,GPIO.LOW)
        time.sleep(.06)
    GPIO.output(14,GPIO.HIGH)
    time.sleep(1)
    GPIO.output(14,GPIO.LOW)

def processing_light():
    for x in range(3):
        GPIO.output(15,GPIO.HIGH)
        time.sleep(.06)
        GPIO.output(15,GPIO.LOW)
        time.sleep(.06)
    GPIO.output(15,GPIO.HIGH)

def success_light():
    GPIO.output(15,GPIO.LOW)
    GPIO.output(18,GPIO.HIGH)
    time.sleep(1)
    GPIO.output(18,GPIO.LOW)


class Favs_table(db.Model):
    __tablename__ = 'favs_table'
    id = db.Column('id', db.Integer, primary_key=True)
    Name = db.Column('Name', db.Unicode)
    Poketype = db.Column('Poketype', db.Unicode)
    def toDict(self):
        return { c.key: getattr(self, c.key) for c in inspect(self).mapper.column_attrs }

    def __init__(self, id, Name, Poketype):
        self.id = id
        self.Name = Name
        self.Poketype = Poketype

@app.route('/poketype', methods=['GET'])
def get_poketype():
    # Example: curl -i 'http://localhost:5000/poketype?Poketype=shadow'
    poketype_arg = request.args.get('Poketype', None)
    pokeapi_entry = ""
    if poketype_arg == None:
        error_light()
        print("GET error light 1")
        lcd.lcd_init()
        lcd.lcd_string("Invalid Find",2)
        pokeapi_entry = jsonify({'Pokeapi_Type': 'Not Found'})
    elif poketype_arg not in ['normal', 'fighting', 'poison', 'flying', 'ground', 'bug', 'ghost', 'steel', 'fire', 'rock', 'water', 'grass', 'electric', 'psychic', 'ice', 'dragon', 'dark', 'fairy', 'unknown', 'shadow']:
        error_light()
        print("GET error light 2")
        lcd.lcd_init()
        lcd.lcd_string("Invalid Find",128)
        
        pokeapi_entry = jsonify({'Pokeapi_Type': 'Not Found'})
    else:
        processing_light()
        pokeapi_url = "https://pokeapi.co/api/v2/type/" + poketype_arg + "/"
        print(pokeapi_url)
        pokeapi_entry = jsonify(requests.get(pokeapi_url).json())
        lcd.lcd_init()
        lcd.lcd_string("Success!",2)
        success_light()
    return pokeapi_entry

@app.route('/favs', methods=['GET'])
def get_table():
    # Example: curl -i 'http://localhost:5000/favs?Poketype=shadow'
    fav_arg = request.args.get('Poketype', None)
    favsArr = []
    if fav_arg == None:
        error_light()
        print("GET /favs error light 1")
        lcd.lcd_init()
        lcd.lcd_string("Invalid Type",2)
        return jsonify({'Error': 'Invalid Type Passed in favs GET'})
    elif fav_arg not in ['normal', 'fighting', 'poison', 'flying', 'ground', 'bug', 'ghost', 'steel', 'fire', 'rock', 'water', 'grass', 'electric', 'psychic', 'ice', 'dragon', 'dark', 'fairy', 'unknown', 'shadow']:
        error_light()
        print("GET /favs error light 2")
        lcd.lcd_init()
        lcd.lcd_string("Invalid Type",2)
        return jsonify({'Error': 'Invalid Type Passed in favs GET'})
    else:
        processing_light()
        favs = db.session.query(Favs_table).filter_by(Poketype = fav_arg)
        for fav in favs:
            favsArr.append(fav.toDict())
        success_light()
        lcd.lcd_init()
        lcd.lcd_string("Success!",2)
        print(jsonify(favsArr))
        return jsonify(favsArr)

@app.route('/favs', methods=['POST'])
@auth.login_required
def add_fav():
    # Example: curl -u pikachu:electric -i -H "Content-Type: application/json" -X POST -d '{"Name":"What", "Poketype":"Whatsapp5"}' http://localhost:5000/favs
    global num_unauth
    if not request.json or not 'Name' in request.json or not 'Poketype' in request.json:
        error_light()
        print("POST error light 1")
        print("either Name or Poketype not in request light")
        lcd.lcd_init()
        lcd.lcd_string("Input Invalid",2)
        num_unauth = 0
        abort(400)
    entry = ""
    if db.session.query(Favs_table).filter_by(Name = request.json['Name'], Poketype = request.json['Poketype']).first():
        error_light()
        print("POST error light 2")
        print("entry already exists light")
        new_fav_json = {'Error': 'Entry Already Exists'}
        lcd.lcd_init()
        lcd.lcd_string("Entry Exists",2)
        entry = jsonify(new_fav_json)
        num_unauth = 0
    else:
        processing_light()
        new_fav_json = {
            'Name': request.json['Name'],
            'Poketype': request.json['Poketype']
        }
        new_fav = Favs_table(0, request.json['Name'], request.json['Poketype'])
        print(new_fav)
        db.session.add(new_fav)
        db.session.commit()
        entry = jsonify({'New Entry': new_fav_json})
        print("global num_unauth suc =" + str(num_unauth))
        success_light()
        lcd.lcd_init()
        lcd.lcd_string("Success!",2)
        num_unauth = 0
    return entry, 201

@app.route('/favs/delete', methods=['DELETE'])
@auth.login_required
def delete_fav():
    global num_unauth
    # Example: curl -u pikachu:electric -X DELETE 'http://localhost:5000/favs/delete?Name=What&Poketype=Whatsapp3'
    print("delete called")
    name_del = request.args.get('Name', None)
    type_del = request.args.get('Poketype', None)
    if name_del == None:
        error_light()
        num_unauth = 0
        lcd.lcd_init()
        lcd.lcd_string("Bad Name passed",2)
        return jsonify({'Error': 'Name not passed for deletion'})
    elif type_del == None:
        error_light()
        num_unauth = 0
        lcd.lcd_init()
        lcd.lcd_string("Bad Type passed",2)
        return jsonify({'Error': 'Type not passed for deletion'})
    elif db.session.query(Favs_table).filter_by(Name = name_del, Poketype = type_del).first():
        processing_light()
        db.session.query(Favs_table).filter_by(Name = name_del, Poketype = type_del).delete()
        db.session.commit()
        success_light()
        lcd.lcd_init()
        lcd.lcd_string("Success!",2)
        num_unauth = 0
        return jsonify({'Entry': 'Deleted'})
    else:
        error_light()
        num_unauth = 0
        lcd.lcd_init()
        lcd.lcd_string("Can't find entry",2)
        return jsonify({'Entry': 'Not Found'})

@app.errorhandler(404)
def not_found(error):
    error_light()
    print("errorhandler light")
    lcd.lcd_init()
    lcd.lcd_string("Can't find entry",2)
    return make_response(jsonify({'Error': 'Not Found'}), 404)

@auth.get_password
def get_password(username):
    if username == 'pikachu':
        return 'electric'
    return None

@auth.error_handler
def unauthorized():
    global num_unauth
    print("global num_unauth eh =" + str(num_unauth))
    if num_unauth >= 2:
        error_light()
        lcd.lcd_init()
        lcd.lcd_string("Can't Access!",2)
        print("unauthorized light")
        num_unauth = 0
    else:
        num_unauth += 1
        lcd.lcd_init()
        lcd.lcd_string("Can't Access!",2)
    return make_response(jsonify({'Error': 'Unauthorized Access'}), 401)

if __name__ == '__main__':
    app.run(debug=True)