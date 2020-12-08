from bottle import template
import models as m

class DeckMakerService:
    def __init__(self):
        pass

    def index(self):
        return template('index')

    def card_index(self):
        return template('card_index')

    def card_random(self, db):
        try:
            return template('card', model=m.FullCard.get_random_card(db))
        except (ValueError):
            return template('card_404')

    def card(self, db, item):
        try:
            return template('card', model=m.FullCard.get_by_id(db, item))
        except (ValueError):
            return template('card_404')

    def oracle_card(self, db, item):
        try:
            return template('card', model=m.FullCard.get_by_oracle_id(db, item))
        except (ValueError):
            return template('card_404')
        
    def sets_index(self, db):
        return template('index')
        
    def collection(self):
        return template('index')

    def decks(self):
        return template('index')