SHELL=/bin/bash -o pipefail
BUILD_PRINT = \e[1;34mSTEP:
END_BUILD_PRINT = \e[0m

CURRENT_UID := $(shell id -u)
export CURRENT_UID
# These are constants used for make targets so we can start prod and staging services on the same machine
ENV_FILE := .env

# include .env files if they exist
-include .env

PROJECT_PATH = $(shell pwd)
RML_MAPPER_PATH = ${PROJECT_PATH}/.rmlmapper/rmlmapper.jar
LOCAL_ID_MANAGER_API_HOST = localhost
LOCAL_ID_MANAGER_API_PORT = 8000

#-----------------------------------------------------------------------------
# Dev commands
#-----------------------------------------------------------------------------
setup: install install-rmlmapper local-dotenv-file

install:
	@ echo -e "$(BUILD_PRINT)Installing the requirements$(END_BUILD_PRINT)"
	@ pip install --upgrade pip
	@ pip install --upgrade --force-reinstall -r requirements.txt

dev-dotenv-file: rml-mapper-path-add-dotenv-file dev-secrets-dotenv-file

local-dotenv-file: rml-mapper-path-add-dotenv-file local-secrets-dotenv-file

rml-mapper-path-add-dotenv-file:
	@ echo -e "$(BUILD_PRINT)Add rml-mapper path to local .env file $(END_BUILD_PRINT)"
	@ sed -i '/^RML_MAPPER_PATH/d' .env
	@ echo RML_MAPPER_PATH=${RML_MAPPER_PATH} >> .env

dev-secrets-dotenv-file:
	@ vault kv get -format="json" ted-dev/ted-sws | jq -r ".data.data | keys[] as \$$k | \"\(\$$k)=\(.[\$$k])\"" >> .env

local-secrets-dotenv-file:
	@ echo -e "$(BUILD_PRINT)Add API config to local .env file $(END_BUILD_PRINT)"
	@ sed -i '/^ID_MANAGER_API_HOST/d' .env
	@ echo ID_MANAGER_API_HOST=${LOCAL_ID_MANAGER_API_HOST} >> .env
	@ sed -i '/^ID_MANAGER_API_PORT/d' .env
	@ echo ID_MANAGER_API_PORT=${LOCAL_ID_MANAGER_API_PORT} >> .env

install-rmlmapper:
	@ mkdir -p ./.rmlmapper
	@ wget -c https://api.bitbucket.org/2.0/repositories/Dragos0000/rml-mapper/src/master/rmlmapper.jar -P ./.rmlmapper

clear-output:
	@ rm -rf mappings/$(id)/output/*
	@ rm -rf mappings/$(id)/validation/sparql/cm_assertions/*

install-dev:
	@ echo -e "$(BUILD_PRINT)Installing the requirements$(END_BUILD_PRINT)"
	@ pip install --upgrade --force-reinstall --no-deps ../ted-sws
