.PHONY: *

test.local:
	@./run_tests

build.opm: test.local
	@opm build

upload.opm: build.local
	@opm upload

test.docker:
	@docker run -ti --rm \
		-v ${PWD}:/build \
		--entrypoint /bin/sh \
		openresty/openresty:alpine-fat \
		-c "cd /build && ./run_tests"

build.docker: test.docker
	@docker run -ti --rm \
		-v ${PWD}:/build \
		-v ${HOME}/.opmrc:/root/.opmrc:ro \
		--entrypoint /bin/sh \
		openresty/openresty:alpine-fat \
		-c "cd /build && opm build"

upload.docker: build.docker
	@docker run -ti --rm \
		-v ${PWD}:/build \
		-v ${HOME}/.opmrc:/root/.opmrc:ro \
		--entrypoint /bin/sh \
		openresty/openresty:alpine-fat \
		-c "cd /build && opm upload"

clean:
mrproper: clean
	rm -rf darkside-*
