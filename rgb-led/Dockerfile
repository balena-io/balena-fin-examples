################################################################################
# Base image
################################################################################

FROM balenalib/fincm3:build as base

ENV INITSYSTEM=on
ENV DEBIAN_FRONTEND=noninteractive

################################################################################
# Rust image
################################################################################

FROM base as rust

# Get the balenaFin CLI to build
WORKDIR /build
RUN git clone https://github.com/balena-io-playground/fin-rs.git app

ENV PATH=/root/.cargo/bin:$PATH

# Install rustup downloading the version specified by the standard rust-toolchain file
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y

################################################################################
# Dependencies
################################################################################

FROM rust as dependencies

WORKDIR /build

WORKDIR /build/app

# Build fake project with real dependencies
RUN cargo build --release

# Remove the fake app build artifacts
RUN rm -rf target/release/fin* target/release/deps/fin-*

################################################################################
# Builder
################################################################################

FROM rust as clibuilder

# We do not want to download deps, update registry, ... again
COPY --from=dependencies /root/.cargo /root/.cargo

WORKDIR /build/app

# Update already built deps from dependencies image
COPY --from=dependencies /build/app/target target

# Build real app
RUN cargo build --release

RUN strip target/release/fin


################################################################################
# Node module builder
################################################################################
FROM balenalib/fincm3-node:10-build AS nodebuild

# Defines our working directory in container
WORKDIR /usr/src/app

# Copy the package.json first for better cache on later pushes
COPY ./app/package.json package.json

# Install the building dependencies - we will get rid of them contextually so no additional size will be added to our layer
RUN install_packages python
RUN npm install --unsafe-perm --production && npm cache clean --force


################################################################################
# Final image
################################################################################
FROM balenalib/fincm3-node:10

WORKDIR /usr/src/app

COPY --from=nodebuild /usr/src/app/node_modules ./node_modules

# Move our scripts in the root to the working directory in the container
COPY ./app/ ./

# Copy fin-cli binary from builder image
COPY --from=clibuilder /build/app/target/release/fin /usr/bin/

# Start app
CMD npm start
