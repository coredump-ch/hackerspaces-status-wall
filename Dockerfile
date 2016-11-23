FROM node:0.12
MAINTAINER Danilo Bargen <mail at dbrgn dot ch>

# Add source code
RUN mkdir /code
COPY . /code
WORKDIR /code

# Install dependencies
RUN npm install
