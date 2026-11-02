chown --from lfs -R root:root $LFS/{usr,var,etc,tools}
chown --from lfs -R root:root $LFS/lib64
mkdir -pv $LFS/{dev,proc,sys,run}
