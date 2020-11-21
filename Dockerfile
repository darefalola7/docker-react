#Use an existing docker image as a base
#as builder - everything under the as builder will be referred to as the builder phase
FROM node:15.2.0-alpine3.10 as builder

#Any subsequent command will be executed
#relative to this path in the container
WORKDIR /app

#Move file from local machine into the temporary container
#First path is path to folder in local FS to path in container
#first path is relative to the build context (e.g. simpleweb)
#based on WORKDIR second ./ will be workdir directory
COPY ./package.json ./

#Download and install a dependency
#RUN npm cache clean --force
RUN npm install --force

COPY . .

#build project
RUN npm run build


#FROM means start new phase
FROM nginx
EXPOSE 80
#--from=builder means copy from the builder phase
COPY --from=builder /app/build /usr/share/nginx/html


#NGINX has default start command
