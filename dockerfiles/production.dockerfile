FROM keymetrics/pm2:18-buster
 
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
RUN pm2 install pm2-server-monit
RUN npm install --production

COPY . /usr/notes-svc
RUN npm ci --only=production

COPY --chown=node:node . /usr/notes-svc
USER node

EXPOSE 5000

CMD [ "pm2-runtime", "start", "pm2.config.js" ]
