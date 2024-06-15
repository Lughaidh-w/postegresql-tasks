def compute_hash(txt):
    hv = 0
    pos = 0
    for let in txt:
        pos = (pos % 3) + 1
        hv = (hv + (pos * ord(let))) % 1000000
    return hv

def find_collision():
    import itertools
    import string

    characters = string.ascii_letters
    seen_hashes = {}
    
    for s in itertools.product(characters, repeat=4):
        s = ''.join(s)
        hv = compute_hash(s)
        if hv in seen_hashes:
            return s, seen_hashes[hv]
        seen_hashes[hv] = s

collision = find_collision()
if collision:
    print("Collision found:", collision)
else:
    print("No collision found.")
