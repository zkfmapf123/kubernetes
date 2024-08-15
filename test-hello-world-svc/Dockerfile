ARG NODE_VERSION=18.19.0

FROM node:${NODE_VERSION}-alpine

ENV VERSION 1.0.0
ENV PORT 3000

WORKDIR /usr/src/app
COPY . .

RUN npm install
RUN npm ci --omit=dev

# Expose the port that the application listens on.
EXPOSE 3000

# Run the application.
CMD npm start
