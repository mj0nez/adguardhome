
build: PUSH=
build: PULL=
build:
	docker buildx bake -f docker/compose.ci.yml $(PUSH) $(PULL)
.PHONY: build
