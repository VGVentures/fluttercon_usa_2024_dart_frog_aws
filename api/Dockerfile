# Official Dart image: https://hub.docker.com/_/dart
# Specify the Dart SDK base image version using dart:<version> (ex: dart:2.17)
FROM --platform=amd64 dart:stable AS build 

WORKDIR /app

# Resolve app dependencies.
COPY pubspec.* ./
COPY packages/fluttercon_data_source/pubspec.* ./packages/fluttercon_data_source/
COPY packages/fluttercon_shared_models/pubspec.* ./packages/fluttercon_shared_models/
COPY packages/speakers_repository/pubspec.* ./packages/speakers_repository/
COPY packages/talks_repository/pubspec.* ./packages/talks_repository/
COPY packages/user_repository/pubspec.* ./packages/user_repository/
RUN cd packages/fluttercon_data_source/ && dart pub get
RUN cd packages/fluttercon_shared_models/ && dart pub get
RUN cd packages/speakers_repository/ && dart pub get
RUN cd packages/talks_repository/ && dart pub get
RUN cd packages/user_repository/ && dart pub get
RUN dart pub get

# Copy app source code and AOT compile it.
COPY . .

# Generate a production build.
RUN dart pub global activate dart_frog_cli
RUN dart pub global run dart_frog_cli:dart_frog build

# Ensure packages are still up-to-date if anything has changed.
RUN dart pub get --offline
RUN dart compile exe build/bin/server.dart -o build/bin/server

# Build minimal serving image from AOT-compiled `/server` and required system
# libraries and configuration files stored in `/runtime/` from the build stage.
# Install necessary library dependencies to run. 
# libglib2.0-0 and libsecret-1-0 are required for the dart:ffi bindings in
# AmplifySecureStorage on Linux.
FROM --platform=amd64 debian:buster-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    libglib2.0-0 \
    libglib2.0-dev \
    libsecret-1-0 \
    libsecret-1-dev \
    && rm -rf /var/lib/apt/lists/*


COPY --from=build /runtime/ /
COPY --from=build /app/build/bin/server /app/bin/

# Set the working directory
WORKDIR /app

# Ensure the library path is set correctly
ENV LD_LIBRARY_PATH=/usr/lib/aarch64-linux-gnu:$LD_LIBRARY_PATH

# Start the server.
CMD ["/app/bin/server"]