
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

def usd(s):
    if (s is not None):
        return '$' + s
    return '--'
def eur(s):
    if (s is not None):
        return '€' + s
    return '--'