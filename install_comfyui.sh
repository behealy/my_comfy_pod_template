#!/bin/bash
if [[ ! -d $COMFYUI_INSTALL_DIR ]]; then 
    echo "Installing comfyUI"
    cd $COMFYUI_INSTALL_DIR
    git init
    git remote add origin https://github.com/comfyanonymous/ComfyUI.git
    git fetch --depth 1 origin tag ${COMFYUI_VERSION}
    git checkout FETCH_HEAD

    echo "Installing comfyUI Manager"
    cd $COMFYUI_INSTALL_DIR/custom_nodes
    git clone https://github.com/ltdrdata/ComfyUI-Manager.git

    pip install -r $COMFYUI_INSTALL_DIR/requirements.txt
    pip install -r $COMFYUI_INSTALL_DIR/custom_nodes/ComfyUI-Manager/requirements.txt
fi


