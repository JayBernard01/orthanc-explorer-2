# Use the official Orthanc image as the base
FROM orthancteam/orthanc:24.6.2

# Install necessary dependencies
RUN apt-get update && apt-get install -y \
    cmake \
    g++ \
    git \
    make \
    wget \
    nodejs \
    npm \
    python3-venv \
    python3-pip \
    lsb-release \
    mercurial \
    unzip \
    libjsoncpp-dev \
    uuid-dev \
    libboost-filesystem-dev \
    libboost-thread-dev \
    libboost-system-dev \
    libboost-date-time-dev \
    libboost-regex-dev \
    libboost-iostreams-dev \
    && rm -rf /var/lib/apt/lists/*

# Set up Python virtual environment and install pyorthanc
RUN python3 -m venv /venv
RUN /venv/bin/pip install pyorthanc
ENV PYTHONPATH=/venv/lib64/python3.11/site-packages/

# Copy the source code and CMakeLists.txt file to the build directory
COPY ./ /sources/orthanc-explorer-2/

# Change to the WebApplication directory
WORKDIR /sources/orthanc-explorer-2/WebApplication

# Install npm dependencies and build the project
RUN npm install
RUN npm run build

# Build the plugin
RUN mkdir -p /build
WORKDIR /build

# Clear CMake cache if it exists
RUN rm -f /sources/orthanc-explorer-2/CMakeCache.txt
RUN rm -rf /sources/orthanc-explorer-2/CMakeFiles

# Compile the plugin
RUN cmake -DALLOW_DOWNLOADS=ON -DCMAKE_BUILD_TYPE=Release -DUSE_SYSTEM_ORTHANC_SDK=OFF /sources/orthanc-explorer-2/
RUN make -j 4

# Put the plugin in usr/share/orthanc/plugins and make it executable
RUN mkdir -p /usr/share/orthanc/plugins
RUN cp /build/libOrthancExplorer2.so /usr/share/orthanc/plugins/
RUN chmod +x /usr/share/orthanc/plugins/libOrthancExplorer2.so