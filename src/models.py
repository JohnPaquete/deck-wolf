import sqlite3
import requests
import ast
import json
from datetime import datetime


class Schema:
    def __init__(self):
        self.conn = sqlite3.connect('data/test.db')
        self.cursor = self.conn.cursor()
        self.create_tables()
        self.populate_tables()

    def __del__(self):
        self.conn.commit()
        self.conn.close()

    def create_tables(self):
        self.create_record_table()
        self.create_sets_table()
        self.create_oracle_cards_table()
        self.create_cards_table()
        self.create_rulings_table()
        self.create_collection_table()
        self.create_decks_table()
        self.create_binders_table()
        self.create_binder_cards_table()

    def create_record_table(self):
        query = """CREATE TABLE IF NOT EXISTS records (
                  name TEXT NOT NULL UNIQUE,
                  updated TEXT
                );
                """
        self.cursor.execute(query)

    def create_sets_table(self):
        query = """
        CREATE TABLE IF NOT EXISTS sets (
          id INTEGER PRIMARY KEY,
          code TEXT NOT NULL UNIQUE,
          name TEXT NOT NULL,
          search_uri TEXT NOT NULL,
          released TEXT,
          set_type TEXT NOT NULL,
          card_count INTEGER NOT NULL,
          parent_set_code TEXT,
          icon_svg_uri TEXT NOT NULL
        );
        """
        self.cursor.execute(query)
        query= "INSERT OR IGNORE INTO records (name) VALUES ('sets')"
        self.cursor.execute(query)

    def create_oracle_cards_table(self):
        query = """
        CREATE TABLE IF NOT EXISTS oracle_cards (
          oracle_id TEXT PRIMARY KEY,
          id TEXT,
          name TEXT NOT NULL,
          released TEXT NOT NULL,
          uri TEXT NOT NULL,
          scryfall_uri TEXT NOT NULL,
          rulings_uri TEXT NOT NULL,
          image_uris JSON,
          mana_cost TEXT,
          cmc REAL NOT NULL,
          type_line TEXT NOT NULL,
          oracle_text TEXT,
          color_identity TEXT NOT NULL,
          power TEXT,
          toughness TEXT,
          loyalty TEXT,
          keywords TEXT NOT NULL,
          legalities JSON NOT NULL,
          rarity TEXT NOT NULL,
          flavor_name TEXT,
          flavor_text TEXT,
          artist TEXT,
          set_code TEXT NOT NULL,
          set_name TEXT NOT NULL,
          set_type TEXT NOT NULL,
          set_uri TEXT NOT NULL,
          collector_number TEXT NOT NULL,
          prices JSON NOT NULL,
          faces JSON
        );
        """
        self.cursor.execute(query)
        query= "INSERT OR IGNORE INTO records (name) VALUES ('oracle_cards')"
        self.cursor.execute(query)

    def create_cards_table(self):
        query = """
        CREATE TABLE IF NOT EXISTS cards (
          oracle_id TEXT,
          id TEXT PRIMARY KEY,
          name TEXT NOT NULL,
          released TEXT NOT NULL,
          uri TEXT NOT NULL,
          scryfall_uri TEXT NOT NULL,
          rulings_uri TEXT NOT NULL,
          image_uris JSON,
          mana_cost TEXT,
          cmc REAL NOT NULL,
          type_line TEXT NOT NULL,
          oracle_text TEXT,
          color_identity TEXT NOT NULL,
          power TEXT,
          toughness TEXT,
          loyalty TEXT,
          keywords TEXT NOT NULL,
          legalities JSON NOT NULL,
          rarity TEXT NOT NULL,
          flavor_name TEXT,
          flavor_text TEXT,
          artist TEXT,
          set_code TEXT NOT NULL,
          set_name TEXT NOT NULL,
          set_type TEXT NOT NULL,
          set_uri TEXT NOT NULL,
          collector_number TEXT NOT NULL,
          prices JSON NOT NULL,
          faces JSON
        );
        """
        self.cursor.execute(query)
        query= "INSERT OR IGNORE INTO records (name) VALUES ('cards')"
        self.cursor.execute(query)

    def create_rulings_table(self):
        query = """CREATE TABLE IF NOT EXISTS rulings (
                  oracle_id TEXT NOT NULL,
                  source TEXT NOT NULL,
                  published_at TEXT NOT NULL,
                  comment TEXT NOT NULL
                );
                """
        self.cursor.execute(query)
        query= "INSERT OR IGNORE INTO records (name) VALUES ('rulings')"
        self.cursor.execute(query)

    def create_collection_table(self):
        query = """CREATE TABLE IF NOT EXISTS collection (
                  id TEXT PRIMARY KEY NOT NULL,
                  oracle_id TEXT,
                  quantity INTEGER NOT NULL
                );
                """
        self.cursor.execute(query)

    def create_decks_table(self):
        query = """CREATE TABLE IF NOT EXISTS decks (
                  id INTEGER PRIMARY KEY,
                  name TEXT NOT NULL,
                  created TEXT,
                  updated TEXT,
                  maindeck TEXT,
                  sideboard TEXT,
                  format TEXT NOT NULL,
                  commander TEXT,
                  partner TEXT,
                  companion TEXT,
                  valid INTEGER NOT NULL
                );
                """
        self.cursor.execute(query)

    def create_binders_table(self):
        query = """CREATE TABLE IF NOT EXISTS binders (
                  id INTEGER PRIMARY KEY,
                  name TEXT NOT NULL UNIQUE,
                  created TEXT,
                  updated TEXT,
                  general INTEGER NOT NULL
                );
                """
        self.cursor.execute(query)
    
    def create_binder_cards_table(self):
        query = """CREATE TABLE IF NOT EXISTS binder_cards (
                  id TEXT,
                  oracle_id TEXT,
                  quantity INTEGER NOT NULL,
                  cover INTEGER DEFAULT 0,
                  binder_id INTEGER NOT NULL,
                  FOREIGN KEY (binder_id)
                    REFERENCES binders (id)
                      ON UPDATE CASCADE
                      ON DELETE CASCADE,
                  PRIMARY KEY (id, binder_id)
                );
                """
        self.cursor.execute(query)

    def populate_tables(self):
        self.populate_sets_table()
        self.populate_oracle_cards_table()
        self.populate_cards_table()
        self.populate_rulings_table()

    def populate_sets_table(self):
        if self.table_needs_update("sets") is not True:
            return
        print("Getting set list from Scryfall...")
        query = "DELETE FROM sets;"
        self.cursor.execute(query)
        response = requests.get("https://api.scryfall.com/sets")
        if self.validate_request(response):
            print("Importing set list...")
            for s in response.json().get("data"):
                query = f'INSERT INTO sets ' \
                        f'(code, name, search_uri, released, set_type, card_count, parent_set_code, icon_svg_uri) ' \
                        f'VALUES ({val(s.get("code"))}, {val(s.get("name"))}, {val(s.get("search_uri"))}, {val(s.get("released_at"))}, {val(s.get("set_type"))}, {s.get("card_count")}, {val(s.get("parent_set_code"))}, {val(s.get("icon_svg_uri"))});'
                self.cursor.execute(query)

            date = datetime.now()
            query = f"UPDATE records SET updated = '{date}' WHERE name = 'sets';"
            self.cursor.execute(query)

    def populate_oracle_cards_table(self):
        if self.table_needs_update("oracle_cards") is not True:
            return
        print("Getting oracle cards from Scryfall...")
        query = "DELETE FROM oracle_cards;"
        self.cursor.execute(query)
        response = requests.get("https://api.scryfall.com/bulk-data/oracle-cards")
        if self.validate_request(response):
            response = requests.get(response.json().get("download_uri"))
        else:
            return
        if self.validate_request(response):
            print("Importing oracle cards...")
            for c in response.json():
                query = f'INSERT OR IGNORE INTO oracle_cards ' \
                        f'(oracle_id, id, name, released, uri, scryfall_uri, rulings_uri, image_uris, mana_cost, cmc, type_line, oracle_text, color_identity, power, toughness, loyalty, keywords, legalities, rarity, flavor_name, flavor_text, artist, set_code, set_name, set_type, set_uri, collector_number, prices, faces) ' \
                        f'VALUES ({val(c.get("oracle_id"))}, {val(c.get("id"))}, {val(c.get("name"))}, {val(c.get("released_at"))}, {val(c.get("uri"))}, {val(c.get("scryfall_uri"))}, {val(c.get("rulings_uri"))}, ?, ' \
                        f'{val(c.get("mana_cost"))}, {c.get("cmc")}, {val(c.get("type_line"))}, {val(c.get("oracle_text"))}, {val(c.get("color_identity"))}, {val(c.get("power"))}, {val(c.get("toughness"))}, {val(c.get("loyalty"))}, ' \
                        f'{val(c.get("keywords"))}, ?, {val(c.get("rarity"))}, {val(c.get("flavor_name"))}, {val(c.get("flavor_text"))}, {val(c.get("artist"))}, {val(c.get("set"))}, {val(c.get("set_name"))}, {val(c.get("set_type"))}, {val(c.get("set_uri"))}, {val(c.get("collector_number"))}, ?, ?);'
                self.cursor.execute(query, [json.dumps(c.get("image_uris")), json.dumps(c.get("legalities")), json.dumps(c.get("prices")), json.dumps(c.get("card_faces"))])
            date = datetime.now()
            query = f"UPDATE records SET updated = '{date}' WHERE name = 'oracle_cards';"
            self.cursor.execute(query)
            print("Oracle cards imported successfully")

    def populate_cards_table(self):
        if self.table_needs_update("cards") is not True:
            return
        print("Getting cards from Scryfall...")
        query = "DELETE FROM cards;"
        self.cursor.execute(query)
        response = requests.get("https://api.scryfall.com/bulk-data/default-cards")
        if self.validate_request(response):
            response = requests.get(response.json().get("download_uri"))
        else:
            return
        if self.validate_request(response):
            print("Importing cards...")
            for c in response.json():
                query = f'INSERT OR IGNORE INTO cards ' \
                        f'(oracle_id, id, name, released, uri, scryfall_uri, rulings_uri, image_uris, mana_cost, cmc, type_line, oracle_text, color_identity, power, toughness, loyalty, keywords, legalities, rarity, flavor_name, flavor_text, artist, set_code, set_name, set_type, set_uri, collector_number, prices, faces) ' \
                        f'VALUES ({val(c.get("oracle_id"))}, {val(c.get("id"))}, {val(c.get("name"))}, {val(c.get("released_at"))}, {val(c.get("uri"))}, {val(c.get("scryfall_uri"))}, {val(c.get("rulings_uri"))}, ?, ' \
                        f'{val(c.get("mana_cost"))}, {c.get("cmc")}, {val(c.get("type_line"))}, {val(c.get("oracle_text"))}, {val(c.get("color_identity"))}, {val(c.get("power"))}, {val(c.get("toughness"))}, {val(c.get("loyalty"))}, ' \
                        f'{val(c.get("keywords"))}, ?, {val(c.get("rarity"))}, {val(c.get("flavor_name"))}, {val(c.get("flavor_text"))}, {val(c.get("artist"))}, {val(c.get("set"))}, {val(c.get("set_name"))}, {val(c.get("set_type"))}, {val(c.get("set_uri"))}, {val(c.get("collector_number"))}, ?, ?);'
                self.cursor.execute(query, [json.dumps(c.get("image_uris")), json.dumps(c.get("legalities")), json.dumps(c.get("prices")), json.dumps(c.get("card_faces"))])
            date = datetime.now()
            query = f"UPDATE records SET updated = '{date}' WHERE name = 'cards';"
            self.cursor.execute(query)
            print("Cards imported successfully")
    
    def populate_rulings_table(self):
        if self.table_needs_update("rulings") is not True:
            return
        print("Getting rulings from Scryfall...")
        query = "DELETE FROM rulings;"
        self.cursor.execute(query)
        response = requests.get("https://api.scryfall.com/bulk-data/rulings")
        if self.validate_request(response):
            response = requests.get(response.json().get("download_uri"))
        else:
            return
        if self.validate_request(response):
            print("Importing rulings...")
            for r in response.json():
                query = f'INSERT INTO rulings ' \
                        f'(oracle_id, source, published_at, comment) ' \
                        f'VALUES ({val(r.get("oracle_id"))}, {val(r.get("source"))}, {val(r.get("published_at"))}, {val(r.get("comment"))})'
                self.cursor.execute(query)
            date = datetime.now()
            query = f"UPDATE records SET updated = '{date}' WHERE name = 'rulings';"
            self.cursor.execute(query)
            print("Rulings imported successfully")

    def table_needs_update(self, table):
        query = f"SELECT updated FROM records WHERE name = '{table}';"
        self.cursor.execute(query)
        row = self.cursor.fetchone()
        if row is not None and row[0] is not None:
            current_time = datetime.now()
            update_time = datetime.strptime(row[0], '%Y-%m-%d %H:%M:%S.%f')
            diff = current_time - update_time
            if diff.days >= 1:
                return True
            return False
        return True

    def validate_request(self, request):
        if request.status_code == 200:
            print("Scryfall request returned status code 200: SUCCESS")
            return True
        print("Scryfall request returned status code" + str(request.status_code) + ": FAILURE")
        print(request.json().get("details"))
        return False

class Card:
    def __init__(self, data=None):
        if data is not None:
            self.oracle_id = data[0]
            self.id = data[1]
            self.name = data[2]
            self.released = data[3]
            self.uri = data[4]
            self.scryfall_uri = data[5]
            self.rulings_uri = data[6]
            self.image_uris = json.loads(data[7])
            if self.image_uris is None:
                self.image_uris = {}
            self.mana_cost = data[8]
            self.cmc = data[9]
            self.type_line = data[10]
            self.oracle_text = data[11]
            self.color_identity = data[12]
            self.power = data[13]
            self.toughness = data[14]
            self.loyalty = data[15]
            self.keywords = data[16]
            self.legalities = json.loads(data[17])
            if self.legalities is None:
                self.legalities = {}
            self.rarity = data[18]
            self.flavor_name = data[19]
            self.flavor_text = data[20]
            self.artist = data[21]
            self.set_code = data[22]
            self.set_name = data[23]
            self.set_type = data[24]
            self.set_uri = data[25]
            self.collector_number = data[26]
            self.prices = json.loads(data[27])
            if self.prices is None:
                self.prices = {}
            self.faces = json.loads(data[28])
        else:
            raise ValueError('No match found in database.')
    
    @classmethod
    def get_by_id(cls, db, card_id):
        query = f"SELECT * FROM cards WHERE id = \'{card_id}\';"
        row = db.execute(query).fetchone()
        return cls(data=row)

    @classmethod
    def get_list_by_set_code(cls, db, set_code):
        query = f"SELECT * FROM cards WHERE set_code = \'{set_code}\';"
        rows = db.execute(query).fetchall()
        cards = []
        for c in rows:
            cards.append(cls(data=c))
        return cards

    @classmethod
    def get_random(cls, db):
        query = "SELECT * FROM cards LIMIT 1 OFFSET ABS(RANDOM()) % MAX((SELECT COUNT(*) FROM cards), 1);"
        row = db.execute(query).fetchone()
        return cls(data=row)

    @classmethod
    def get_by_name(cls, db, name):
        query = f"SELECT * FROM cards WHERE name LIKE \"{name}\";"
        row = db.execute(query).fetchone()
        return cls(data=row)

    @classmethod
    def get_by_query(cls, db, q):
        clauses = q.decode()
        query = "SELECT * FROM cards WHERE "
        count = 0
        for key, value in clauses.items():
            if key == 'q':
                if count > 1:
                    query += ", "
                query += f"name like \'%{value}%\'"
                count += 1
        query += " GROUP BY oracle_id HAVING MAX(released);"

        if count <= 0:
            return []
        rows = db.execute(query).fetchall()
        cards = []
        for c in rows:
            cards.append(cls(data=c))
        return cards

class OracleCard(Card):
    def __init__(self, data):
        super().__init__(data=data)
    
    @classmethod
    def get_by_id(cls, db, card_id):
        query = f"SELECT * FROM oracle_cards WHERE oracle_id = \'{card_id}\';"
        row = db.execute(query).fetchone()
        return cls(row)
    
    @classmethod
    def get_by_query(cls, db, q):
        clauses = q.decode()
        query = "SELECT * FROM oracle_cards WHERE "
        count = 0
        for key, value in clauses.items():
            if key == 'q':
                if count > 1:
                    query += ", "
                query += f"name like \"%{value}%\""
                count += 1
        query += ";"

        if count <= 0:
            return []
        rows = db.execute(query).fetchall()
        cards = []
        for c in rows:
            cards.append(cls(data=c))
        return cards
    
    @classmethod
    def get_by_name(cls, db, name):
        query = f"SELECT * FROM oracle_cards WHERE name LIKE \"{name}\";"
        row = db.execute(query).fetchone()
        return cls(row)
    
    @classmethod
    def autocomplete_name(cls, db, term):
        t = str(term)
        if term is None:
            t = ''
        q = f"SELECT name FROM oracle_cards where name like \"{t}%\";"
        rows = db.execute(q).fetchall()
        result = []
        for r in rows:
            result.append(r[0])
        result.sort()
        return result

class Set:
    def __init__(self, data=None):
        if data is not None:
            self.set_id = data[0]
            self.code = data[1]
            self.name = data[2]
            self.search_uri = data[3]
            self.released = data[4]
            self.set_type = data[5]
            self.card_count = data[6]
            self.parent_set_code = data[7]
            self.icon_svg_uri = data[8]
            self.parent = None
        else:
            raise ValueError('No match found in database.')
    
    @classmethod
    def get_by_id(cls, db, set_id):
        query = f"SELECT * FROM sets WHERE id = \'{set_id}\';"
        row = db.execute(query).fetchone()
        return cls(data=row)
    
    @classmethod
    def get_by_code(cls, db, set_code):
        query = f"SELECT * FROM sets WHERE code = \'{set_code}\';"
        row = db.execute(query).fetchone()
        return cls(data=row)
    
    @classmethod
    def get_list(cls, db):
        query = f"SELECT * FROM sets;"
        rows = db.execute(query).fetchall()
        sets = []
        for s in rows:
            sets.append(cls(data=s))
        for child in sets:
            if child.parent_set_code is not None:
                for parent in sets:
                    if parent.code == child.parent_set_code:
                        child.parent = parent
        return sets

class Ruling:
    def __init__(self, data=None):
        if data is not None:
            self.oracle_id = data[0]
            self.source = data[1]
            self.published_at = data[2]
            self.comment = data[3]
        else:
            raise ValueError('No match found in database.')
    
    @classmethod
    def get_by_id(cls, db, card_id):
        query = f"SELECT * FROM rulings WHERE oracle_id = \'{card_id}\';"
        row = db.execute(query).fetchone()
        return cls(data=row)
    
    @classmethod
    def get_list_by_id(cls, db, card_id):
        query = f"SELECT * FROM rulings WHERE oracle_id = \'{card_id}\';"
        rows = db.execute(query).fetchall()
        rulings = []
        for r in rows:
            rulings.append(cls(data=r))
        return rulings

class Collection:
    def __init__(self, data=None, card_id=None, oracle_id=None):
        if data is not None:
            self.id = data[0]
            self.oracle_id = data[1]
            self.quantity = data[2]
        elif card_id is not None and oracle_id is not None:
            self.id = card_id
            self.oracle_id = oracle_id
            self.quantity = 0
        else:
            raise ValueError('No match found in database.')

    @classmethod
    def get_by_id(cls, db, card_id, oracle_id):
        query = f"SELECT * FROM collection WHERE id = \'{card_id}\';"
        row = db.execute(query).fetchone()
        return cls(data=row, card_id=card_id, oracle_id=oracle_id)

    @classmethod
    def get_list_by_oracle(cls, db, oracle_id):
        query = f"SELECT * FROM collection WHERE oracle_id = \'{oracle_id}\';"
        rows = db.execute(query).fetchall()
        collection = []
        for c in rows:
            collection.append(cls(data=c))
        return collection
    
    @classmethod
    def get_all(cls, db):
        query = f"SELECT * FROM collection;"
        rows = db.execute(query).fetchall()
        collection = []
        for c in rows:
            collection.append(cls(data=c))
        return collection
    
    def get_total_quantity(db, oracle_id):
        query = f"SELECT SUM(quantity) FROM collection WHERE oracle_id = \'{oracle_id}\';"
        row = db.execute(query).fetchone()
        if row is not None and row[0] is not None:
            return row[0]
        return 0

    def save(self, db):
        if self.id is None or self.quantity is None:
            raise ValueError('Invalid Collection value.')
        elif self.quantity == '0':
            self.delete(db)
        else:
            query = f"INSERT OR IGNORE INTO collection (id, oracle_id, quantity) VALUES (\'{self.id}\', \'{self.oracle_id}\', {self.quantity});"
            db.execute(query)
            query = f"UPDATE collection SET oracle_id = \'{self.oracle_id}\', quantity = {self.quantity} WHERE id = \'{self.id}\';"
            db.execute(query)
            
    def delete(self, db):
        if self.id is None:
            raise ValueError('Invalid Collection value.')
        else:
            query = f"DELETE FROM collection WHERE id = \'{self.id}\';"
            db.execute(query)

class FullCard:
    def __init__(self, card=None, card_set=None, rulings=None, collection=None):
        self.card = card
        self.card_set = card_set
        self.rulings = rulings
        self.collection = collection

    @classmethod
    def get_by_id(cls, db, card_id):
        c = Card.get_by_id(db, card_id)
        s = Set.get_by_code(db, c.set_code)
        r = Ruling.get_list_by_id(db, c.oracle_id)
        q = Collection.get_by_id(db, c.id, c.oracle_id)
        return cls(card=c, card_set=s, rulings=r, collection=q)
    
    @classmethod
    def get_by_oracle_id(cls, db, card_id):
        c = OracleCard.get_by_id(db, card_id)
        s = Set.get_by_code(db, c.set_code)
        r = Ruling.get_list_by_id(db, c.oracle_id)
        q = Collection.get_by_id(db, c.id, c.oracle_id)
        return cls(card=c, card_set=s, rulings=r, collection=q)

    @classmethod
    def get_by_name(cls, db, name):
        c = OracleCard.get_by_name(db, name)
        s = Set.get_by_code(db, c.set_code)
        r = Ruling.get_list_by_id(db, c.oracle_id)
        q = Collection.get_by_id(db, c.id, c.oracle_id)
        return cls(card=c, card_set=s, rulings=r, collection=q)
    
    @classmethod
    def get_random_card(cls, db):
        c = Card.get_random(db)
        s = Set.get_by_code(db, c.set_code)
        r = Ruling.get_list_by_id(db, c.oracle_id)
        q = Collection.get_by_id(db, c.id, c.oracle_id)
        return cls(card=c, card_set=s, rulings=r, collection=q)

class SetList:
    def __init__(self, sets=None, set_types=None):
        self.sets = sets
        self.set_types = set_types
    
    @classmethod
    def get_all(cls, db):
        s = Set.get_list(db)
        t = []
        for x in s:
            if x.set_type not in t:
                t.append(x.set_type)
        return cls(sets=s, set_types=t)

class SetCardList:
    def __init__(self, selected_set=None, set_cards=None):
        self.selected_set = selected_set
        self.set_cards = set_cards
    
    @classmethod
    def get_by_set_code(cls, db, set_code):
        s = Set.get_by_code(db, set_code)
        c = Card.get_list_by_set_code(db, set_code)
        return cls(selected_set=s, set_cards=c)

class FullCollection:
    def __init__(self, cards=None, cards_per_page=60, page=1):
        self.cards = cards
        self.cards_per_page = cards_per_page
        self.page = page
    
    @classmethod
    def get_all(cls, db, q):
        col = Collection.get_all(db)
        cards = []
        r = int(q.get('results') or 60)
        p = int(q.get('page') or 1)
        for c in col:
            cards.append(FullCard.get_by_id(db, c.id))
        return cls(cards=cards, cards_per_page=r, page=p)

class CardSearch:
    def __init__(self, cards=None, cards_per_page=60, page=1):
        self.cards = cards
        self.cards_per_page = cards_per_page
        self.page = page
    
    @classmethod
    def get_by_query(cls, db, q):
        c = OracleCard.get_by_query(db, q)
        r = int(q.get('results') or 60)
        p = int(q.get('page') or 1)
        return cls(cards=c, cards_per_page=r, page=p)

class Deck:
    def __init__(self, data=None):
        if data is not None:
            self.id = data[0]
            self.name = data[1]
            try:
                self.created = datetime.strptime(data[2], "%Y-%m-%d %H:%M:%S.%f")
            except Exception:
                self.created = datetime.now()
            try:
                self.updated = datetime.strptime(data[3], "%Y-%m-%d %H:%M:%S.%f")
            except Exception:
                self.updated = datetime.now()
            self.maindeck = data[4]
            self.sideboard = data[5]
            self.format = data[6]
            self.commander = data[7]
            self.partner = data[8]
            self.companion = data[9]
            self.valid = data[10]
        else:
            raise ValueError('No match found in database.')
    
    @classmethod
    def get_by_id(cls, db, id):
        query = f"SELECT * FROM decks WHERE id = {id};"
        row = db.execute(query).fetchone()
        return cls(row)
    
    @classmethod
    def get_empty(cls):
        return cls((None, '', '', '', '', '', '', '', '', '', 0))
    
    def save(self, db):
        if self.id is None:
            query = f"INSERT INTO decks (name, created, updated, maindeck, sideboard, format, commander, partner, companion, valid) " \
                    f"VALUES ({val(self.name)}, {val(str(datetime.now()))}, {val(str(datetime.now()))}, {val(self.maindeck)}, {val(self.sideboard)}, {val(self.format)}, {val(self.commander)}, {val(self.partner)}, {val(self.companion)}, {val(self.valid)});"
        else:
            query = f"INSERT OR IGNORE INTO decks (id, name, created, updated, maindeck, sideboard, format, commander, partner, companion, valid) " \
                    f"VALUES ({self.id}, {val(self.name)}, {val(str(datetime.now()))}, {val(str(datetime.now()))}, {val(self.maindeck)}, {val(self.sideboard)}, {val(self.format)}, {val(self.commander)}, {val(self.partner)}, {val(self.companion)}, {val(self.valid)});"
            db.execute(query)
            query = f"UPDATE decks SET name = '{self.name}', updated = {val(str(datetime.now()))}, maindeck = {val(self.maindeck)}, sideboard = {val(self.sideboard)}, format = '{self.format}', commander = '{self.commander}', partner = '{self.partner}', companion = '{self.companion}', valid = {val(self.valid)} " \
                    f"WHERE id = {self.id};"
        db.execute(query)
            
    def delete(self, db):
        if self.id is None:
            raise ValueError('Invalid Deck value.')
        else:
            query = f"DELETE FROM decks WHERE id = {self.id};"
            db.execute(query)
    
class FullDeck:
    def __init__(self, deck=None):
        if deck is not None:
            self.deck = deck
        else:
            raise ValueError('No deck data.')
        self.maindeck_cards = {}
        self.sideboard_cards = {}
        self.missing_cards = {}
        self.commander = None
        self.partner = None
        self.companion = None
        self.card_total = 0
        self.card_count = 0
        self.error = {}
        self.preview = None

    def get_cards(self, db):
        try:
            if self.deck.commander != '':
                self.card_count += 1
                self.card_total += 1
            self.commander = DeckCard.get_by_name(db, self.deck.commander)
        except ValueError:
            self.commander = None
        try:
            if self.deck.partner != '':
                self.card_count += 1
                self.card_total += 1
            self.partner = DeckCard.get_by_name(db, self.deck.partner)
        except ValueError:
            self.partner = None
        try:
            if self.deck.companion != '':
                self.card_count += 1
                self.card_total += 1
            self.companion = DeckCard.get_by_name(db, self.deck.companion)
        except ValueError:
            self.companion = None
        self.maindeck_cards = self.get_card_dict(db, self.deck.maindeck)
        self.sideboard_cards = self.get_card_dict(db, self.deck.sideboard)

    def get_card_dict(self, db, card_list):
        cards = {}
        for line in card_list.split('\n'):
            words = line.strip().split(maxsplit=1)
            if len(words) < 1:
                continue
            try:
                quantity = int(words[0])
                words.pop(0)
                name = ' '.join(words)
            except ValueError:
                quantity = 1
                name = line.strip()
            try:
                card = DeckCard.get_by_name(db, name)
            except ValueError:
                card = None
            if name not in cards:
                cards[name] = {}
                cards[name]['quantity'] = 0
                self.card_count += 1
            cards[name]['card'] = card
            cards[name]['type'] = self.card_type(card)
            cards[name]['quantity'] += quantity
            self.card_total += quantity
        return cards

    def get_missing_cards(self):
        if self.commander is not None:
            if sum(c.quantity for c in self.commander.collection) < 1:
                self.add_card_by_type(self.missing_cards, self.commander.card.name, self.commander, 'Commander', 1)
        if self.partner is not None:
            if sum(c.quantity for c in self.partner.collection) < 1:
                self.add_card_by_type(self.missing_cards, self.partner.card.name, self.partner, 'Partner', 1)
        if self.companion is not None:
            if sum(c.quantity for c in self.companion.collection) < 1:
                self.add_card_by_type(self.missing_cards, self.companion.card.name, self.companion, 'Companion', 1)
        
        for name in self.maindeck_cards:
            if self.maindeck_cards[name]['card'] is not None:
                collection_total = sum(c.quantity for c in self.maindeck_cards[name]['card'].collection)
                if collection_total < self.maindeck_cards[name]['quantity']:
                    self.add_card_by_type(self.missing_cards, self.maindeck_cards[name]['card'].card.name, self.maindeck_cards[name]['card'], self.card_type(self.maindeck_cards[name]['card']), self.maindeck_cards[name]['quantity'] - collection_total)
        
        for name in self.sideboard_cards:
            if self.sideboard_cards[name]['card'] is not None:
                collection_total = sum(c.quantity for c in self.sideboard_cards[name]['card'].collection)
                if collection_total < self.sideboard_cards[name]['quantity']:
                    self.add_card_by_type(self.missing_cards, self.sideboard_cards[name]['card'].card.name, self.sideboard_cards[name]['card'], self.card_type(self.sideboard_cards[name]['card']), self.sideboard_cards[name]['quantity'] - collection_total)

    def add_card_by_type(self, dictionary, name, card, card_type, quantity):
        if card_type not in dictionary:
            dictionary[card_type] = {}
        if name not in dictionary[card_type]:
            dictionary[card_type][name] = {}
            dictionary[card_type][name]['quantity'] = 0
        dictionary[card_type][name]['card'] = card
        dictionary[card_type][name]['quantity'] += quantity
    
    def card_type(self, card):
        if card is None or card.card.type_line is None:
            return 'Other'
        c = card.card
        if 'planeswalker' in c.type_line.lower():
            return 'Planeswalkers'
        if 'creature' in c.type_line.lower():
            return 'Creatures'
        if 'sorcery' in c.type_line.lower():
            return 'Sorceries'
        if 'instant' in c.type_line.lower():
            return 'Instants'
        if 'artifact' in c.type_line.lower():
            return 'Artifacts'
        if 'enchantment' in c.type_line.lower():
            return 'Enchanments'
        if 'land' in c.type_line.lower():
            return 'Lands'
        return 'Other'

    # General validation
    # TO-DO individual format validations
    def validate(self):
        if self.deck.commander != '' and self.commander is None:
            self.error['commander'] = f"Invalid commander: {self.deck.commander}"
        if self.deck.partner != '' and self.partner is None:
            self.error['partner'] = f"Invalid partner: {self.deck.partner}"
        if self.deck.companion != '' and self.companion is None:
            self.error['companion'] = f"Invalid companion: {self.deck.companion}"
        
        for key in self.maindeck_cards:
            if self.maindeck_cards[key]['card'] is None:
                if 'maindeck' not in self.error:
                    self.error['maindeck'] = 'Invalid maindeck card(s): '
                    self.error['maindeck'] += key
                else:
                    self.error['maindeck'] += ', ' + key
        
        for key in self.sideboard_cards:
            if self.sideboard_cards[key]['card'] is None:
                if 'sideboard' not in self.error:
                    self.error['sideboard'] = 'Invalid sideboard card(s): '
                    self.error['sideboard'] += key
                else:
                    self.error['sideboard'] += ', ' + key
        
        if len(self.error) > 0:
            self.deck.valid = 0
        else:
            self.deck.valid = 1

    @classmethod
    def get_by_id(cls, db, id):
        query = f"SELECT * FROM decks WHERE id = {id};"
        row = db.execute(query).fetchone()
        fd = cls(deck=Deck(data=row))
        fd.get_cards(db)
        fd.get_missing_cards()
        fd.validate()
        return fd
    
    @classmethod
    def get_by_deck(cls, db, deck):
        fd = cls(deck=deck)
        fd.get_cards(db)
        fd.get_missing_cards()
        fd.validate()
        return fd

class PreviewDeck:
    def __init__(self, deck=None):
        if deck is not None:
            self.deck = deck
        else:
            raise ValueError('No deck data.')
        self.preview_card = None
    
    @classmethod
    def get_all(cls, db):
        query = f"SELECT * FROM decks;"
        rows = db.execute(query).fetchall()
        decks = []
        for r in rows:
            decks.append(cls(deck=Deck(data=r)))
        return decks

class DeckCard:
    def __init__(self, card=None, collection=None):
        self.card = card
        self.collection = collection

    @classmethod
    def get_by_id(cls, db, card_id):
        c = Card.get_by_id(db, card_id)
        q = Collection.get_list_by_oracle(db, c.oracle_id)
        return cls(card=c, collection=q)
    
    @classmethod
    def get_by_oracle_id(cls, db, card_id):
        c = OracleCard.get_by_id(db, card_id)
        q = Collection.get_list_by_oracle(db, c.oracle_id)
        return cls(card=c, collection=q)

    @classmethod
    def get_by_name(cls, db, name):
        c = OracleCard.get_by_name(db, name)
        q = Collection.get_list_by_oracle(db, c.oracle_id)
        return cls(card=c, collection=q)
    
    @classmethod
    def get_random_card(cls, db):
        c = Card.get_random(db)
        q = Collection.get_list_by_oracle(db, c.oracle_id)
        return cls(card=c, collection=q)

class DeckSearch:
    def __init__(self, preview_decks=None, decks_per_page=60, page=1):
        self.preview_decks = preview_decks
        self.decks_per_page = decks_per_page
        self.page = page

    @classmethod
    def get_all(cls, db, q):
        d = PreviewDeck.get_all(db)
        r = int(q.get('results') or 60)
        p = int(q.get('page') or 1)
        return cls(preview_decks=d, decks_per_page=r, page=p)

class Binder:
    def __init__(self, data=None):
        if data is not None:
            self.id = data[0]
            self.name = data[1]
            try:
                self.created = datetime.strptime(data[2], "%Y-%m-%d %H:%M:%S.%f")
            except Exception:
                self.created = datetime.now()
            try:
                self.updated = datetime.strptime(data[3], "%Y-%m-%d %H:%M:%S.%f")
            except Exception:
                self.updated = datetime.now()
            self.general = data[4]
        else:
            raise ValueError('No match found in database.')
    
    @classmethod
    def get_by_id(cls, db, id):
        query = f"SELECT * FROM binders WHERE id = {id};"
        row = db.execute(query).fetchone()
        return cls(row)
    
    @classmethod
    def get_all(cls, db):
        query = f"SELECT * FROM binders;"
        rows = db.execute(query).fetchall()
        binders = []
        for r in rows:
            binders.append(cls(data=r))
        return binders

    def save(self, db):
        if self.name is None:
            raise ValueError('Invalid Binder value.')
        try:
            if self.id is None:
                query = f"INSERT INTO binders (name, created, updated, general) VALUES ({val(self.name)}, {val(str(datetime.now()))}, {val(str(datetime.now()))}, {self.general});"
            else:
                query = f"INSERT OR IGNORE INTO binders (id, name, created, updated, general) " \
                        f"VALUES ({self.id}, {val(self.name)}, {val(str(datetime.now()))}, {val(str(datetime.now()))}, {self.general});"
                db.execute(query)
                query = f"UPDATE binders SET name = {val(self.name)}, updated = {val(str(datetime.now()))}, general = {self.general} WHERE id = {self.id};"
            db.execute(query)
        except sqlite3.Error:
            raise ValueError('Binder name already in use.')

    def delete(self, db):
        if self.id is None:
            raise ValueError('Invalid Binder value.')
        else:
            query = f"DELETE FROM binder_cards WHERE binder_id = \'{self.id}\';"
            db.execute(query)
            query = f"DELETE FROM binders WHERE id = \'{self.id}\';"
            db.execute(query)

class BinderCard:
    def __init__(self, data=None):
        if data is not None:
            self.card = data[0]
            self.collection = data[1]
            self.quantity = data[2]
            self.cover = data[3]
            self.binder_id = data[4]
        else:
            raise ValueError('No match found in database.')
    
    @classmethod
    def get_by_id(cls, db, id, binder_id):
        query = f"SELECT * FROM binder_cards WHERE id = \'{id}\' AND binder_id = {binder_id};"
        row = db.execute(query).fetchone()
        if row is None:
            raise ValueError('No match found in database.')
        c = Card.get_by_id(db, id)
        return cls(data=(c, Collection.get_by_id(db, c.id, c.oracle_id), row[2], row[3], row[4]))
    
    @classmethod
    def get_all(cls, db, binder_id):
        query = f"SELECT * FROM binder_cards WHERE binder_id = {binder_id};"
        rows = db.execute(query).fetchall()
        bc = []
        for r in rows:
            c = Card.get_by_id(db, r[0])
            bc.append(cls(data=(c, Collection.get_by_id(db, c.id, c.oracle_id), r[2], r[3], r[4])))
        return bc

    def save(self, db):
        if self.card is None or self.binder_id is None:
            raise ValueError('Invalid BinderCard value.')
        elif self.quantity == '0':
            self.delete(db)
        else:
            if self.cover == 1:
                query = f"UPDATE binder_cards SET cover = 0 WHERE binder_id = {self.binder_id};"
                db.execute(query)
            query = f"INSERT OR IGNORE INTO binder_cards (id, oracle_id, quantity, cover, binder_id) VALUES (\'{self.card.id}\', \'{self.card.oracle_id}\', {self.quantity}, {self.cover}, {self.binder_id});"
            db.execute(query)
            query = f"UPDATE binder_cards SET oracle_id = \'{self.card.oracle_id}\', quantity = {self.quantity}, cover = {self.cover} WHERE id = \'{self.card.id}\' AND binder_id = {self.binder_id};"
            db.execute(query)
            query = f"UPDATE binders SET updated = {val(str(datetime.now()))} WHERE id = {self.binder_id};"
            db.execute(query)

    def delete(self, db):
        if self.card is None or self.binder_id is None:
            raise ValueError('Invalid BinderCard value.')
        else:
            query = f"DELETE FROM binder_cards WHERE id = \'{self.card.id}\' AND binder_id = {self.binder_id};"
            db.execute(query)
            query = f"UPDATE binders SET updated = {val(str(datetime.now()))} WHERE id = {self.binder_id};"
            db.execute(query)

class FullBinder:
    def __init__(self, binder=None, cover=None, cards=None):
        if binder is not None:
            self.binder = binder
        else:
            raise ValueError('No binder data.')
        self.cover = cover
        self.cards = cards
        self.collection_totals = {}
    
    def get_collection_totals(self, db):
        query = f"SELECT oracle_id, COUNT(oracle_id), SUM(quantity) FROM binder_cards WHERE binder_id = {self.binder.id} GROUP BY oracle_id;"
        rows = db.execute(query).fetchall()
        for r in rows:
            self.collection_totals[r[0]] = {}
            self.collection_totals[r[0]]['count'] = r[1]
            self.collection_totals[r[0]]['needed'] = r[2]
            self.collection_totals[r[0]]['owned'] = Collection.get_total_quantity(db, r[0])

    @classmethod
    def get_by_id(cls, db, id):
        b = Binder.get_by_id(db, id)
        query = f"SELECT * FROM binder_cards WHERE binder_id = {b.id} AND cover = 1"
        row = db.execute(query).fetchone()
        c = None
        if row is not None:
            c = Card.get_by_id(db, row[0])
        bc = BinderCard.get_all(db, b.id)
        fb = cls(binder=b, cover=c, cards=bc)
        fb.get_collection_totals(db)
        return fb

class PreviewBinder:
    def __init__(self, binder=None, cover=None):
        if binder is not None:
            self.binder = binder
        else:
            raise ValueError('No binder data.')
        self.cover = cover
    
    @classmethod
    def get_all(cls, db):
        binders = Binder.get_all(db)
        previews = []
        for b in binders:
            query = f"SELECT * FROM binder_cards WHERE binder_id = {b.id} AND cover = 1"
            row = db.execute(query).fetchone()
            c = None
            if row is not None:
                c = BinderCard.get_by_id(db, row[0], b.id)
            previews.append(cls(binder=b, cover=c))
        return previews

class BinderSearch:
    def __init__(self, preview_binders=None, binders_per_page=60, page=1):
        self.preview_binders = preview_binders
        self.binders_per_page = binders_per_page
        self.page = page

    @classmethod
    def get_all(cls, db, q):
        b = PreviewBinder.get_all(db)
        r = int(q.get('results') or 60)
        p = int(q.get('page') or 1)
        return cls(preview_binders=b, binders_per_page=r, page=p)

def store_faces(data):
    if data is None:
        return "NULL"
    x = str(data).replace('"', '\'')
    return f"\"{x}\""

def val(data):
    if data is None:
        return "NULL"
    if type(data) is list:
        x = " ".join(data)
        return f"\"{x}\""
    if type(data) is dict:
        x = str(data)
        return f"\"{x}\""
    if type(data) is str:
        x = data.replace('"', '\'')
        return f"\"{x}\""
    if type(data) is int:
        return data
    if type(data) is float:
        return data
    return f"\"{data}\""
