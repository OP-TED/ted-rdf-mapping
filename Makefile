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

#-----------------------------------------------------------------------------
# Dev commands
#-----------------------------------------------------------------------------
setup: install local-dotenv-file install-rmlmapper

install:
	@ echo -e "$(BUILD_PRINT)Installing the requirements$(END_BUILD_PRINT)"
	@ pip install --upgrade pip
	@ pip install --upgrade --force-reinstall -r requirements.txt

local-dotenv-file:
	@ echo -e "$(BUILD_PRINT)Add rml-mapper path to local .env file $(END_BUILD_PRINT)"
	@ sed -i '/^RML_MAPPER_PATH/d' .env
	@ echo RML_MAPPER_PATH=${RML_MAPPER_PATH} >> .env

install-rmlmapper:
	@ mkdir ./.rmlmapper
	@ wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1MckjzpvrCoChy_IRYC2S54tf3dFQNwEt' -O- | sed -rn \'s/.*confirm=\([0-9A-Za-z_]+).*/\1\n/p\'\)&id=1MckjzpvrCoChy_IRYC2S54tf3dFQNwEt" -O ./.rmlmapper/rmlmapper.jar && rm -rf /tmp/cookies.txt

