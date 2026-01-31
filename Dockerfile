FROM node:20.15.1-alpine

# Install Hugo v0.48
RUN apk add --no-cache wget libc6-compat \
    && wget -q https://github.com/gohugoio/hugo/releases/download/v0.48/hugo_0.48_Linux-64bit.tar.gz \
    && tar -xzf hugo_0.48_Linux-64bit.tar.gz -C /usr/local/bin hugo \
    && rm hugo_0.48_Linux-64bit.tar.gz

WORKDIR /site

COPY package.json package-lock.json ./
RUN npm install

COPY . .

EXPOSE 1313

CMD ["hugo", "server", "-D", "--bind", "0.0.0.0"]
