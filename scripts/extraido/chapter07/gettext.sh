# ---- [userinput]
./configure --disable-shared
# ---- [userinput]
make
# ---- [userinput]
cp -v gettext-tools/src/{msgfmt,msgmerge,xgettext} /usr/bin
