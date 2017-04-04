create-machines:
	docker-machine create --driver virtualbox redis-master
	docker-machine create --driver virtualbox redis-slave
	docker-machine create --driver virtualbox application-host
	docker-machine ls

destroy-machines:
	docker-machine rm -y redis-master
	docker-machine rm -y redis-slave
	docker-machine rm -y application-host

start-redis:
	docker `docker-machine config redis-master` run -d -p 6379:6379 \
		 --name redis-master gcr.io/google_containers/redis:e2e
	
	docker `docker-machine config redis-slave` run -d -p 6379:6379 \
		-e REDIS_MASTER_SERVICE_HOST=`docker-machine ip redis-master` \
		-e GET_HOSTS_FROM=env \
		-e REDIS_MASTER_SERVICE_PORT=6379 \
                 --name redis-slave gcr.io/google_samples/gb-redisslave:v1

stop-redis:
	docker `docker-machine config redis-slave` rm -f redis-slave
	docker `docker-machine config redis-master` rm -f redis-master

build-webserver:
	cd app/ && docker `docker-machine config application-host` build -t webserver .

start-webserver:	
	docker `docker-machine config application-host` run -d -p 8080:80 \
		-e GET_HOSTS_FROM=env \
		-e REDIS_SLAVE_SERVICE_HOST=`docker-machine ip redis-slave` \
		-e REDIS_SLAVE_SERVICE_PORT=6379 \
		-e REDIS_MASTER_SERVICE_HOST=`docker-machine ip redis-master` \
		-e REDIS_MASTER_SERVICE_PORT=6379 \
		webserver
	echo Your server is now running here: http://`docker-machine ip application-host`:8080

