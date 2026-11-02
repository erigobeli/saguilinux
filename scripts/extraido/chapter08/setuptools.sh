# ---- [userinput]
pip3 wheel -w dist --no-cache-dir --no-build-isolation --no-deps $PWD
# ---- [userinput]
pip3 install --no-index --find-links dist setuptools
