from bottle import template

class DeckMakerService:
    def __init__(self):
        pass

    def index(self):
        return template('index')

    def cards(self):
        return template('index')

    def collection(self):
        return template('index')

    def decks(self):
        return template('index')