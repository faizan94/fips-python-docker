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
