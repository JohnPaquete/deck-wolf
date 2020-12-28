from bottle import Bottle, run, template, static_file, request, redirect
from bottle_sqlite import SQLitePlugin
from models import Schema
from service import DeckMakerService

app = Bottle()
sqlite_plugin = SQLitePlugin(dbfile='data/test.db')
app.install(sqlite_plugin)

# The home page
@app.route('/')
def index():
    return DeckMakerService().index()

# Card index page
@app.route('/cards')
@app.route('/cards/')
def card_index():
    return DeckMakerService().card_index()

# Random card page
@app.route('/cards/random')
@app.route('/cards/random/')
def card_random(db):
    return DeckMakerService().card_random(db)

# Card page by id
@app.route('/cards/:item')
def card(item, db):
    return DeckMakerService().card(db, item)

# Posting of the collection form on card pages
@app.route('/cards/:item', method='POST')
def card_post(item, db):
    DeckMakerService().collection_post(db, item, request.forms)
    redirect(f"/cards/{item}")

# Card page by oracle id
@app.route('/cards/oracle/:item')
def oracle_card(item, db):
    return DeckMakerService().oracle_card(db, item)

# Sets index page
@app.route('/sets')
@app.route('/sets/')
def sets_index(db):
    return DeckMakerService().sets_index(db, request.query)

# Sets card list page by set code
@app.route('/sets/:item')
def sets_card_list(item, db):
    return DeckMakerService().sets_card_list(db, request.query, item)

# Collection index page
@app.route('/collection')
@app.route('/collection/')
def collection(db):
    return DeckMakerService().collection(db, request.query)

# Collection post from collection index
@app.route('/collection/:item', method='POST')
def collection_post(item, db):
    DeckMakerService().collection_post(db, item, request.forms)
    redirect("/collection")

# Deck index page
@app.route('/decks')
@app.route('/decks/')
def decks(db):
    return DeckMakerService().decks(db, request.query)

# Deck creation form page
@app.route('/decks/create')
@app.route('/decks/create/')
def decks_create():
    return template('decks_edit')

# Deck creation form post
@app.route('/decks/create', method='POST')
@app.route('/decks/create/', method='POST')
def decks_create_post(db):
    DeckMakerService().decks_post(db, request.forms)
    redirect("/decks")

# Deck edit form by id
@app.route('/decks/edit/:item')
@app.route('/decks/edit/:item/')
def decks_edit(db, item):
    return template('index')

# Deck edit form post
@app.route('/decks/edit/:item', method='POST')
@app.route('/decks/edit/:item/', method='POST')
def decks_edit_post(db, item):
    DeckMakerService().decks_post(db, request.forms, item=item)
    redirect(f"/decks/{item}")

# Deck view page by id
@app.route('/decks/:item')
@app.route('/decks/:item/')
def decks_view(db, item):
    return template('index')

# Deck delete by id
@app.route('/decks/:item', method='POST')
@app.route('/decks/:item/', method='POST')
def decks_delete(db, item):
    DeckMakerService().decks_post(db, request.forms, item=item)
    redirect("/decks/")

# Search index page
@app.route('/search')
@app.route('/search/')
def search(db):
    return DeckMakerService().search(db, request.query)

# Static file for assets
@app.route('/assets/<filepath:path>')
def asset(filepath):
    return static_file(filepath, root='./assets')

# Endpoint for card autocomplete
@app.route('/api/card_autocomplete/', method='POST')
@app.route('/api/card_autocomplete',  method='POST')
def card_autocomplete(db):
    return DeckMakerService().card_autocomplete(db, request.json)

if __name__ == "__main__":
    Schema()
    run(app, host='localhost', port=8080, debug=True, reloader=False)