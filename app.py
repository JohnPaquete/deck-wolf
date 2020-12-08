from bottle import Bottle, run, template, static_file
from bottle_sqlite import SQLitePlugin
from models import Schema
from service import DeckMakerService

app = Bottle()
sqlite_plugin = SQLitePlugin(dbfile='data/test.db')
app.install(sqlite_plugin)

@app.route('/')
def index():
    return DeckMakerService().index()

@app.route('/cards')
@app.route('/cards/')
def card_index():
    return template('index')

@app.route('/cards/:item')
def card(item, db):
    return DeckMakerService().card(db, item)

@app.route('/cards/oracle/:item')
def oracle_card(item, db):
    return DeckMakerService().oracle_card(db, item)

@app.route('/collection')
@app.route('/collection/')
def collection():
    return template('index')

@app.route('/decks')
@app.route('/decks/')
def decks():
    return template('index')

@app.route('/search')
@app.route('/search/')
def search():
    return template('index')

@app.route('/assets/<filepath:path>')
def asset(filepath):
    return static_file(filepath, root='./assets')

if __name__ == "__main__":
    Schema()
    run(app, host='localhost', port=8080, debug=True, reloader=False)