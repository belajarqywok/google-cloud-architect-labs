FROM node:18-buster
 
LABEL creator="al-fariqy raihan"

LABEL twitter="@FariqyAl"
LABEL github="@belajarqywok"
LABEL instagram="@otw.mastah"
LABEL email="alfariqyraihan@gmail.com"

WORKDIR /usr/notes-svc
COPY package*.json /usr/notes-svc

ENV NODE_ENV production
ENV NPM_CONFIG_LOGLEVEL warn

RUN apt-get update && \
    apt-get upgrade -y
RUN npm install --production

COPY . /usr/notes-svc
RUN npm ci --only=production

COPY --chown=node:node . /usr/notes-svc
USER node

EXPOSE 5000

CMD [ "npm", "start" ]
