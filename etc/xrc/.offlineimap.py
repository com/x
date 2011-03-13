# -*-encoding: utf-8-*-
import sys, os, glob

# offlineimap dizinindeki tüm python dosyalarını ithal et
rcdir = os.path.join(os.environ['X'], 'etc', 'offlineimap'); sys.path.append(rcdir)
for m in [ os.path.basename(f)[:-3] for f in glob.glob(rcdir + "/*.py") ]:
    exec("from %s import *" % (m))
