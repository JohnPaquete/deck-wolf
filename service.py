from bottle import template
import models as m

class DeckMakerService:
    def __init__(self):
        pass

    def index(self):
        return template('index')

    def card_index(self, db):
        return template('index')

    def oracle_card(self, db, item):
        try:
            return template('card', model=m.FullCard.get_by_oracle_id(db, item))
        except (ValueError):
            return template('card_404')
            

    def collection(self):
        return template('index')

    def decks(self):
        return template('index')