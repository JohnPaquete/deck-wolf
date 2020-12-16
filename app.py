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
    quantity = request.forms.get('quantity')
    DeckMakerService().card_post(db, item, quantity)
    redirect(f"/cards/{item}")

@app.route('/cards/oracle/:item')
def oracle_card(item, db):
    return DeckMakerService().oracle_card(db, item)

@app.route('/sets')
@app.route('/sets/')
def sets_index(db):
    order_query = request.query.order or None
    type_query = request.query.type or None
    name_query = request.query.name or None
    return DeckMakerService().sets_index(db, order=order_query, set_type=type_query, name=name_query)

@app.route('/sets/:item')
def sets_card_list(item, db):
    return DeckMakerService().sets_card_list(db, request.query, item)

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
def search(db):
    return DeckMakerService().search(db, request.query)

@app.route('/assets/<filepath:path>')
def asset(filepath):
    return static_file(filepath, root='./assets')

if __name__ == "__main__":
    Schema()
    run(app, host='localhost', port=8080, debug=True, reloader=False)