# ---- [userinput]
rm -rf /tmp/{*,.*}
# ---- [userinput]
find /usr/lib /usr/libexec -name \*.la -delete
# ---- [userinput]
find /usr -depth -name $(uname -m)-lfs-linux-gnu\* | xargs rm -rf
# ---- [userinput]
userdel -r tester
