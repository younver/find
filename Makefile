NAME = find
CE = docker

## help@ print this help message
help:
	@echo "Usage:"
	@sed -n 's/^##//p' ${MAKEFILE_LIST} | column -t -s "@" | sed -e 's/^/  /'

## down@ stop and remove the container
down:
	-$(CE) stop $(NAME)
	-$(CE) rm $(NAME)

## run@ build and run the container
export LOG=true
run:
	make down
	$(CE) build --tag $(NAME) .
	$(CE) run --publish 9000:9000 --publish 9099:9099 --publish 4000:4000 --name $(NAME) $(NAME)
	! $(LOG) || $(CE) logs --follow $(NAME)
