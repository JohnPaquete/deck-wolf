import random
import re
from decimal import Decimal

def legality(s):
    if s == "legal":
        return 'Legal'
    if s == "not_legal":
        return 'Not Legal'
    if s == "restricted":
        return 'Restricted'
    if s == "banned":
        return 'Banned'
    return 'NO ENTRY'

def legality_bg(s):
    if s == "legal":
        return 'table-success'
    if s == "not_legal":
        return 'table-secondary'
    if s == "restricted":
        return 'table-warning'
    if s == "banned":
        return 'table-danger'

def rarity(s):
    if s == "common":
        return 'Common'
    if s == "uncommon":
        return 'Uncommon'
    if s == "rare":
        return 'Rare'
    if s == "mythic":
        return 'Mythic'
    return 'NO ENTRY'

def currency(s, prefix):
    if s is not None:
        if prefix is not None:
            return str(prefix) + str(s)
        return str(s)
    return '--'

def random_tutor():
    options = ('Grim Tutor', 'Demonic Tutor', 'Cruel Tutor')
    return random.choice(options)

def clean_text(s):
    if s is None:
        return 'NO ENTRY'
    return s.replace("_", " ")

def selected(value, s):
    if s == value:
        return 'selected'
    return ''

def show(value, s):
    if s == value:
        return 'show'
    return ''

def paginate(query, page):
    q = query.decode()
    q.replace('page', page)
    query_string = '?'
    count = 0
    for key, value in q.items():
        if count > 0:
            query_string += '&'
        query_string += f"{key}={value}"
        count += 1
    return query_string

def sort_by_rarity(card):
    if card.rarity == 'common':
        return 1
    elif card.rarity == 'uncommon':
        return 2
    elif card.rarity == 'rare':
        return 3
    elif card.rarity == 'mythic':
        return 4
    return 0

def sort_full_card_by_rarity(fullcard):
    if fullcard.card.rarity == 'common':
        return 1
    elif fullcard.card.rarity == 'uncommon':
        return 2
    elif fullcard.card.rarity == 'rare':
        return 3
    elif fullcard.card.rarity == 'mythic':
        return 4
    return 0

def sort_by_price(card):
    if card.prices.get('usd') is not None:
        return float(card.prices.get('usd'))
    if card.prices.get('usd_foil') is not None:
        return float(card.prices.get('usd_foil'))
    return -1

def sort_by_power(card):
    if card.faces is not None:
        for f in card.faces:
            if f.get('power') is not None:
                try:
                    val = float(f.get('power'))
                    return val
                except ValueError:
                    pass
    if card.power is None:
        return -2
    try:
        val = float(card.power)
        return val
    except ValueError:
        return -1

def sort_by_toughness(card):
    if card.faces is not None:
        for f in card.faces:
            if f.get('toughness') is not None:
                try:
                    val = float(f.get('toughness'))
                    return val
                except ValueError:
                    pass
    if card.toughness is None:
        return -2
    try:
        val = float(card.toughness)
        return val
    except ValueError:
        return -1

def total_price_usd(card_list):
    total = Decimal('0.00')
    for c in card_list:
        total += card_price(c.card)
    return total

def card_price(card):
    if card is not None:
        try:
            if card.prices.get('usd') is not None:
                return Decimal(card.prices.get('usd'))
            if card.prices.get('usd_foil') is not None:
                return Decimal(card.prices.get('usd_foil'))
        except ValueError:
            pass
    return Decimal('0.00')

def total_price_tix(card_list):
    total = Decimal('0.00')
    for c in card_list:
        total += card_price_tix(c.card)
    return total

def card_price_tix(card):
    if card is not None:
        try:
            if card.prices.get('tix') is not None:
                return Decimal(card.prices.get('tix'))
        except ValueError:
            pass
    return Decimal('0.00')

def full_card_image(full_card, key):
    if full_card.card.image_uris.get(key) is not None:
        return full_card.card.image_uris.get(key)
    elif full_card.card.faces is not None and len(full_card.card.faces) > 0:
        for face in full_card.card.faces:
            if face.get('image_uris') is not None and face.get('image_uris').get(key) is not None:
                return face.get('image_uris').get(key)
    return '/assets/img/card_back.jpg'

def card_image(card, key):
    if card.image_uris.get(key) is not None:
        return card.image_uris.get(key)
    elif card.faces is not None and len(card.faces) > 0:
        for face in card.faces:
            if face.get('image_uris') is not None and face.get('image_uris').get(key) is not None:
                return face.get('image_uris').get(key)
    return '/assets/img/card_back.jpg'

def is_valid(b):
    if b == 1:
        return 'Valid'
    return 'Invalid'

def card_cost(card, display):
    if display == 'paper':
        if card is not None:
            try:
                if card.prices.get('usd') is not None:
                    return '$' + str(Decimal(card.prices.get('usd')))
                if card.prices.get('usd_foil') is not None:
                    return '$' + str(Decimal(card.prices.get('usd_foil')))
            except ValueError:
                pass
        return '--'
    if display == 'mtgo':
        if card is not None:
            try:
                if card.prices.get('tix') is not None:
                    return str(Decimal(card.prices.get('tix'))) + 'tix'
            except ValueError:
                pass
        return '--'
    if display == 'rarity':
        if card is not None:
            return card.rarity
    return '--'

def sort_dict_by_cmc(k, d):
    if d[k] is None or d[k]['card'] is None:
        return -1
    return d[k]['card'].card.cmc

def deck_card_text_color(c):
    if c is not None:
        if c.card.rarity == 'common':
            return 'text-common'
        if c.card.rarity == 'uncommon':
            return 'text-uncommon'
        if c.card.rarity == 'rare':
            return 'text-rare'
        if c.card.rarity == 'mythic':
            return 'text-mythic'
        if c.card.rarity == 'bonus':
            return 'text-mythic'
        if c.card.rarity == 'special':
            return 'text-mythic'
    return "text-danger"

def is_general(b):
    if b == 0:
        return 'general'
    return 'specific'

def insert_symbols(s, extension=''):
    if s is None:
        return None

    temp = str(s)

    sym = {
        '{T}' : 'ms ms-tap ms-cost',
        '{Q}' : 'ms ms-untap ms-cost',
        '{E}' : 'ms ms-e ms-cost',
        '{PW}' : 'ms ms-planeswalker ms-cost',
        '{CHAOS}' : 'ms ms-chaos ms-cost',
        '{A}' : 'ms ms-acorn ms-cost',
        '{X}' : 'ms ms-x ms-cost',
        '{Y}' : 'ms ms-y ms-cost',
        '{Z}' : 'ms ms-z ms-cost',
        '{0}' : 'ms ms-0 ms-cost',
        '{½}' : 'ms ms-1-2 ms-cost',
        '{1}' : 'ms ms-1 ms-cost',
        '{2}' : 'ms ms-2 ms-cost',
        '{3}' : 'ms ms-3 ms-cost',
        '{4}' : 'ms ms-4 ms-cost',
        '{5}' : 'ms ms-5 ms-cost',
        '{6}' : 'ms ms-6 ms-cost',
        '{7}' : 'ms ms-7 ms-cost',
        '{8}' : 'ms ms-8 ms-cost',
        '{9}' : 'ms ms-9 ms-cost',
        '{10}' : 'ms ms-10 ms-cost',
        '{11}' : 'ms ms-11 ms-cost',
        '{12}' : 'ms ms-12 ms-cost',
        '{13}' : 'ms ms-13 ms-cost',
        '{14}' : 'ms ms-14 ms-cost',
        '{15}' : 'ms ms-15 ms-cost',
        '{16}' : 'ms ms-16 ms-cost',
        '{17}' : 'ms ms-17 ms-cost',
        '{18}' : 'ms ms-18 ms-cost',
        '{19}' : 'ms ms-19 ms-cost',
        '{20}' : 'ms ms-20 ms-cost',
        '{100}' : 'ms ms-100 ms-cost',
        '{1000000}' : 'ms ms-1000000 ms-cost',
        '{∞}' : 'ms ms-infinity ms-cost',
        '{W/U}' : 'ms ms-wu ms-cost',
        '{W/B}' : 'ms ms-wb ms-cost',
        '{B/R}' : 'ms ms-br ms-cost',
        '{B/G}' : 'ms ms-bg ms-cost',
        '{U/B}' : 'ms ms-ub ms-cost',
        '{U/R}' : 'ms ms-ur ms-cost',
        '{R/G}' : 'ms ms-rg ms-cost',
        '{R/W}' : 'ms ms-wr ms-cost',
        '{G/W}' : 'ms ms-wg ms-cost',
        '{G/U}' : 'ms ms-ug ms-cost',
        '{2/W}' : 'ms ms-2w ms-cost',
        '{2/U}' : 'ms ms-2u ms-cost',
        '{2/B}' : 'ms ms-2b ms-cost',
        '{2/R}' : 'ms ms-2r ms-cost',
        '{2/G}' : 'ms ms-2g ms-cost',
        '{P}' : 'ms ms-p ms-cost',
        '{W/P}' : 'ms ms-wp ms-cost',
        '{U/P}' : 'ms ms-up ms-cost',
        '{B/P}' : 'ms ms-bp ms-cost',
        '{R/P}' : 'ms ms-rp ms-cost',
        '{G/P}' : 'ms ms-gp ms-cost',
        '{HW}' : 'ms ms-w ms-half ms-cost',
        '{HU}' : 'ms ms-u ms-half ms-cost',
        '{HB}' : 'ms ms-b ms-half ms-cost',
        '{HR}' : 'ms ms-r ms-half ms-cost',
        '{HG}' : 'ms ms-g ms-half ms-cost',
        '{W}' : 'ms ms-w ms-cost',
        '{U}' : 'ms ms-u ms-cost',
        '{B}' : 'ms ms-b ms-cost',
        '{R}' : 'ms ms-r ms-cost',
        '{G}' : 'ms ms-g ms-cost',
        '{C}' : 'ms ms-c ms-cost',
        '{S}' : 'ms ms-s ms-cost'
    }

    return re.sub(r'{[A-Za-z0-9/½∞]*}', lambda match: f"<i class=\"{sym.get(match.group())} {extension}\"></i>" if sym.get(match.group()) is not None else match.group(), temp)