

ln -s /usr/local/ssl/bin/openssl /usr/bin/openssl
ln -s /usr/local/ssl/lib /usr/lib/ssl
ln -s /usr/local/ssl/include/openssl/ /usr/include/ssl

export LDFLAGS="-L/usr/local/ssl/lib/"
export LD_LIBRARY_PATH="/usr/local/ssl/lib/"
export CPPFLAGS="-I/usr/local/ssl/include/ -I/usr/local/ssl/include/openssl/"

cd /tmp
tar xf Python-3.6.0.tar.xz
rm Python-3.6.0.tar.xz


cd /tmp/Python-3.6.0
./configure --enable-shared --prefix=/usr/local/python3.6
make
make install

ln -s /usr/local/python3.6/bin/python3 /usr/bin/python3
ln -s /usr/local/python3.6/bin/pip3.6 /usr/bin/pip3
ln -s /usr/local/python3.6/include/python3.6m/ /usr/include/python3.6
ln -s /usr/local/python3.6/lib/python3.6/ /usr/lib/python3.6
ln -s /usr/local/python3.6/lib/libpython3.6m.so.1.0 /usr/lib/x86_64-linux-gnu/libpython3.6m.so.1.0
ln -s /usr/local/python3.6/lib/libpython3.6m.so /usr/lib/x86_64-linux-gnu/libpython3.6m.so
