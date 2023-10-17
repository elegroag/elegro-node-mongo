FROM node:18

RUN apt-get update
RUN apt-get install vim -y

RUN mkdir -p /home/node/app/node_modules && chmod -R 0777 /home/node

WORKDIR /home/node/app

COPY ./package.json .

RUN npm install --quiet

RUN npm instal nodemon -g

EXPOSE 3001

CMD [ "node", "app.js" ]