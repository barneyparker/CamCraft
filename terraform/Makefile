# http://clarkgrubb.com/makefile-style-guide

MAKEFLAGS += --warn-undefined-variables --no-print-directory
SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := all
.DELETE_ON_ERROR:
.SUFFIXES:

REGION=eu-west-1
STACK=camcraft
TF_STATE_BUCKET=pwp-tfstate
TF_STATE_FILE=tf-state-$(STACK).tfstate

ifndef AWS_PROFILE
$(error AWS_PROFILE not set)
endif

export AWS_DEFAULT_REGION=$(REGION)
$(info Stack: $(STACK))
$(info State: $(TF_STATE_BUCKET)/$(TF_STATE_FILE))

.PHONY: all
all: tfclean tfinit tffmt tfplan

.PHONY: apply
apply: tfclean tfinit tffmt tfapply

.PHONY: destroy
destroy: tfdestroy

.PHONY: tfclean
tfclean:
	@rm -fr .terraform/modules
	@rm -fr .terraform/terraform.tfstate*
	@rm -fr .terraform/*zip

.PHONY: tfinit
tfinit:
	@terraform init -backend-config="bucket=$(TF_STATE_BUCKET)" -backend-config="key=$(TF_STATE_FILE)"

.PHONY: tffmt
tffmt:
	@terraform fmt

.PHONY: tfplan
tfplan:
	@terraform plan -out ./terraform.plan

.PHONY: tfapply
tfapply:
	@terraform apply ./terraform.plan
	@rm -r terraform.plan

.PHONY: tfdestroy
tfdestroy:
	@terraform destroy
