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
