##############################################################################
# IMAGES
##############################################################################

# Start with the latest Ubuntu image
FROM ubuntu

##############################################################################
# VARIABLES
##############################################################################

# Set environment variables
ENV TMP_PATH            /tmp
ENV SSL_INSTALL_PATH    /usr/local/ssl
ENV OPENSSL_PATH        $TMP_PATH/openssl-1.0.2h
ENV PYTHON_PATH         $TMP_PATH/Python-3.6.0
ENV OPENSSL_FIPS        1

# Set build arguments
ARG OPENSSL_FIPS_PATH=openssl-fips-2.0.12
ARG SRC_TMP_PATH=tmp
ARG SRC_PATH=src

##############################################################################
# COPY SOURCE CODE
##############################################################################

# Copy OpenSSL, OpenSSL FIPS source code
COPY $SRC_PATH      $TMP_PATH/

##############################################################################
# INSTALL DEPENDENCIES
##############################################################################

# Install dependencies for compiling OpenSSL
RUN apt-get update &&           \
    apt-get install             \
      --no-install-recommends   \
      --no-install-suggests -y  \
      build-essential           \
      file                      \
      g++                       \
      make                      \
      vim                       \
      gzip                      \
      zlib1g-dev

##############################################################################
# CONFIGURE AND INSTALL OPENSSL
##############################################################################

# Configure and install OpenSSL FIPS
WORKDIR $TMP_PATH/$OPENSSL_FIPS_PATH
RUN ./config
RUN make
RUN make install

# Configure OpenSSL (with FIPS)
WORKDIR $OPENSSL_PATH
RUN ./config shared fips
RUN make
RUN make install

##############################################################################
# LINKING, EXPORTING AND SOME EXTRA DEPENDENCIES
##############################################################################

ln -s /usr/local/ssl/bin/openssl /usr/bin/openssl
ln -s /usr/local/ssl/lib /usr/lib/ssl
ln -s /usr/local/ssl/include/openssl/ /usr/include/ssl

export LDFLAGS="-L/usr/local/ssl/lib/"
export LD_LIBRARY_PATH="/usr/local/ssl/lib/"
export CPPFLAGS="-I/usr/local/ssl/include/ -I/usr/local/ssl/include/openssl/"


##############################################################################
# BUILDING PYTHON3.6 with openssl and linking it
##############################################################################

# Configure Python (with FIPS Openssl)
WORKDIR /tmp/Python-3.6.0
RUN ./configure --enable-shared --prefix=/usr/local/python3.6
RUN make
RUN make install

RUN ln -s /usr/local/python3.6/bin/python3 /usr/bin/python3
RUN ln -s /usr/local/python3.6/bin/pip3.6 /usr/bin/pip3
RUN ln -s /usr/local/python3.6/include/python3.6m/ /usr/include/python3.6
RUN ln -s /usr/local/python3.6/lib/python3.6/ /usr/lib/python3.6
RUN ln -s /usr/local/python3.6/lib/libpython3.6m.so.1.0 /usr/lib/x86_64-linux-gnu/libpython3.6m.so.1.0
RUN ln -s /usr/local/python3.6/lib/libpython3.6m.so /usr/lib/x86_64-linux-gnu/libpython3.6m.so

##############################################################################
# DOCKER END
##############################################################################

WORKDIR "/home"
CMD ["/bin/bash"]
