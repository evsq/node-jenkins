FROM node:12

WORKDIR /usr/src/app

COPY . .

RUN npm install  
RUN npm install -g jest 

EXPOSE 3000 
EXPOSE 80 
 
CMD ["npm", "start"]
