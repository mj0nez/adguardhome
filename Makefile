

# ADGUARD_VERSION:=""

build: PUSH=
build: PULL=
build:
	docker --debug buildx bake -f docker/compose.ci.yml $(PUSH) $(PULL)
.PHONY: build
