#!/bin/bash
echo "Installing comfyUI"
cd $COMFYUI_INSTALL_DIR
git init
git remote add origin https://github.com/comfyanonymous/ComfyUI.git
git fetch --depth 1 origin tag ${COMFYUI_VERSION}
git checkout FETCH_HEAD

echo "Installing comfyUI Manager"
cd $COMFYUI_INSTALL_DIR/custom_nodes
git clone https://github.com/ltdrdata/ComfyUI-Manager.git
