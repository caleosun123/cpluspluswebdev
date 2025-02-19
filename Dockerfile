# Use an official Alpine as a parent image
FROM alpine:latest

# Install dependencies
RUN apk update && apk add --no-cache \
    build-base \
    cmake \
    git \
    boost-dev \
    openssl-dev \
    ninja \
    pkgconfig \
    wget

# Clone cpprestsdk repository and build
RUN git clone https://github.com/microsoft/cpprestsdk.git /cpprestsdk \
    && cd /cpprestsdk \
    && git submodule update --init \
    && mkdir build \
    && cd build \
    && cmake -G Ninja .. -DCMAKE_BUILD_TYPE=Debug \
    && ninja \
    && ninja install

# Copy your C++ application code to the container
COPY . /app

# Change working directory to the directory containing CMakeLists.txt
WORKDIR /app/cppwebdev

# Build your C++ application
RUN cmake -DCMAKE_PREFIX_PATH=/usr/local . \
    && make

# Expose the port your application runs on
EXPOSE 8080

# Command to run your application
CMD ["./cpluspluswebdev"]
