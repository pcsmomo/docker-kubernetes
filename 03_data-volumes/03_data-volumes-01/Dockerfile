FROM node:14

WORKDIR /app

COPY package.json .

RUN npm install

COPY . .

ENV PORT 80

EXPOSE $PORT

# VOLUME [ "/app/node_modules" ] 
# VOLUME [ "/temp" ] 

CMD ["npm", "start"]