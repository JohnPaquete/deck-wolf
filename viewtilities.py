import random

def legality(s):
    if (s == "legal"):
        return 'Legal'
    if (s == "not_legal"):
        return 'Not Legal'
    if (s == "restricted"):
        return 'Restricted'
    if (s == "banned"):
        return 'Banned'
    return 'NO ENTRY'

def legality_bg(s):
    if (s == "legal"):
        return 'table-success'
    if (s == "not_legal"):
        return 'table-secondary'
    if (s == "restricted"):
        return 'table-warning'
    if (s == "banned"):
        return 'table-danger'

def rarity(s):
    if (s == "common"):
        return 'Common'
    if (s == "uncommon"):
        return 'Uncommon'
    if (s == "rare"):
        return 'Rare'
    if (s == "mythic"):
        return 'Mythic Rare'
    return 'NO ENTRY'

def currency(s, prefix):
    if (s is not None):
        return prefix + s
    return '--'

def random_tutor():
    options = ('Grim Tutor', 'Demonic Tutor', 'Cruel Tutor')
    return random.choice(options)

def clean_text(s):
    if s is None:
        return 'NO ENTRY'
    return s.replace("_", " ")

def selected(value, s):
    if (s == value):
        return 'selected'
    return ''

def paginate(query, page):
    q = query.decode()
    q.replace('page', page)
    query_string = '?'
    count = 0
    for key, value in q.items():
        if (count > 0):
            query_string += '&'
        query_string += f"{key}={value}"
        count += 1
    return query_string

def sort_by_rarity(card):
    if (card.rarity == 'common'):
        return 1
    elif (card.rarity == 'uncommon'):
        return 2
    elif (card.rarity == 'rare'):
        return 3
    elif (card.rarity == 'mythic'):
        return 4
    return 0

def sort_by_price(card):
    if (card.prices.get('usd') is not None):
        return float(card.prices.get('usd'))
    if (card.prices.get('usd_foil') is not None):
        return float(card.prices.get('usd_foil'))
    return -1

def sort_by_power(card):
    if (card.faces is not None):
        for f in card.faces:
            if (f.get('power') is not None):
                try:
                    val = float(f.get('power'))
                    return val
                except ValueError:
                    pass
    if (card.power is None):
        return -2
    try:
        val = float(card.power)
        return val
    except ValueError:
        return -1

def sort_by_toughness(card):
    if (card.faces is not None):
        for f in card.faces:
            if (f.get('toughness') is not None):
                try:
                    val = float(f.get('toughness'))
                    return val
                except ValueError:
                    pass
    if (card.toughness is None):
        return -2
    try:
        val = float(card.toughness)
        return val
    except ValueError:
        return -1