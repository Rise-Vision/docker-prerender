NAME=prerender
REPO=rise-vision/$(NAME)
VERSION=1.0.0
CHECK_CONTAINER=docker ps -a | awk '{ print $$2 }' | grep -q -F $(REPO):$(VERSION)
CHECK_RUNNING_CONTAINER=docker ps | awk '{ print $$2 }' | grep -q -F $(REPO):$(VERSION)


.PHONY: bash start stop remove clean build push runbash cleanbuild

all: build

build:
		docker build -t $(REPO):$(VERSION) .

push:
		docker push $(REPO)

run:
		@if !CHECK_CONTAINER; then \
			docker run -d --name $(NAME) $(REPO):$(VERSION); \
		fi


stop:
		@if CHECK_RUNNING_CONTAINER; then \
			docker stop $(NAME); \
		fi


start:
		@if !CHECK_RUNNING_CONTAINER; then \
			docker start $(NAME); \
		fi

remove:
		@if CHECK_CONTAINER; then \
			docker rm -f $(NAME); \
		fi


bash: CMD = bash
bash: build runbash

runbash:
		docker run -t -i -d $(REPO):$(VERSION) $(CMD)

clean:
		@if docker images $(REPO) | awk '{ print $$2 }' | grep -q -F $(REPO):$(VERSION); then\
			docker rmi $(REPO):latest $(REPO):$(VERSION) || true;\
		fi

cleanbuild: stop remove clean build


