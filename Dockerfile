FROM nginxproxy/nginx-proxy:1.4

ENV HEADERS_MORE_MODULE_VERSION=0.36

ENV BUILD_DEPENDENCIES \
    build-essential \
    libssl-dev \
    libpcre3 \
    libpcre3-dev \
    zlib1g-dev \
    wget

RUN set -ex \
    # Install basic packages and build tools
    && apt-get update \
    && apt-get install --no-install-recommends --no-install-suggests -y ${BUILD_DEPENDENCIES} \
    # download and extract sources
    && NGINX_VERSION=`nginx -V 2>&1 | grep "nginx version" | awk -F/ '{ print $2}'` \
    && cd /tmp \
    # download and extract nginx
    && wget http://nginx.org/download/nginx-$NGINX_VERSION.tar.gz \
    && tar -xf nginx-$NGINX_VERSION.tar.gz \
    && mv nginx-$NGINX_VERSION nginx \
    && rm nginx-$NGINX_VERSION.tar.gz \
    # download and extract headers-more-nginx-module
    && wget https://github.com/openresty/headers-more-nginx-module/archive/v$HEADERS_MORE_MODULE_VERSION.tar.gz \
             -O headers-more-nginx-module-$HEADERS_MORE_MODULE_VERSION.tar.gz \
    && tar -xf headers-more-nginx-module-$HEADERS_MORE_MODULE_VERSION.tar.gz \
    && mv headers-more-nginx-module-$HEADERS_MORE_MODULE_VERSION headers-more-nginx-module \
    && rm headers-more-nginx-module-$HEADERS_MORE_MODULE_VERSION.tar.gz \
    # configure and build
    && cd /tmp/nginx \
    && BASE_CONFIGURE_ARGS=`nginx -V 2>&1 | grep "configure arguments" | cut -d " " -f 3-` \
    && /bin/sh -c "./configure ${BASE_CONFIGURE_ARGS} --add-module=/tmp/headers-more-nginx-module" \
    && make && make install \
    # cleanup
    && apt-get purge -y ${BUILD_DEPENDENCIES} \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/* /tmp/* /var/tmp/*

