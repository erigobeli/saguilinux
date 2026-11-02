# REVISADO — py-mako
set -e
pip3 wheel -w dist --no-build-isolation --no-deps --no-cache-dir $PWD
pip3 install --no-index --find-links dist --no-user Mako

# ---------------- B04 Xorg ----------------
