
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