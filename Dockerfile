FROM debian:buster-slim

VOLUME /root
WORKDIR /root

# Install dependencies
RUN apt update \
 && apt upgrade -y \
 && apt install -y \
    build-essential \
    git \
    libasound2-dev \
    libavformat-dev \
    libgtk2.0-dev \
    libjack-jackd2-dev \
    python3-minimal \
    x11-apps \
    wget

# Compile custom cmake
RUN cd /root \
 && wget https://github.com/Kitware/CMake/releases/download/v3.15.2/cmake-3.15.2.tar.gz \
 && tar xvfz cmake-3.15.2.tar.gz \
 && cd cmake-3.15.2 \
 && ./bootstrap \
 && make \
 && make install \
 && cmake --version

# Compile custom wxwidgets
RUN cd /root \
 && git clone --recurse-submodules https://github.com/audacity/wxWidgets/ \
 && cd wxWidgets \
 && mkdir buildgtk \
 && cd buildgtk \
 && ../configure --with-cxx=14 --with-gtk=2 \
 && make -j8 install

# Compile Audacity
RUN cd /root \
 && git clone https://github.com/audacity/audacity \
 && cd audacity \
 && mkdir build \
 && cd build \
 && cmake -DCMAKE_BUILD_TYPE=Release -Daudacity_use_ffmpeg=loaded .. \
 && make -j8

CMD xlogo
