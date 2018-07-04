FROM nvidia/cuda:9.0-cudnn7-devel-ubuntu16.04

RUN apt-get -qq update && apt-get -qq -y install curl bzip2 \
    && curl -sSL https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -o /tmp/miniconda.sh \
    && bash /tmp/miniconda.sh -bfp /usr/local \
    && rm -rf /tmp/miniconda.sh \
    && conda install -y python=3.6 \
    && conda update conda \
    && conda clean --all --yes

## Change source channel
RUN conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/

## Add conda kernel and nb-extentions
RUN conda install -y nb_conda && \
    conda install -y -c conda-forge jupyter_contrib_nbextensions 

# Add Jupyterhub
ARG JUPYTERHUB_VERSION=0.6
RUN pip install --no-cache jupyterhub==$JUPYTERHUB_VERSION

# Install scipy related
RUN conda install -y \
    h5py \
    mkl \
    mkl-include \
    numpy \
    matplotlib \
    seaborn \
    pandas \
    scipy \
    scikit-learn \
    numba \
    tqdm \
    pillow \
    pydot \
    pyyaml \
    ipython 

## Install OpenCV 3
RUN conda install -y -c menpo opencv3
# some fix to opencv3
#RUN apt-get install -y -f libgtk2.0-0

## Install CUDA 9.0 support 
RUN conda install -y -c soumith magma-cuda90

## Add deeplearning tools
# tensorflow
RUN pip install -i https://pypi.tuna.tsinghua.edu.cn/simple --upgrade \
		numpy \
        keras \
        tensorflow-gpu 
# pytorch
RUN pip install -i https://pypi.tuna.tsinghua.edu.cn/simple http://download.pytorch.org/whl/cu90/torch-0.4.0-cp36-cp36m-linux_x86_64.whl \
				 torchvision

## Jupyter lab-hub extention
RUN conda install -y -c conda-forge nodejs 
RUN pip install -i https://pypi.tuna.tsinghua.edu.cn/simple jupyterlab \
    &&  jupyter labextension install @jupyterlab/hub-extension
