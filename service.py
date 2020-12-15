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
    
    def card_post(self, db, item, quantity):
        m.Collection(data=(item, quantity)).save(db)

    def oracle_card(self, db, item):
        try:
            return template('card', model=m.FullCard.get_by_oracle_id(db, item))
        except (ValueError):
            return template('card_404')
        
    def sets_index(self, db, order=None, set_type=None, name=None):
        try:
            return template('set_index', model=m.SetList.get_all(db), order=order, set_type=set_type, name=name)
        except (ValueError):
            return template('card_404')

    def sets_card_list(self, db, item):
        try:
            return template('set_cards', model=m.SetCardList.get_by_set_code(db, item))
        except (ValueError):
            return template('card_404')
        
    def collection(self):
        return template('index')

    def decks(self):
        return template('index')

    def search(self, db, query):
        return template('search', query=query, model=m.Card.get_by_query(db, query))