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

ENV HTTP_REDIS_PATH     $TMP_PATH/ngx_http_redis-0.3.8
ENV ZLIB_PATH           $TMP_PATH/zlib-1.2.8
ENV PCRE_PATH           $TMP_PATH/pcre-8.39

ENV OPENSSL_PATH        $TMP_PATH/openssl-1.0.2h
ENV OPENSSL_FIPS        1

# Set build arguments
ARG OPENSSL_FIPS_PATH=openssl-fips-2.0.12
ARG SRC_TMP_PATH=tmp
ARG SRC_PATH=src
ARG LIB_PATH=lib

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
      vim

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
RUN ./config fips
RUN make
RUN make install

# Run Nginx
WORKDIR "/home"
CMD ["/bin/bash"]
