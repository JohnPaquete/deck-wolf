from bottle import Bottle, run, template, static_file, request, redirect
from src.bottle_sqlite import SQLitePlugin
from src.models import Schema
from src.service import DeckMakerService

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
    DeckMakerService().card_post(db, item, request.forms)
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

# Binders index page
@app.route('/collection/binders')
@app.route('/collection/binders/')
def binders_index(db):
    return DeckMakerService().binders_index(db, request.query)

# Binder delete and edit by id
@app.route('/collection/binders', method='POST')
@app.route('/collection/binders/', method='POST')
def binders_delete(db):
    DeckMakerService().binders_post(db, request.forms)
    redirect("/collection/binders/")

# Binder view page by id
@app.route('/collection/binders/:item')
@app.route('/collection/binders/:item/')
def binders(db, item):
    return DeckMakerService().binders(db, request.query, item)

# Binder delete and edit by id
@app.route('/collection/binders/:item', method='POST')
@app.route('/collection/binders/:item/', method='POST')
def binders_delete(db, item):
    DeckMakerService().binders_post(db, request.forms, item=item)
    redirect("/collection/binders/")

# Deck index page
@app.route('/decks')
@app.route('/decks/')
def decks(db):
    return DeckMakerService().decks_index(db, request.query)

# Deck creation form page
@app.route('/decks/create')
@app.route('/decks/create/')
def decks_create():
    return DeckMakerService().decks_create()

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
    return DeckMakerService().decks_edit(db, item)

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
    return DeckMakerService().decks(db, request.query, item)

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

# 404 page
@app.error(404)
@app.error(405)
def error404(error):
    return template('card_404')

if __name__ == "__main__":
    Schema()
    run(app, host='localhost', port=8080, debug=True, reloader=False)