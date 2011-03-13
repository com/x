# Sıralama işlevi -*-encoding: utf-8-*-

# PRIORITIZED dizisini local.py'de tanımlıyoruz

def mycmp(x, y):
    for prefix in PRIORITIZED:
        if x.startswith(prefix):
            return -1
        elif y.startswith(prefix):
            return +1
    return cmp(x, y)
