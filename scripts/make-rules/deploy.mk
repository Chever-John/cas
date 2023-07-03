# ==============================================================================
# Makefile helper functions for deploy to developer env
#

KUBECTL := kubectl
NAMESPACE ?= cas
CONTEXT ?= chever-john.dev

DEPLOYS=cas-apiserver

.PHONY: deploy.run.all
deploy.run.all:
	@echo "===========> Deploying all"
	@$(MAKE) deploy.run

.PHONY: deploy.run
deploy.run: $(addprefix deploy.run., $(DEPLOYS))

.PHONY: deploy.run.%
deploy.run.%:
	$(eval ARCH := $(word 2,$(subst _, ,$(PLATFORM))))
	@echo "===========> Deploying $* $(VERSION)-$(ARCH)"
	echo @$(KUBECTL) -n $(NAMESPACE) --context=$(CONTEXT) set image deployment/$* $*=$(REGISTRY_PREFIX)/$*-$(ARCH):$(VERSION)
