# REVISADO — general/icu — icu-77.1
set -e
case $(uname -m) in
  i?86) sed -e "s/U_PLATFORM_IS_LINUX_BASED/__X86_64__ \&\& &/" \
            -i source/test/intltest/ustrtest.cpp ;;
esac
cd source                 &&
./configure --prefix=/usr &&
make
make install
