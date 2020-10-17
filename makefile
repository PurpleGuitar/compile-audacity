.PHONY: build run shell

IMAGE_LABEL := build-audacity

build:
	docker build --tag $(IMAGE_LABEL) .

run:
	# If on WSL: $$DISPLAY should be set to your X display manager, e.g. '192.168.3.3:0.0'
	test $(DISPLAY) # If blank, then $$DISPLAY is not set
	docker run --net=host \
		--rm \
		--volume="/tmp/audacity-working:/root/working" \
		--volume="/tmp/.audacity-data:/root/.audacity-data" \
		--volume="$${XAUTHORITY}:/root/.Xauthority:rw" \
		--env DISPLAY="${DISPLAY}" \
		--device /dev/snd \
		$(IMAGE_LABEL)

testx:
	# If on WSL: $$DISPLAY should be set to your X display manager, e.g. '192.168.3.3:0.0'
	test $(DISPLAY) # If blank, then $$DISPLAY is not set
	docker run --net=host \
		--rm \
		--volume="$${XAUTHORITY}:/root/.Xauthority:rw" \
		--env DISPLAY="${DISPLAY}" \
		$(IMAGE_LABEL) \
		xlogo

shell:
	# If on WSL: $$DISPLAY should be set to your X display manager, e.g. '192.168.3.3:0.0'
	test $(DISPLAY) # If blank, then $$DISPLAY is not set
	docker run --net=host \
		--rm --interactive --tty \
		--volume="/tmp/audacity-working:/root/working" \
		--volume="/tmp/.audacity-data:/root/.audacity-data" \
		--volume="$${XAUTHORITY}:/root/.Xauthority:rw" \
		--env DISPLAY="${DISPLAY}" \
		--device /dev/snd \
		$(IMAGE_LABEL) \
		/bin/bash

copy-release:
	docker run --rm \
		--volume="/tmp/Audacity:/output" \
		$(IMAGE_LABEL) \
		cp -rp /root/audacity/build/bin/Release /output

