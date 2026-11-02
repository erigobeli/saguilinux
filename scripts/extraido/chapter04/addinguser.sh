# ---- [userinput]
groupadd lfs
useradd -s /bin/bash -g lfs -m -k /dev/null lfs
# ---- [userinput]
passwd lfs
# ---- [userinput]
chown -v lfs $LFS/{usr{,/*},var,etc,tools}
case $(uname -m) in
  x86_64) chown -v lfs $LFS/lib64 ;;
esac
# ---- [userinput]
su - lfs
