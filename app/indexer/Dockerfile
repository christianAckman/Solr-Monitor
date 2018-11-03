FROM node:10.5

WORKDIR /app

COPY package*.json /app/

RUN npm install

COPY ./ /app/

# ARG configuration=production


# RUN npm run build -- --output-path=./dist/out --configuration $configuration


CMD ["bash", "start.sh"]