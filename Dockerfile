FROM ubuntu:18.04

ENV CONDA_DIR /opt/conda
ENV PATH $CONDA_DIR/bin:$PATH
ENV NB_USER keras
ENV NB_UID 1000
ARG PY_VER=3.7
ARG TENSORFLOW_VER=1.14
ARG KERAS_VER=2.2.4

RUN apt-get update && \
    apt-get install -y wget git libhdf5-dev g++ graphviz openssh-server

RUN mkdir -p $CONDA_DIR && \
    echo export PATH=$CONDA_DIR/bin:'$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet --output-document=anaconda.sh  https://repo.anaconda.com/archive/Anaconda2-2019.07-Linux-x86_64.sh && \
    /bin/bash /anaconda.sh -f -b -p $CONDA_DIR && \
    rm anaconda.sh

RUN useradd -m -s /bin/bash -N -u $NB_UID $NB_USER && \
    mkdir -p $CONDA_DIR && \
    chown keras $CONDA_DIR -R && \
    mkdir -p /src && \
    chown keras /src

RUN conda install -y python=${PY_VER} && \
    pip install --upgrade pip && \
    pip install tensorflow==${TENSORFLOW_VER} && \
    pip install keras==${KERAS_VER} && \
    conda clean -yt

VOLUME ["/src"]

USER keras
WORKDIR /src
EXPOSE 8888
CMD jupyter notebook --port=8888 --ip=0.0.0.0
