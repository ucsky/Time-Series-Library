SHELL := /bin/bash -i
PYTHON_VERSION := 3.8
PYTHON := python$(PYTHON_VERSION)

include .local.env
.local.env:
	-@(touch .local.env)

help: 
	@grep -E '(^[0-9a-zA-Z_-]+:.*?##.*$$)' Makefile | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}'


conda-build: ## Create Python environement with conda for GPU.
conda-build:
	-( \
	conda env list | grep '^TSlib\s' > /dev/null  \
	|| conda create --name TSlib python=$(PYTHON_VERSION) -y \
	&& conda activate TSlib \
	&& pip install -U pip \
	&& pip install -r requirements.txt \
	&& pip install torch==1.7.0+cu110 torchvision==0.8.1+cu110 torchaudio==0.7.0 -f https://download.pytorch.org/whl/torch_stable.html \
	&& pip install -r requirements/install.txt \
	&& pip install -r requirements/jupyter.txt \
	)


conda-download-all: ## Download all data.
conda-download-all:
	-(\
	conda activate TSlib \
	&& gdown 1pmXvqWsfUeXWCMz5fqsP8WLKXR5jxY8z \
	)

conda-startlab: ## Startlab Python environement with conda for GPU.
conda-startlab:
	-(\
	conda activate TSlib \
	&& export PYTHONPATH="$$PWD":"$$PYTHONPATH" \
	&& conda activate TSlib \
	&& jupyter lab --no-browser \
	)



conda-run-imp-weather-timesnet: ## Run imputatoin task with TimesNet for Weather.
conda-run-imp-weather-timesnet: scripts/imputation/Weather_script/TimesNet.sh 
	-(\
	conda activate TSlib \
	&& export CUDA_VISIBLE_DEVICES=$(CUDA_VISIBLE_DEVICES) \
	&& bash $< \
	)


conda-clean: ## Clean Python environement with conda for GPU.
conda-clean:
	-(\
	conda deactivate \
	&& conda env remove --name TSlib \
	)
