# Use the base image 'ubuntu:bionic'
FROM ubuntu:bionic AS base
# Update the package repository
# Install necessary packages
RUN apt-get update && \
    apt-get install -y \
        ca-certificates \
        wget && \
    update-ca-certificates
# Define the Hugo version
ARG HUGO_VERSION="0.125.4"
# Download and install Hugo
RUN wget --quiet "https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_Linux-64bit.tar.gz" && \
    tar xzf hugo_${HUGO_VERSION}_Linux-64bit.tar.gz && \
    rm -r hugo_${HUGO_VERSION}_Linux-64bit.tar.gz && \
    mv hugo /usr/bin && \
    chmod 755 /usr/bin/hugo

FROM node:latest AS Prod
## Hugo source code
COPY --from=base /usr/bin/hugo /usr/bin/hugo
# Set the working directory to '/src'
WORKDIR /src
# Copy code into the '/src' directory
RUN npm i -D postcss postcss-cli autoprefixer

COPY ./ /src
# Command to run when the container starts
CMD ["hugo", "server", "--bind", "0.0.0.0"]

EXPOSE 1313
