#!/usr/bin/python

import os
import shutil
import commands
import urllib

def copycover(currentalbum, src, dest, defaultfile):
    searchstring = currentalbum.replace(" ", "+")
    if not os.path.exists(src):
        url = "http://www.albumart.org/index.php?srchkey=" + searchstring + "&itempage=1&newsearch=1&searchindex=Music"
        cover = urllib.urlopen(url).read()
        image = ""
        for line in cover.split("\n"):
            if "http://www.albumart.org/images/zoom-icon.jpg" in line:
                image = line.partition('src="')[2].partition('"')[0]
                break
        if image:
            urllib.urlretrieve(image, src)
    if os.path.exists(src):
        shutil.copy(src, dest)
    elif os.path.exists(defaultfile):
        shutil.copy(defaultfile, dest)
    else:
        print "Image not found!"

# Path where the images are saved
imgpath = os.getenv("HOME") + "/.covers/"

# image displayed when no image found
noimg = imgpath + "nocover.png"

# Cover displayed by conky
cover = "/tmp/cover"

# Name of current album
album = commands.getoutput("mpc --format %artist%+%album% | head -n 1")

# If tags are empty, use noimg.
if album == "":
    if os.path.exists(conkycover):
        os.remove(conkycover)
    if os.path.exists(noimg):
        shutil.copy(noimg, conkycover)
    else:
        print "Image not found!"
else:

    filename = imgpath + album + ".jpg"
    if os.path.exists("/tmp/nowplaying") and os.path.exists("/tmp/cover"):
        nowplaying = open("/tmp/nowplaying").read()
        if nowplaying == album:
            pass
        else:
            copycover(album, filename, cover, noimg)
            open("/tmp/nowplaying", "w").write(album)
    else:
        copycover(album, filename, cover, noimg)
        open("/tmp/nowplaying", "w").write(album)