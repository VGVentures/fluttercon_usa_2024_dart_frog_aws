# Official Dart image: https://hub.docker.com/_/dart
# Specify the Dart SDK base image version using dart:<version> (ex: dart:2.17)
FROM --platform=amd64 dart:stable AS build 

WORKDIR /app

# Install Node.js, npm, and system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    libglib2.0-0 \
    libglib2.0-dev \
    && curl -fsSL https://deb.nodesource.com/setup_14.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Resolve app dependencies.
COPY pubspec.* ./
COPY packages/fluttercon_data_source/pubspec.* ./packages/fluttercon_data_source/
COPY packages/fluttercon_shared_models/pubspec.* ./packages/fluttercon_shared_models/
COPY packages/talks_repository/pubspec.* ./packages/talks_repository/
COPY packages/user_repository/pubspec.* ./packages/user_repository/
COPY package*.json ./
RUN cd packages/fluttercon_data_source/ && dart pub get
RUN cd packages/fluttercon_shared_models/ && dart pub get
RUN cd packages/talks_repository/ && dart pub get
RUN cd packages/user_repository/ && dart pub get
RUN dart pub get
RUN npm install

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
FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /app/build/bin/server /app/bin/
# Uncomment the following line if you are serving static files.
# COPY --from=build /app/build/public /public/

# Start the server.
CMD ["/app/bin/server"]