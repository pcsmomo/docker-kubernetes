FROM node:14

# ARG DEFAULT_PORT=80  # if it is here, RUN npm install will run every time.

WORKDIR /app

COPY package.json .

RUN npm install

COPY . .

ARG DEFAULT_PORT=80

ENV PORT $DEFAULT_PORT

EXPOSE $PORT

# VOLUME [ "/app/node_modules" ] 
# VOLUME [ "/temp" ] 

CMD ["npm", "start"]