.PHONY: build run shell clean

IMAGE_LABEL := local-x11-dev
VOLUME_LABEL := $(IMAGE_LABEL)-volume

build:
	docker build --tag $(IMAGE_LABEL) .

run:
	# If on WSL: $$DISPLAY should be set to your X display manager, e.g. '192.168.3.3:0.0'
	test $(DISPLAY) # If blank, then $$DISPLAY is not set
	docker run --net=host \
		--rm \
		--volume="$${XAUTHORITY}:/root/.Xauthority:rw" \
		--volume $(VOLUME_LABEL):/root \
		--env DISPLAY="${DISPLAY}" $(IMAGE_LABEL)

shell:
	# If on WSL: $$DISPLAY should be set to your X display manager, e.g. '192.168.3.3:0.0'
	test $(DISPLAY) # If blank, then $$DISPLAY is not set
	docker run --net=host \
		--rm --interactive --tty \
		--volume="$${XAUTHORITY}:/root/.Xauthority:rw" \
		--volume $(VOLUME_LABEL):/root \
		--env DISPLAY="${DISPLAY}" $(IMAGE_LABEL) \
		/bin/bash

clean:
	docker volume rm $(VOLUME_LABEL)
