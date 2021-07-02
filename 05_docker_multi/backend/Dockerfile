FROM node:14

WORKDIR /app

COPY package.json .

RUN npm install

COPY . .

EXPOSE 80

ENV MONGODB_USERNAME root
# ENV MONGODB_USERNAME=root : this works as well
ENV MONGODB_PASSWORD secret

CMD ["npm", "start"]