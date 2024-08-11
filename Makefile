NAME=inception
	# mkdir -p /home/hgu/data
	# mkdir -p /home/hgu/data/DB
	# mkdir -p /home/hgu/data/wordpress
	# chmod 777 /home/hgu/data/DB
	# chmod 777 /home/hgu/data/wordpress

all: $(NAME)

$(NAME):
	# mkdir -p /Users/guhyeokmo/Desktop/42/data/hgu/wordpress
	# mkdir -p /Users/guhyeokmo/Desktop/42/data/hgu/DB
	mkdir -p /home/hgu/data
	mkdir -p /home/hgu/data/DB
	mkdir -p /home/hgu/data/wordpress
	# chmod 777 /home/hgu/data/DB
	# chmod 777 /home/hgu/data/wordpress
	docker-compose -f ./srcs/docker-compose.yml up --build -d

down:
	docker-compose -f ./srcs/docker-compose.yml down

# clean:
# 	docker-compose -f ./srcs/docker-compose.yml down
# 	docker-volume rm srcs_mariaDB_volume
# 	docker-volume rm srcs_wordpress_volume
# 	rm -rf /home/hgu/data

re: clean all

.PHONY : all clean down re 