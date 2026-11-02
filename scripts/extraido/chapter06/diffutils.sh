# ---- [userinput]
./configure --prefix=/usr   \
            --host=$LFS_TGT \
            gl_cv_func_strcasecmp_works=y \
            --build=$(./build-aux/config.guess)
# ---- [userinput]
make
# ---- [userinput]
make DESTDIR=$LFS install
