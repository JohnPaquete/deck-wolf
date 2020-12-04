import sqlite3
import requests
from datetime import datetime

class Schema:
    def __init__(self):
        self.conn = sqlite3.connect('data/test.db')
        self.cursor = self.conn.cursor()
        self.create_record_table()
        self.create_sets_table()
        self.populate_sets_table()
        self.create_oracle_table()
        self.populate_oracle_table()

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
    
    def create_oracle_table(self):
        query = """
        CREATE TABLE IF NOT EXISTS oracle_cards (
          id TEXT PRIMARY KEY,
          name TEXT NOT NULL,
          released TEXT NOT NULL,
          uri TEXT NOT NULL,
          scryfall_uri TEXT NOT NULL,
          image_small TEXT,
          image_normal TEXT,
          image_large TEXT,
          image_png TEXT,
          image_border_crop TEXT,
          image_art_crop TEXT,
          mana_cost TEXT,
          cmc REAL NOT NULL,
          type_line TEXT NOT NULL,
          oracle_text TEXT,
          color_identity TEXT NOT NULL,
          power TEXT,
          toughness TEXT,
          keywords TEXT NOT NULL,
          legalities TEXT NOT NULL,
          rarity TEXT NOT NULL,
          flavor_text TEXT,
          artist TEXT
        );
        """
        self.cursor.execute(query)
        query= "INSERT OR IGNORE INTO records (name) VALUES ('oracle_cards')"
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
    
    def populate_oracle_table(self):
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
                        f'(id, name, released, uri, scryfall_uri, image_small, image_normal, image_large, image_png, image_border_crop, image_art_crop, mana_cost, cmc, type_line, oracle_text, color_identity, power, toughness, keywords, legalities, rarity, flavor_text, artist) ' \
                        f'VALUES ({val(c.get("oracle_id"))}, {val(c.get("name"))}, {val(c.get("released_at"))}, {val(c.get("uri"))}, {val(c.get("scryfall_uri"))}, '
                if (c.get("image_uris") is not None):
                    images = c.get("image_uris")
                    query += f'{val(images.get("small"))}, {val(images.get("normal"))}, {val(images.get("large"))}, {val(images.get("png"))}, {val(images.get("border_crop"))}, {val(images.get("art_crop"))}, '
                else:
                    query += 'NULL, NULL, NULL, NULL, NULL, NULL, '
                query += f'{val(c.get("mana_cost"))}, {c.get("cmc")}, {val(c.get("type_line"))}, {val(c.get("oracle_text"))}, {val(c.get("color_identity"))}, {val(c.get("power"))}, {val(c.get("toughness"))}, {val(c.get("keywords"))}, {val(c.get("legalities"))}, {val(c.get("rarity"))}, {val(c.get("flavor_text"))}, {val(c.get("artist"))});'
                self.cursor.execute(query)
            date = datetime.now()
            query = f"UPDATE records SET updated = '{date}' WHERE name = 'oracle_cards';"
            self.cursor.execute(query)
    
    def table_needs_update(self, table):
        query = f"SELECT updated FROM records WHERE name = '{table}';"
        self.cursor.execute(query)
        row = self.cursor.fetchone()
        if (row is not None):
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