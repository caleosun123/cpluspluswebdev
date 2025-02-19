# Use an official Ubuntu as a parent image
FROM ubuntu:20.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Update package repository and install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    libboost-all-dev \
    libssl-dev \
    ninja-build \
    pkg-config \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Clone cpprestsdk repository and build
RUN git clone https://github.com/microsoft/cpprestsdk.git /cpprestsdk \
    && cd /cpprestsdk \
    && git submodule update --init \
    && mkdir build.debug \
    && cd build.debug \
    && cmake -G Ninja .. -DCMAKE_BUILD_TYPE=Debug \
    && cmake --build . \
    && cmake --install .

# Copy your C++ application code to the container
COPY . /app

# Change working directory
WORKDIR /app

# Build your C++ application
RUN cmake -DCMAKE_PREFIX_PATH=/usr/local .. \
    && make

# Expose the port your application runs on
EXPOSE 8080

# Command to run your application
CMD ["./cpluspluswebdev"]
