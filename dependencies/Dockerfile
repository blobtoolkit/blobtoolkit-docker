FROM ubuntu:18.04
LABEL maintainer="blobtoolkit@genomehubs.org"
LABEL license="MIT"
LABEL version="1.3"

RUN apt-get update && apt-get -y install \
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

WORKDIR /tmp

RUN wget ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.10.1/ncbi-blast-2.10.1+-x64-linux.tar.gz && \
    tar xzf ncbi-blast-2.10.1+-x64-linux.tar.gz && \
    mv ncbi-blast-2.10.1+ /usr/local/ncbi-blast && \
    rm ncbi-blast-2.10.1+-x64-linux.tar.gz

ENV PATH /usr/local/ncbi-blast/bin:${PATH}

USER blobtoolkit

WORKDIR /tmp

RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh

RUN printf '\nyes\n\n' | bash Miniconda3-latest-Linux-x86_64.sh

ARG CONDA_DIR=/home/blobtoolkit/miniconda3

RUN echo ". $CONDA_DIR/etc/profile.d/conda.sh" >> ~/.bashrc

RUN $CONDA_DIR/bin/conda create -n btk_env -c bioconda -c conda-forge -c anaconda -y \
    python=3.7 \
    docopt \
    drmaa \
    geckodriver \
    nodejs=10 \
    psutil \
    pysam \
    pyvirtualdisplay \
    pyyaml \
    selenium \
    seqtk \
    snakemake=5.20 \
    tqdm \
    ujson \
    yq \
    bamtools>=2.5.1 \
    bamutil>=1.0.14 \
    bwa>=0.7.17 \
    minimap2>=2.11 \
    ncurses \
    samtools>=1.7 \
    diamond>=0.9.30 \
    parallel>=20170422 \
    seqtk>=1.2 \
    aria2 \
    curl \
    pigz \
    rsync \
    tar \
    libiconv

RUN $CONDA_DIR/envs/btk_env/bin/pip install fastjsonschema

RUN $CONDA_DIR/bin/conda create -n busco3_env -c bioconda -c conda-forge -y \
    blast=2.2 \
    busco=3 \
    docopt \
    yq

RUN $CONDA_DIR/bin/conda create -n busco4_env -c bioconda -c conda-forge -y \
    busco=4.0.6

RUN mkdir -p /blobtoolkit/wrappers \
    && mkdir -p /blobtoolkit/.conda

COPY busco3_wrapper.sh /blobtoolkit/wrappers/run_busco

COPY busco4_wrapper.sh /blobtoolkit/wrappers/busco

