SHELL := /bin/bash
#NO_CACHE=--no-cache
#??CCACHE:=-e CCACHE_DIR=/ccache --volumes-from CCACHE
DOCKERFILE=Dockerfile
ifeq ($(shell test -e $(DOCKERFILE).static && echo -n yes),yes)
    EXT=static
endif

ifeq ($(shell test -e docker-compose.yml && echo -n yes),yes)
    USE_COMPOSE:=yes
endif

DATE=$(shell /usr/bin/date +%y%m%d)
APP_NAME=$(shell basename $(PWD) | tr '[:upper:]' '[:lower:]')
APP_ID=$(shell docker images $(APP_NAME) -q|sort|uniq)
APP_OLD:=$(APP_NAME)-old
TMP_NAME=tmp-$(APP_NAME)
ifdef EXT
APP_NAME:=$(APP_NAME)-$(EXT)
DOCKERFILE:=$(DOCKERFILE).$(EXT)
endif
ifndef SRV
SRV:=$(APP_NAME)
endif
#POD=$(shell ${APP} ps --format "{{.Pod}}" --filter name=$(SRV))
ifdef POD
POD:=--pod $(POD)
endif

.PHONY: default help build compact hist diag

default: help

help:
ifdef USE_COMPOSE
	@echo "compose=$(USE_COMPOSE)"
	@echo "build images"
	@echo "create - run compose create "
	@echo "config - dump compose config "
else
	@echo "name=${APP_NAME}, $(DOCKERFILE)"
	@echo "build image "
endif
	@echo "compact image "
	@echo "hist - history"
	@echo "remove - remove image & container"
	@echo "stat - container status"
	@echo "save - export image"
	@echo "export - export rootfs to tar"
	@echo "load - import image "
	@echo "test - run image "
	@echo "diag - run security diag"
	@echo "sh [SRV=name] - run image as shell "

build:
#ifdef CCACHE
#	docker volume create --name=CCACHE
#endif
#ifneq ($(strip $($APP_ID)),)
#	@echo id=[$(APP_ID)]
#	docker rmi $(APP_OLD)
#	docker tag $(APP_ID) $(APP_OLD)
#endif
ifdef USE_COMPOSE
	docker compose build
else
	docker build --progress=plain $(NO_CACHE) -t ${APP_NAME}:${DATE} -t ${APP_NAME}:latest -f ./$(DOCKERFILE) .
endif

hist:
	@docker history ${APP_NAME}

export:
	docker run --rm --name $(TMP_NAME) -d --entrypoint /bin/sleep $(SRV) 5
	docker export -o ${SRV}.tar ${TMP_NAME}

compact:
	docker run --rm --name $(TMP_NAME) -d ${APP_NAME}
	@sleep 5
	docker export $(TMP_NAME) | docker import - ${APP_NAME}
	docker stop $(TMP_NAME)
#	docker rmi $(TMP_NAME)

remove:
	@docker rm $(APP_NAME)
	@docker rmi $(APP_NAME)

stat:
	@echo "name=$(APP_NAME) id=$(APP_ID)"
	@docker ps -a -f name=$(APP_NAME)

test:
	@docker run --rm --name $(TMP_NAME) -t $(APP_NAME)

sh:
ifdef USE_COMPOSE
	docker compose run --rm --entrypoint=sh $(SRV)
else
	docker run --rm --name $(TMP_NAME) -it --entrypoint /bin/sh $(APP_NAME)
endif

save:
	@docker save -o $(APP_NAME).tar $(APP_NAME)
	@gzip $(APP_NAME).tar

load:
	@cat $(APP_NAME).tar.gz| gunzip -c |docker load

config:
	@docker compose config

create:
ifndef USE_COMPOSE
	cd ..
endif
	docker compose create

diag:
	docker run --name diag-$(SRV) -it --rm $(POD) --net=container:$(SRV) diag
#	exit
#	LST=$$(/bin/ls)
#$$(docker ps --format "{{lower .Names}}"|sort));
#	echo $(LST)
#	echo $(cnt)
#	n=0; while [ -n "$${cnt[@]}" ];do
#	    echo $n". "$${cnt[@]}
#	    n=$$(($n+1))
#	done
#	
#	read -p "container: ?" CNT
#	CNT=$${cnt[$(CNT)]}
#	[ -z "$(CNT)" ] && exit
#	docker run --name diag -it --rm --net=container:$(CNT) diag
