all:
	scripts/setup_script.sh
#scripts/app.sh
dd:
	sudo docker rm -f $$(sudo docker ps -aq)
	sudo docker system prune -a
	sudo docker volume rm $$(sudo docker volume ls)