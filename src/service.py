from bottle import template
import src.models as m

class DeckMakerService:
    def __init__(self):
        pass

    def index(self, db):
        try:
            model = (m.Card.get_random(db), m.Card.get_random(db), m.Card.get_random(db))
        except ValueError:
            model = None
        return template('index', model=model)

    def card_index(self):
        return template('card_index')

    def card_random(self, db):
        try:
            return template('card', model=m.FullCard.get_random_card(db), binders=m.Binder.get_all(db))
        except ValueError:
            return template('card_404')

    def card(self, db, item):
        try:
            return template('card', model=m.FullCard.get_by_id(db, item), binders=m.Binder.get_all(db))
        except ValueError:
            return template('card_404')
    
    def card_post(self, db, item, form):
        if form.get("route") == "COLLECTION":
            self.collection_post(db, item, form)
        elif form.get("route") == "BINDERCARD":
            self.binder_card_post(db, form)

    def oracle_card(self, db, item):
        try:
            return template('card', model=m.FullCard.get_by_oracle_id(db, item), binders=m.Binder.get_all(db))
        except ValueError:
            return template('card_404')

    def sets_index(self, db, query):
        try:
            return template('set_index', query=query, model=m.SetList.get_all(db))
        except ValueError:
            return template('card_404')

    def sets_card_list(self, db, query, item):
        try:
            return template('set_cards', query=query, model=m.SetCardList.get_by_set_code(db, item))
        except ValueError:
            return template('card_404')
        
    def collection(self, db, query):
        try:
            return template('collection', query=query, model=m.FullCollection.get_all(db, query))
        except ValueError:
            return template('card_404')
    
    def collection_post(self, db, item, form):
        if form.get('method') == 'DELETE':
            try:
                card = m.Card.get_by_id(db, item)
                m.Collection(card_id=item, oracle_id=card.oracle_id).delete(db)
            except ValueError:
                print('ERROR - - Invalid card id in collection. Failed to delete.')
        else:
            try:
                card = m.Card.get_by_id(db, item)
                m.Collection(data=(item, card.oracle_id, form.get('quantity'))).save(db)
            except ValueError:
                print('ERROR - - Invalid card id in collection. Failed to save')
    
    def binders_index(self, db, query):
        return template('binders_index', query=query, model=m.BinderSearch.get_all(db, query))
    
    def binders(self, db, query, item):
        try:
            return template('binders', query=query, model=m.FullBinder.get_by_id(db, item))
        except ValueError:
            return template('card_404')

    def binders_post(self, db, form, item=None):
        if form.get("route") == "BINDER":
            self.binder_post(db, form, item=item)
        elif form.get("route") == "BINDERCARD":
            self.binder_card_post(db, form)
        else:
            print('ERROR - - Unknown binder post route.')

    def binder_post(self, db, form, item=None):
        if form.get('method') == 'CREATE':
            try:
                data = (None, form.get('name'), None, None, int(form.get('general')))
                m.Binder(data=data).save(db)
            except ValueError:
                print('ERROR - - Invalid binder name already exits. Failed to create')
        elif form.get('method') == 'UPDATE':
            try:
                data = (item, form.get('name'), None, None, int(form.get('general')))
                m.Binder(data=data).save(db)
            except ValueError:
                print('ERROR - - Invalid binder name already exits. Failed to update')
        elif form.get('method') == 'DELETE':
            try:
                data= (item, None, None, None, None)
                m.Binder(data=data).delete(db)
            except ValueError:
                print('ERROR - - Invalid binder id. Failed to delete')
        else:
            print('ERROR - - Unknown binder operation.')
    
    def binder_card_post(self, db, form):
        if form.get('method') == 'DELETE':
            try:
                card = m.Card.get_by_id(db, form.get('card_id'))
                data = (card, None, 0, 0, int(form.get('binder_id')))
                m.BinderCard(data=data).delete(db)
            except ValueError:
                print('ERROR - - Invalid binder card id. Failed to delete.')
        else:
            try:
                card = m.Card.get_by_id(db, form.get('card_id'))
                if form.get('cover') != None:
                    cover = int(form.get('cover'))
                else:
                    try:
                        b = m.BinderCard.get_by_id(db, form.get('card_id'), int(form.get('binder_id')))
                        cover = b.cover
                    except ValueError:
                        cover = 0
                data = (card, None, int(form.get('quantity')), cover, int(form.get('binder_id')))
                m.BinderCard(data=data).save(db)
            except ValueError:
                print('ERROR - - Invalid binder card id. Failed to save')

    def decks_index(self, db, query):
        return template('decks_index', query=query, model=m.DeckSearch.get_all(db, query))
    
    def decks(self, db, query, item):
        try:
            return template('decks', query=query, model=m.FullDeck.get_by_id(db, item))
        except ValueError:
            return template('card_404')

    def decks_create(self):
        try:
            return template('decks_edit', method="CREATE", model=m.Deck.get_empty())
        except ValueError:
            return template('card_404')
    
    def decks_edit(self, db, item):
        try:
            return template('decks_edit', method="UPDATE", model=m.Deck.get_by_id(db, item))
        except ValueError:
            return template('card_404')
    
    def decks_post(self, db, form, item=None):
        if form.get('method') == 'CREATE':
            data = (None, form.get("name"), None, None, form.get("maindeck"), form.get("sideboard"), form.get("format"), form.get("commander"), form.get("partner"), form.get("companion"), 0)
            m.FullDeck.get_by_deck(db, m.Deck(data=data)).deck.save(db)
        elif form.get('method') == 'UPDATE':
            data = (item, form.get("name"), None, None, form.get("maindeck"), form.get("sideboard"), form.get("format"), form.get("commander"), form.get("partner"), form.get("companion"), 0)
            m.FullDeck.get_by_deck(db, m.Deck(data=data)).deck.save(db)
        elif form.get('method') == 'DELETE':
            data= (item, None, None, None, None, None, None, None, None, None, None)
            m.Deck(data=data).delete(db)
        else:
            print('ERROR - - Unknown deck operation.')

    def search(self, db, query):
        try:
            return template('search', query=query, model=m.CardSearch.get_by_query(db, query), binders=m.Binder.get_all(db))
        except ValueError:
            return template('card_404')
    
    def search_post(self, db, query, form):
        try:
            cards = m.Card.get_by_query(db, query)
            if form.get("route") == "COLLECTION":
                for card in cards:
                    try:
                        coll = m.Collection.get_by_id(db, card.id, card.oracle_id)
                        if coll.quantity == 0:
                            coll.quantity = form.get("quantity") or 0
                            coll.save(db)
                    except ValueError:
                        print('Error - - Bulk search addition failed to save collection card.')
            elif form.get("route") == "BINDER":
                for card in cards:
                    try:
                        try:
                            b = m.BinderCard.get_by_id(db, card.id, int(form.get('binder_id')))
                        except ValueError:
                            data = (card, None, int(form.get('quantity')), 0, int(form.get('binder_id')))
                            m.BinderCard(data=data).save(db)
                    except ValueError:
                        print('Error - - Bulk search addition failed to save binder card.')
            else:
                raise ValueError
        except ValueError:
            print('Error - - Bulk search addition failed to complete.')

    def advanced_search(self, db):
        try:
            return template('advanced_search', model=m.SetList.get_all(db))
        except ValueError:
            return template('card_404')

    def card_autocomplete(self, db, json):
        data = m.OracleCard.autocomplete_name(db, json.get('term'))
        return {'data' : data}