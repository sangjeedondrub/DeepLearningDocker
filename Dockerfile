FROM ubuntu:14.04

MAINTAINER Dhaval Thakkar <dhaval.thakkar@somaiya.edu>

ARG PIP=/root/anaconda3/bin/pip

# Install some dependencies
RUN apt-get update && apt-get install -y \
                build-essential \
                cmake \
                curl \
                g++ \
                nano \
                pkg-config \
                software-properties-common \
                unzip \
                vim \
                wget \
                doxygen \
                && \
        apt-get clean && \
        apt-get autoremove && \
        rm -rf /var/lib/apt/lists/* 

#Anaconda
RUN wget --quiet https://repo.continuum.io/archive/Anaconda3-4.4.0-Linux-x86_64.sh && \
    bash Anaconda3-4.4.0-Linux-x86_64.sh -b

#Setup .bashrc
RUN rm -r /root/.bashrc
COPY bashrc.txt /root/.bashrc
RUN alias brc='source ~/.bashrc'

# Installing TensorFlow
RUN ${PIP} --no-cache-dir install \	
	https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-1.2.1-cp36-cp36m-linux_x86_64.whl

# Installing CNTK
RUN ${PIP} --no-cache-dir install \
        https://cntk.ai/PythonWheel/CPU-Only/cntk-2.1-cp36-cp36m-linux_x86_64.whl

#Installing Keras
RUN ${PIP} --no-cache-dir install keras

#Setup notebook config
COPY jupyter_notebook_config.py /root/.jupyter/

# Jupyter has issues with being run directly: https://github.com/ipython/ipython/issues/7062
COPY run_jupyter.sh /root/

# Expose Ports for TensorBoard (6006), Ipython (8888)
EXPOSE 6006 8888

WORKDIR "/root"
CMD ["/bin/bash"]

