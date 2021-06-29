FROM node

WORKDIR /app

COPY package.json /app
# COPY package.json .   // equivalent 

RUN npm install

COPY . /app

EXPOSE 80

CMD ["node", "server.js"]