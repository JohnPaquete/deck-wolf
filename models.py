import sqlite3
import requests
from datetime import datetime

class Schema:
    def __init__(self):
        self.conn = sqlite3.connect('data/test.db')
        self.cursor = self.conn.cursor()
        self.create_record_table()
        self.create_sets_table()
        self.create_oracle_cards_table()
        self.create_cards_table()
        self.populate_sets_table()
        self.populate_oracle_cards_table()
        self.populate_cards_table()

    def __del__(self):
        self.conn.commit()
        self.conn.close()
        
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
          image_uris TEXT,
          mana_cost TEXT,
          cmc REAL NOT NULL,
          type_line TEXT NOT NULL,
          oracle_text TEXT,
          color_identity TEXT NOT NULL,
          power TEXT,
          toughness TEXT,
          loyalty TEXT,
          keywords TEXT NOT NULL,
          legalities TEXT NOT NULL,
          rarity TEXT NOT NULL,
          flavor_name TEXT,
          flavor_text TEXT,
          artist TEXT,
          set_code TEXT NOT NULL,
          set_name TEXT NOT NULL,
          set_type TEXT NOT NULL,
          set_uri TEXT NOT NULL,
          prices TEXT NOT NULL
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
          image_uris TEXT,
          mana_cost TEXT,
          cmc REAL NOT NULL,
          type_line TEXT NOT NULL,
          oracle_text TEXT,
          color_identity TEXT NOT NULL,
          power TEXT,
          toughness TEXT,
          loyalty TEXT,
          keywords TEXT NOT NULL,
          legalities TEXT NOT NULL,
          rarity TEXT NOT NULL,
          flavor_name TEXT,
          flavor_text TEXT,
          artist TEXT,
          set_code TEXT NOT NULL,
          set_name TEXT NOT NULL,
          set_type TEXT NOT NULL,
          set_uri TEXT NOT NULL,
          prices TEXT NOT NULL
        );
        """
        self.cursor.execute(query)
        query= "INSERT OR IGNORE INTO records (name) VALUES ('cards')"
        self.cursor.execute(query)

    def populate_sets_table(self):
        if (self.table_needs_update("sets") is not True):
            return
        print("Getting set list from Scryfall...")
        query = "DELETE FROM sets;"
        self.cursor.execute(query)
        response = requests.get("https://api.scryfall.com/sets")
        if (self.validate_request(response)):
            print("Importing set list...")
            for s in response.json().get("data"):
                query = f'INSERT INTO sets ' \
                        f'(code, name, search_uri, released, set_type, card_count, icon_svg_uri) ' \
                        f'VALUES ({val(s.get("code"))}, {val(s.get("name"))}, {val(s.get("search_uri"))}, {val(s.get("released_at"))}, {val(s.get("set_type"))}, {s.get("card_count")}, {val(s.get("icon_svg_uri"))});'
                self.cursor.execute(query)
        
            date = datetime.now()
            query = f"UPDATE records SET updated = '{date}' WHERE name = 'sets';"
            self.cursor.execute(query)
    
    def populate_oracle_cards_table(self):
        if (self.table_needs_update("oracle_cards") is not True):
            return
        print("Getting oracle cards from Scryfall...")
        query = "DELETE FROM oracle_cards;"
        self.cursor.execute(query)
        response = requests.get("https://api.scryfall.com/bulk-data/oracle-cards")
        if (self.validate_request(response)):
            response = requests.get(response.json().get("download_uri"))
        else:
            return
        if (self.validate_request(response)):
            print("Importing oracle cards...")
            for c in response.json():
                query = f'INSERT INTO oracle_cards ' \
                        f'(oracle_id, id, name, released, uri, scryfall_uri, rulings_uri, image_uris, mana_cost, cmc, type_line, oracle_text, color_identity, power, toughness, loyalty, keywords, legalities, rarity, flavor_name, flavor_text, artist, set_code, set_name, set_type, set_uri, prices) ' \
                        f'VALUES ({val(c.get("oracle_id"))}, {val(c.get("id"))}, {val(c.get("name"))}, {val(c.get("released_at"))}, {val(c.get("uri"))}, {val(c.get("scryfall_uri"))}, {val(c.get("rulings_uri"))}, {val(c.get("image_uris"))}, ' \
                        f'{val(c.get("mana_cost"))}, {c.get("cmc")}, {val(c.get("type_line"))}, {val(c.get("oracle_text"))}, {val(c.get("color_identity"))}, {val(c.get("power"))}, {val(c.get("toughness"))}, {val(c.get("loyalty"))}, ' \
                        f'{val(c.get("keywords"))}, {val(c.get("legalities"))}, {val(c.get("rarity"))}, {val(c.get("flavor_name"))}, {val(c.get("flavor_text"))}, {val(c.get("artist"))}, {val(c.get("set"))}, {val(c.get("set_name"))}, {val(c.get("set_type"))}, {val(c.get("set_uri"))}, {val(c.get("prices"))});'
                self.cursor.execute(query)
            date = datetime.now()
            query = f"UPDATE records SET updated = '{date}' WHERE name = 'oracle_cards';"
            self.cursor.execute(query)
            print("Oracle cards imported successfully")
    
    def populate_cards_table(self):
        if (self.table_needs_update("cards") is not True):
            return
        print("Getting cards from Scryfall...")
        query = "DELETE FROM cards;"
        self.cursor.execute(query)
        response = requests.get("https://api.scryfall.com/bulk-data/default-cards")
        if (self.validate_request(response)):
            response = requests.get(response.json().get("download_uri"))
        else:
            return
        if (self.validate_request(response)):
            print("Importing cards...")
            for c in response.json():
                query = f'INSERT INTO cards ' \
                        f'(oracle_id, id, name, released, uri, scryfall_uri, rulings_uri, image_uris, mana_cost, cmc, type_line, oracle_text, color_identity, power, toughness, loyalty, keywords, legalities, rarity, flavor_name, flavor_text, artist, set_code, set_name, set_type, set_uri, prices) ' \
                        f'VALUES ({val(c.get("oracle_id"))}, {val(c.get("id"))}, {val(c.get("name"))}, {val(c.get("released_at"))}, {val(c.get("uri"))}, {val(c.get("scryfall_uri"))}, {val(c.get("rulings_uri"))}, {val(c.get("image_uris"))}, ' \
                        f'{val(c.get("mana_cost"))}, {c.get("cmc")}, {val(c.get("type_line"))}, {val(c.get("oracle_text"))}, {val(c.get("color_identity"))}, {val(c.get("power"))}, {val(c.get("toughness"))}, {val(c.get("loyalty"))}, ' \
                        f'{val(c.get("keywords"))}, {val(c.get("legalities"))}, {val(c.get("rarity"))}, {val(c.get("flavor_name"))}, {val(c.get("flavor_text"))}, {val(c.get("artist"))}, {val(c.get("set"))}, {val(c.get("set_name"))}, {val(c.get("set_type"))}, {val(c.get("set_uri"))}, {val(c.get("prices"))});'
                self.cursor.execute(query)
            date = datetime.now()
            query = f"UPDATE records SET updated = '{date}' WHERE name = 'cards';"
            self.cursor.execute(query)
            print("Cards imported successfully")
    
    def table_needs_update(self, table):
        query = f"SELECT updated FROM records WHERE name = '{table}';"
        self.cursor.execute(query)
        row = self.cursor.fetchone()
        if (row is not None and row[0] is not None):
            current_time = datetime.now()
            update_time = datetime.strptime(row[0], '%Y-%m-%d %H:%M:%S.%f')
            diff = current_time - update_time
            if (diff.days >= 1):
                return True
            return False
        return True

    def validate_request(self, request):
        if (request.status_code == 200):
            print("Scryfall request returned status code 200: SUCCESS")
            return True
        print("Scryfall request returned status code" + str(request.status_code) + ": FAILURE")
        print(request.json().get("details"))
        return False

class Card:
    def __init__(self, data=None):
        if (data is not None):
            self.oracle_id = data[0]
            self.id = data[1]
            self.name = data[2]
            self.released = data[3]
            self.uri = data[4]
            self.scryfall_uri = data[5]
            self.rulings_uri = data[6]
            self.image_uris = data[7]
            self.mana_cost = data[8]
            self.cmc = data[9]
            self.type_line = data[10]
            self.oracle_text = data[11]
            self.color_identity = data[12]
            self.power = data[13]
            self.toughness = data[14]
            self.loyalty = data[15]
            self.keywords = data[16]
            self.legalities = data[17]
            self.rarity = data[18]
            self.flavor_name = data[19]
            self.flavor_text = data[20]
            self.artist = data[21]
            self.set_code = data[22]
            self.set_name = data[23]
            self.set_type = data[24]
            self.set_uri = data[25]
            self.prices = data[26]
        else:
            raise ValueError('No match found in database.')

class OracleCard(Card):
    def __init__(self, db, oracle_id):
        query = f"SELECT * FROM oracle_cards WHERE oracle_id = \'{oracle_id}\'"
        row = db.execute(query).fetchone()
        super().__init__(data=row)
    
def val(data):
    if (data is None):
        return "NULL"
    if (type(data) is list):
        x = " ".join(data)
        return f"\"{x}\""
    if (type(data) is dict):
        x = str(data)
        return f"\"{x}\""
    if (type(data) is str):
        x = data.replace('"', '\'')
        return f"\"{x}\""
    return f"\"{data}\""