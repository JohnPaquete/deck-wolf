from bottle import Bottle, run, template, static_file, request, redirect
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
    return DeckMakerService().card_index()
    
@app.route('/cards/random')
@app.route('/cards/random/')
def card_random(db):
    return DeckMakerService().card_random(db)

@app.route('/cards/:item')
def card(item, db):
    return DeckMakerService().card(db, item)

@app.route('/cards/:item', method='POST')
def card_post(item, db):
    DeckMakerService().collection_post(db, item, request.forms)
    redirect(f"/cards/{item}")

@app.route('/cards/oracle/:item')
def oracle_card(item, db):
    return DeckMakerService().oracle_card(db, item)

@app.route('/sets')
@app.route('/sets/')
def sets_index(db):
    return DeckMakerService().sets_index(db, request.query)

@app.route('/sets/:item')
def sets_card_list(item, db):
    return DeckMakerService().sets_card_list(db, request.query, item)

@app.route('/collection')
@app.route('/collection/')
def collection(db):
    return DeckMakerService().collection(db, request.query)

@app.route('/collection/:item', method='POST')
def collection_post(item, db):
    DeckMakerService().collection_post(db, item, request.forms)
    redirect("/collection")

@app.route('/decks')
@app.route('/decks/')
def decks():
    return template('decks_index')

@app.route('/decks/create')
@app.route('/decks/create/')
def decks_create():
    return template('decks_edit')

@app.route('/search')
@app.route('/search/')
def search(db):
    return DeckMakerService().search(db, request.query)

@app.route('/assets/<filepath:path>')
def asset(filepath):
    return static_file(filepath, root='./assets')

if __name__ == "__main__":
    Schema()
    run(app, host='localhost', port=8080, debug=True, reloader=False)