FROM genomehubs/blobtoolkit-dependencies:1.3
LABEL maintainer="blobtoolkit@genomehubs.org"
LABEL license="MIT"
LABEL version="1.3"

WORKDIR /blobtoolkit

RUN git clone -b release/v2.3 https://github.com/blobtoolkit/blobtools2 \
    && git clone -b release/v1.2 https://github.com/blobtoolkit/viewer \
    && git clone -b release/v1.3 https://github.com/blobtoolkit/insdc-pipeline \
    && git clone -b release/v1.0 https://github.com/blobtoolkit/specification

ENV CONDA_DEFAULT_ENV btk_env

ARG CONDA_DIR=/home/blobtoolkit/miniconda3

ENV PATH /blobtoolkit/wrappers:$CONDA_DIR/bin:/blobtoolkit/blobtools2:/blobtoolkit/specification:$CONDA_DIR/envs/btk_env/bin:$PATH

WORKDIR /blobtoolkit/viewer

RUN npm install

WORKDIR /blobtoolkit

COPY startup.sh /blobtoolkit

COPY .env /blobtoolkit/viewer

EXPOSE 8000 8080

ENV PYTHONPATH $CONDA_DIR/envs/btk_env/lib/python3.7/site-packages:$PYTHONPATH

CMD /blobtoolkit/startup.sh
