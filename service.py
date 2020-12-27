from bottle import template
from datetime import datetime
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
        
    def sets_index(self, db, query):
        try:
            return template('set_index', query=query, model=m.SetList.get_all(db))
        except (ValueError):
            return template('card_404')

    def sets_card_list(self, db, query, item):
        try:
            return template('set_cards', query=query, model=m.SetCardList.get_by_set_code(db, item))
        except (ValueError):
            return template('card_404')
        
    def collection(self, db, query):
        try:
            return template('collection', query=query, model=m.FullCollection.get_all(db, query))
        except (ValueError):
            return template('card_404')
    
    def collection_post(self, db, item, form):
        if (form.get('method') == 'DELETE'):
            m.Collection(card_id=item).delete(db)
        else:
            m.Collection(data=(item, form.get('quantity'))).save(db)

    def decks(self):
        return template('index')
    
    def decks_save(self, db, form):
        data = (None, form.get("name"), str(datetime.now()), None, form.get("maindeck"), form.get("sideboard"), form.get("format"), form.get("commander"), form.get("partner"), form.get("companion"), 0)
        m.Deck(data=data).save(db)

    def search(self, db, query):
        return template('search', query=query, model=m.CardSearch.get_by_query(db, query))

    def card_autocomplete(self, db, json):
        data = m.OracleCard.autocomplete_name(db, json.get('term'))
        return {'data' : data}