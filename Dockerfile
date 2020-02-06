FROM ubuntu:18.04
LABEL maintainer="blobtoolkit@genomehubs.org"
LABEL license="MIT"
LABEL version="1.0"

RUN apt-get update && apt-get -y install \
    build-essential \
    firefox \
    git \
    wget \
    xvfb \
    x11-utils

RUN mkdir -p /blobtoolkit/datasets && mkdir -p /blobtoolkit/conf

RUN useradd -m blobtoolkit \
    && chown -R blobtoolkit:blobtoolkit /blobtoolkit

USER blobtoolkit

WORKDIR /tmp

RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh

RUN printf '\nyes\n\n' | bash Miniconda3-latest-Linux-x86_64.sh

ARG CONDA_DIR=/home/blobtoolkit/miniconda3

RUN echo ". $CONDA_DIR/etc/profile.d/conda.sh" >> ~/.bashrc

RUN $CONDA_DIR/bin/conda create -n btk_env -c bioconda -c conda-forge -c anaconda -y \
    python=3.6 \
    docopt \
    drmaa \
    geckodriver \
    nodejs=10 \
    pysam \
    pyvirtualdisplay \
    pyyaml \
    selenium \
    seqtk \
    snakemake=4.5 \
    tqdm \
    ujson \
    yq

RUN $CONDA_DIR/envs/btk_env/bin/pip install fastjsonschema

WORKDIR /blobtoolkit

ARG CACHE_BUSTER=a2f62c4c

RUN git clone https://github.com/blobtoolkit/blobtools2 \
    && git clone https://github.com/blobtoolkit/insdc-pipeline \
    && git clone https://github.com/blobtoolkit/specification \
    && git clone https://github.com/blobtoolkit/viewer

ENV CONDA_DEFAULT_ENV btk_env

ENV PATH $CONDA_DIR/envs/btk_env/bin:$PATH

WORKDIR /blobtoolkit/viewer

RUN npm install

RUN mkdir -p /blobtoolkit/taxdump

WORKDIR /blobtoolkit/taxdump

RUN curl -L ftp://ftp.ncbi.nih.gov/pub/taxonomy/new_taxdump/new_taxdump.tar.gz | tar xzf -;

RUN printf '>seq\nACGT\n' > /tmp/assembly.fasta \
    && ../blobtools2/blobtools create --fasta /tmp/assembly.fasta --taxid 3702 --taxdump ./ /tmp/dataset \
    && rm -r /tmp/*

WORKDIR /blobtoolkit

RUN chmod 777 /blobtoolkit/viewer

RUN touch geckodriver.log && chmod 666 geckodriver.log

COPY startup.sh /blobtoolkit

COPY .env /blobtoolkit/conf

EXPOSE 8000 8080

USER root

RUN apt-get install dbus-x11

USER blobtoolkit

CMD /blobtoolkit/startup.sh
