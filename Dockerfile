FROM ubuntu:18.04

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

RUN apt-get update --fix-missing  && \
    apt-get install -y wget git libhdf5-dev g++ graphviz openssh-server bzip2 ca-certificates libglib2.0-0 libxext6 libsm6 libxrender1 && \
    apt-get clean

RUN mkdir -p $CONDA_DIR && \
    wget --quiet https://repo.anaconda.com/archive/Anaconda3-2019.07-Linux-x86_64.sh -O ~/anaconda.sh && \
    /bin/bash ~/anaconda.sh -b -p /opt/conda && \
    rm ~/anaconda.sh && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc && \
    find /opt/conda/ -follow -type f -name '*.a' -delete && \
    find /opt/conda/ -follow -type f -name '*.js.map' -delete && \
    /opt/conda/bin/conda clean -afy


RUN mkdir -p /src && \
    chown conda /src

RUN conda install -y python=3.7 && \
    pip install --upgrade pip && \
    pip install tensorflow==1.14 && \
    pip install keras==2.2.4 && \
    conda clean -yt

VOLUME ["/src"]

USER conda
WORKDIR /src
EXPOSE 8888
CMD jupyter notebook --port=8888 --ip=0.0.0.0
