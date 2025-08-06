FROM nvidia/cuda:11.0.3-cudnn8-devel-ubuntu20.04

RUN apt-get update && apt-get upgrade -y && apt-get install -y wget git ffmpeg bzip2 curl

# Install Miniconda
RUN curl -o ~/miniconda.sh https://repo.anaconda.com/miniconda/Miniconda3-py37_23.1.0-1-Linux-x86_64.sh && \
    bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh

ENV PATH /opt/conda/bin:$PATH

RUN conda update -y conda

# Create Conda environment
RUN conda create -n deepfacelab python=3.7

RUN echo "source activate deepfacelab" > ~/.bashrc
ENV PATH /opt/conda/envs/deepfacelab/bin:$PATH

# Clone repositories
RUN git clone --depth 1 https://github.com/nagadit/DeepFaceLab_Linux.git /DeepFaceLab_Linux
RUN cd /DeepFaceLab_Linux && git clone --depth 1 https://github.com/iperov/DeepFaceLab.git

# Install requirements
RUN pip install -r /DeepFaceLab_Linux/DeepFaceLab/requirements-cuda.txt

# Install JupyterLab
RUN pip install jupyterlab

# Expose port for JupyterLab
EXPOSE 8080

# Start JupyterLab
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8080", "--no-browser", "--allow-root", "--LabApp.allow_origin='*'", "--LabApp.base_url=/proxy/8080"]
