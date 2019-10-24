FROM alpine
ENV VIPSVERSION 8.8.3
RUN apk update
RUN apk add build-base pkgconfig glib-dev gobject-introspection-dev expat-dev tiff-dev libjpeg-turbo-dev libexif-dev giflib-dev librsvg-dev lcms2-dev libpng orc-dev libwebp-dev libheif-dev
RUN apk add libimagequant-dev --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing

RUN \
  # Build libvips
  cd /tmp && \
  wget https://github.com/libvips/libvips/releases/download/v$VIPSVERSION/vips-$VIPSVERSION.tar.gz && \
  tar zxvf vips-$VIPSVERSION.tar.gz && \
  cd /tmp/vips-$VIPSVERSION && \
  ./configure --enable-debug=no --without-python $1 && \
  make && \
  make install

RUN ldconfig /

CMD [ "/bin/bash" ]