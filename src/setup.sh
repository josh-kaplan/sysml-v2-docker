#!/bin/bash

ARCH=`arch`
ANACONDA_VERSION="2023.09-0"
PYTHON_VERSION="3.11"
SYSML_VERSION="0.36.0"

dnf -y update

#----------------------- Install Java ----------------------- #

dnf install -y java-11-openjdk java-11-openjdk-devel
java -version
_EXITCODE = $?
if [[ $_EXITCODE -ne 0 ]]; then
    echo "ERROR: Failed to install Java"
    exit $_EXITCODE
fi

#----------------------- Install Python ----------------------- #

dnf install -y python${PYTHON_VERSION} python${PYTHON_VERSION}-pip
alternatives --install /usr/local/bin/python python /usr/bin/python${PYTHON_VERSION} 100
alternatives --install /usr/local/bin/python3 python3 /usr/bin/python${PYTHON_VERSION} 100
alternatives --install /usr/local/bin/pip pip /usr/bin/pip${PYTHON_VERSION} 100
alternatives --install /usr/local/bin/pip3 pip3 /usr/bin/pip${PYTHON_VERSION} 100

# Clear the linux command hash table entries
# NOTE: The shell keeps a hash table that remembers the locations of commands. 
# It’s possible that the location of python3 is hashed and it’s using an old value. 
# Using hash -d <command> will clear that entry in the hash table.
#hash -d python
#hash -d python3

# Verify python 
python --version
_EXITCODE = $?
if [[ $_EXITCODE -ne 0 ]]; then
    echo "ERROR: Failed to install Python"
    exit $_EXITCODE
fi

#----------------------- Install Node.js ----------------------- #

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
_EXITCODE = $?
if [[ $_EXITCODE -ne 0 ]]; then
    echo "ERROR: Failed to install nvm"
    exit $_EXITCODE
fi
source ~/.bashrc

nvm install 14
_EXITCODE = $?
if [[ $_EXITCODE -ne 0 ]]; then
    echo "ERROR: Failed to install Node.js"
    exit $_EXITCODE
fi


#----------------------- Install Anaconda ----------------------- #

# Dependencies needed for conda per https://docs.anaconda.com/free/anaconda/install/linux/
dnf install -y libXcomposite libXcursor libXi libXtst libXrandr alsa-lib mesa-libEGL libXdamage mesa-libGL libXScrnSaver

# Install Conda
curl -O https://repo.anaconda.com/archive/Anaconda3-${ANACONDA_VERSION}-Linux-${ARCH}.sh
bash ./Anaconda3-${ANACONDA_VERSION}-Linux-${ARCH}.sh -b -p /opt/anaconda3
_EXITCODE = $?
if [[ $_EXITCODE -ne 0 ]]; then
    echo "ERROR: Failed to install Anaconda"
    exit $_EXITCODE
fi

# Add conda to PATH
#alternatives --install /usr/local/bin/conda conda /opt/anaconda3/bin/conda 100
echo "export PATH=/opt/anaconda3/bin:$PATH" >> ~/.bashrc
source ~/.bashrc
conda --version


#----------------------- Install SysML 2.0 ----------------------- #

# Dependencies needed for SysML
conda install jupyterlab=2.* graphviz=2.* -c conda-forge -y
_EXITCODE = $?
if [[ $_EXITCODE -ne 0 ]]; then
    echo "ERROR: Failed to install JupyterLab and Graphviz"
    exit $_EXITCODE
fi
mkdir -p /opt/local/bin
ln -s `which dot` /opt/local/bin/dot
jupyter --version

# Install SysML Kernel
jupyter kernelspec remove sysml
conda install "jupyter-sysml-kernel=$SYSML_VERSION" -c conda-forge -y
_EXITCODE = $?
if [[ $_EXITCODE -ne 0 ]]; then
    echo "ERROR: Failed to install SysML Kernel"
    exit $_EXITCODE
fi

# Install SysML JupyterLab Extension
jupyter labextension uninstall @systems-modeling/jupyterlab-sysml 
jupyter labextension install "@systems-modeling/jupyterlab-sysml@$SYSML_VERSION"
_EXITCODE = $?
if [[ $_EXITCODE -ne 0 ]]; then
    echo "ERROR: Failed to install SysML JupyterLab Extension"
    exit $_EXITCODE
fi

# Final directory setup
ln -s /workspace/notebooks "/opt/anaconda3/share/jupyter/kernels/sysml/sysml.library/Domain Libraries/ext" 
_EXITCODE = $?
if [[ $_EXITCODE -ne 0 ]]; then
    echo "ERROR: Failed to create extensions symlink"
    exit $_EXITCODE
fi