FROM ubuntu:18.04
LABEL maintainer="blobtoolkit@genomehubs.org"
LABEL license="MIT"
LABEL version="1.1"

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
    pysam \
    pyvirtualdisplay \
    pyyaml \
    selenium \
    seqtk \
    snakemake=5.9 \
    tqdm \
    ujson \
    yq

RUN $CONDA_DIR/envs/btk_env/bin/pip install fastjsonschema

WORKDIR /blobtoolkit

ARG CACHE_BUSTER=c5f31c4b

RUN git clone -b release/v2.2 https://github.com/blobtoolkit/blobtools2 \
    && git clone -b release/v1.1 https://github.com/blobtoolkit/insdc-pipeline \
    && git clone -b release/v1.0 https://github.com/blobtoolkit/specification \
    && git clone -b release/v1.1 https://github.com/blobtoolkit/viewer

ENV PATH /blobtoolkit/blobtools2:/blobtoolkit/specification:$CONDA_DIR/envs/btk_env/bin:$PATH

ENV CONDA_DEFAULT_ENV btk_env

WORKDIR /blobtoolkit/viewer

RUN npm install

WORKDIR /blobtoolkit/databases/ncbi_taxdump

RUN curl -L ftp://ftp.ncbi.nih.gov/pub/taxonomy/new_taxdump/new_taxdump.tar.gz | tar xzf -;

RUN printf '>seq\nACGT\n' > /tmp/assembly.fasta \
    && ../../blobtools2/blobtools create --fasta /tmp/assembly.fasta --taxid 3702 --taxdump ./ /tmp/dataset \
    && rm -r /tmp/*

WORKDIR /blobtoolkit

COPY startup.sh /blobtoolkit

COPY .env /blobtoolkit/viewer

EXPOSE 8000 8080

ENV PATH $CONDA_DIR/bin:$PATH

RUN chmod ga+wx /blobtoolkit /blobtoolkit/databases 

#ENV PYTHONPATH $CONDA_DIR/envs/btk_env/lib/python3.6/site-packages:$PYTHONPATH

#RUN find $CONDA_DIR/envs/btk_env/ -name ujson*

CMD /blobtoolkit/startup.sh
