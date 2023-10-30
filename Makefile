SHELL := /bin/bash -i
PYTHON_VERSION := 3.8
PYTHON := python$(PYTHON_VERSION)

help: 
	@grep -E '(^[0-9a-zA-Z_-]+:.*?##.*$$)' Makefile | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}'


conda-build: ## Create Python environement with conda for GPU.
conda-build:
	-( \
	test -f ~/activate/miniconda3 && . ~/activate/miniconda3 || true \
	&& conda env list | grep '^TSlib\s' > /dev/null  \
	|| conda create --name TSlib python=$(PYTHON_VERSION) -y \
	&& conda activate TSlib \
	&& pip install -U pip \
	&& pip install -r requirements.txt \
	&& pip install torch==1.7.0+cu110 torchvision==0.8.1+cu110 torchaudio==0.7.0 -f https://download.pytorch.org/whl/torch_stable.html \
	&& pip install -r requirements/install.txt \
	&& pip install -r requirements/jupyter.txt \
	)


conda-clean: ## Clean Python environement with conda for GPU.
conda-clean:
	-(\
	test -f ~/activate/miniconda3 && . ~/activate/miniconda3 || true \
	&& conda env remove --name TSlib \
	)

conda-startlab: ## Startlab Python environement with conda for GPU.
conda-startlab:
	-(\
	test -f ~/activate/miniconda3 && . ~/activate/miniconda3 || true \
	&& export PYTHONPATH="$$PWD":"$$PYTHONPATH" \
	&& conda activate TSlib \
	&& jupyter lab --no-browser \
	)


conda-download: ## Download all data.
conda-download:
	gdown 1pmXvqWsfUeXWCMz5fqsP8WLKXR5jxY8z

