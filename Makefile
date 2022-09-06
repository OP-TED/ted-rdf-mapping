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
XML_PROCESSOR_PATH = ${PROJECT_PATH}/.saxon/saxon-he-10.6.jar
LOCAL_ID_MANAGER_API_HOST = localhost
LOCAL_ID_MANAGER_API_PORT = 8000
AGRAPH_SUPER_PASSWORD = admin56GHhgfd*9
AGRAPH_SUPER_USER = admin
ALLEGRO_HOST = https://agraph.ted-data.eu

#-----------------------------------------------------------------------------
# Dev commands
#-----------------------------------------------------------------------------
setup: install install-rmlmapper init-saxon local-dotenv-file

install:
	@ echo -e "$(BUILD_PRINT)Installing the requirements$(END_BUILD_PRINT)"
	@ pip install --upgrade pip
	@ pip install --upgrade --force-reinstall -r requirements.txt

install-custom:
	@ echo -e "$(BUILD_PRINT)Installing the requirements$(END_BUILD_PRINT)"
	@ pip install --upgrade pip
	@ pip install --upgrade --force-reinstall git+https://github.com/OP-TED/ted-rdf-conversion-pipeline@$(or $(TED_SWS_BRANCH),main)#egg=ted-sws

dev-dotenv-file: rml-mapper-path-add-dotenv-file saxon-path-add-dotenv-file dev-secrets-dotenv-file

local-dotenv-file: rml-mapper-path-add-dotenv-file saxon-path-add-dotenv-file local-secrets-dotenv-file

rml-mapper-path-add-dotenv-file:
	@ echo -e "$(BUILD_PRINT)Add rml-mapper path to local .env file $(END_BUILD_PRINT)"
	@ sed -i '/^RML_MAPPER_PATH/d' .env
	@ echo RML_MAPPER_PATH=${RML_MAPPER_PATH} >> .env

dev-secrets-dotenv-file:
	@ vault kv get -format="json" ted-dev/ted-sws | jq -r ".data.data | keys[] as \$$k | \"\(\$$k)=\(.[\$$k])\"" >> .env

local-secrets-dotenv-file:
	@ echo -e "$(BUILD_PRINT)Add local secrets to local .env file $(END_BUILD_PRINT)"
	@ sed -i '/^ID_MANAGER_API_HOST/d' .env
	@ echo ID_MANAGER_API_HOST=${LOCAL_ID_MANAGER_API_HOST} >> .env
	@ sed -i '/^ID_MANAGER_API_PORT/d' .env
	@ echo ID_MANAGER_API_PORT=${LOCAL_ID_MANAGER_API_PORT} >> .env
	@ sed -i '/^AGRAPH_SUPER_PASSWORD/d' .env
	@ echo AGRAPH_SUPER_PASSWORD=${AGRAPH_SUPER_PASSWORD} >> .env
	@ sed -i '/^AGRAPH_SUPER_USER/d' .env
	@ echo AGRAPH_SUPER_USER=${AGRAPH_SUPER_USER} >> .env
	@ sed -i '/^ALLEGRO_HOST/d' .env
	@ echo ALLEGRO_HOST=${ALLEGRO_HOST} >> .env

install-rmlmapper:
	@ mkdir -p ./.rmlmapper
	@ wget -c https://api.bitbucket.org/2.0/repositories/Dragos0000/rml-mapper/src/master/rmlmapper.jar -P ./.rmlmapper

init-saxon:
	@ echo -e "$(BUILD_PRINT)Saxon folder initialization $(END_BUILD_PRINT)"
	@ wget -c https://kumisystems.dl.sourceforge.net/project/saxon/Saxon-HE/10/Java/SaxonHE10-6J.zip -P .saxon/
	@ cd .saxon && unzip SaxonHE10-6J.zip && rm -rf SaxonHE10-6J.zip

saxon-path-add-dotenv-file:
	@ echo -e "$(BUILD_PRINT)Add Saxon path to local .env file $(END_BUILD_PRINT)"
	@ sed -i '/^XML_PROCESSOR_PATH/d' .env
	@ echo XML_PROCESSOR_PATH=${XML_PROCESSOR_PATH} >> .env

clear-output:
	@ rm -rf mappings/$(id)/output/*
	@ rm -rf mappings/$(id)/validation/sparql/cm_assertions/*

install-dev:
	@ echo -e "$(BUILD_PRINT)Installing the requirements$(END_BUILD_PRINT)"
	@ pip install --upgrade --force-reinstall --no-deps ../ted-sws
