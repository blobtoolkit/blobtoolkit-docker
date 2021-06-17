FROM ubuntu:20.04
LABEL maintainer="blobtoolkit@genomehubs.org"
LABEL license="MIT"
LABEL version="2.6.0"

ENV CONTAINER_VERSION=2.6.0

RUN apt-get update \
    && DEBIAN_FRONTEND="noninteractive" apt-get -y install \
    build-essential \
    dbus-x11 \
    firefox \
    git \
    rsync \
    wget \
    xvfb \
    x11-utils

RUN mkdir -p /blobtoolkit/conf \
    && mkdir -p /blobtoolkit/data \
    && mkdir -p /blobtoolkit/databases/busco \
    && mkdir -p /blobtoolkit/databases/ncbi_db \
    && mkdir -p /blobtoolkit/databases/ncbi_taxdump \
    && mkdir -p /blobtoolkit/databases/uniprot_db \
    && mkdir -p /blobtoolkit/datasets \
    && mkdir -p /blobtoolkit/output

RUN useradd -m blobtoolkit \
    && chown -R blobtoolkit:blobtoolkit /blobtoolkit

USER blobtoolkit

WORKDIR /tmp

RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh

RUN printf '\nyes\n\n' | bash Miniconda3-latest-Linux-x86_64.sh

ARG CONDA_DIR=/home/blobtoolkit/miniconda3

RUN echo ". $CONDA_DIR/etc/profile.d/conda.sh" >> ~/.bashrc

COPY env.yaml /blobtoolkit/env.yaml

RUN $CONDA_DIR/bin/conda env create -f /blobtoolkit/env.yaml

RUN mkdir -p /blobtoolkit/.conda

WORKDIR /blobtoolkit

RUN git clone -b release/v2.6.0 https://github.com/blobtoolkit/blobtools2 \
    && git clone -b release/v2.6.0 https://github.com/blobtoolkit/insdc-pipeline \
    && git clone -b release/v2.6.0 https://github.com/blobtoolkit/specification \
    && git clone -b release/v2.6.0 https://github.com/blobtoolkit/viewer

ENV CONDA_DEFAULT_ENV btk_env

ARG CONDA_DIR=/home/blobtoolkit/miniconda3

ENV PATH $CONDA_DIR/bin:/blobtoolkit/blobtools2:/blobtoolkit/specification:$CONDA_DIR/envs/btk_env/bin:$PATH

WORKDIR /blobtoolkit/viewer

RUN npm install

WORKDIR /blobtoolkit/databases/ncbi_taxdump

RUN curl -L ftp://ftp.ncbi.nih.gov/pub/taxonomy/new_taxdump/new_taxdump.tar.gz | tar xzf -;

ENV PYTHONPATH $CONDA_DIR/envs/btk_env/lib/python3.8/site-packages:$PYTHONPATH

RUN printf '>seq\nACGT\n' > /tmp/assembly.fasta \
    && blobtools create --fasta /tmp/assembly.fasta --taxid 3702 --taxdump ./ /tmp/dataset \
    && rm -r /tmp/*

WORKDIR /blobtoolkit

COPY startup.sh /blobtoolkit

COPY .env /blobtoolkit/viewer

EXPOSE 8000 8080

CMD /blobtoolkit/startup.sh
