# renovate: datasource=docker packageName=adguard/adguardhome versioning=docker
export ADGUARD_VERSION?=v0.107.67

# local build
build: PUSH=
build: PULL=
build:
	docker buildx bake -f docker/compose.yml $(PUSH) $(PULL)
.PHONY: build

# build with github actions
ci-build:
	docker buildx bake -f docker/compose.ci.yml --pull --push
.PHONY: ci-build


## Manage docker builders
builder-create:
	docker buildx create --platform linux/amd64,linux/arm64 --name builder --use --bootstrap
.PHONY: builder-create

builder-%:
	docker buildx use $*
.PHONY: builder-%

builder-rm:
	docker buildx rm builder
.PHONY: builder-rm
