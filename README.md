# Quick start with docker machine
In this project I show you through docker-machine, how is it easy to deploy a redis database and a webserver in two differents docker-machines.

This examples uses docker-machine and virtualbox as a driver, make sure you have both installed

## Create the machines
This command ```make create-machines``` will launch 2 docker-machines, redis-host and application-host

## Starting redis server
Two containers will be started, one redis master and the other a redis slave, the images came from google example guestbook
```make start-redis```

## Launch the webserver
You have to build the server image first ```make build-webserver``` and launch it ```start-webserver```

## Play with it
You can reach the server through the ip of the docker machine and the port 8080, you can know the ip of the docker machine by typing ```docker-machine ip application-host```

## Clean your environnement
Once you are done playing you can clean-up yours virtuals machines by typing ```make destroy-machines```
