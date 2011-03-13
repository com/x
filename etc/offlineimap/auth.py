# Kullanıcı giriş bilgileri -*-encoding: utf-8-*-

import os, subprocess

def gettoken(token="gmail"):
    bindir = os.path.join(os.environ['X'], 'bin')
    if bindir:
        script = os.path.join(bindir, 'x-token')
    else:
        script = 'x-token'
    try:
        output, errors = subprocess.Popen(
                [script, token],
                stdout=subprocess.PIPE, stderr=subprocess.PIPE
        ).communicate()
        return output.rstrip()
    except:
        return ''

def getuser():
    try:
        return os.environ["X_EMAIL"]
    except:
        return ''
