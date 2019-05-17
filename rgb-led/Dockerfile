FROM balenalib/raspberrypi3-node:10-build AS build

# Defines our working directory in container
WORKDIR /usr/src/app

# Copy the package.json first for better cache on later pushes
COPY ./app/package.json package.json

# Install the building dependencies - we will get rid of them contextually so no additional size will be added to our layer
RUN install_packages python
RUN npm install --unsafe-perm --production && npm cache clean --force

FROM balenalib/raspberrypi3-node:10

WORKDIR /usr/src/app

COPY --from=build /usr/src/app/node_modules ./node_modules

# Move our scripts in the root to the working directory in the container
COPY ./app/ ./

# Start app
CMD npm start
