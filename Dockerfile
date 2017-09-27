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
ENV PYTHON_PATH        $TMP_PATH/Python-3.6.0
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
# DOCKER END
##############################################################################

WORKDIR "/home"
CMD ["/bin/bash"]
