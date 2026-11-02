# ---- [userinput]
mkdir -pv $LFS
mount -v -t ext4 /dev/<xxx> $LFS
# ---- [userinput]
mkdir -pv $LFS
mount -v -t ext4 /dev/<xxx> $LFS
mkdir -v $LFS/home
mount -v -t ext4 /dev/<yyy> $LFS/home
# ---- [userinput]
chown root:root $LFS
chmod 755 $LFS
# ---- [userinput]
/sbin/swapon -v /dev/<zzz>
