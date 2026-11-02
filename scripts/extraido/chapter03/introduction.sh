# ---- [userinput]
mkdir -v $LFS/sources
# ---- [userinput]
chmod -v a+wt $LFS/sources
# ---- [userinput]
wget --input-file=wget-list-sysv --continue --directory-prefix=$LFS/sources
# ---- [userinput]
pushd $LFS/sources
  md5sum -c md5sums
popd
# ---- [userinput]
chown root:root $LFS/sources/*
