#!/bin/bash
echo "Installing comfyUI"
cd /ComfyUI
git init
git remote add origin https://github.com/comfyanonymous/ComfyUI.git
git fetch --depth 1 origin tag ${COMFYUI_VERSION}
git checkout FETCH_HEAD
pip install -r requirements.txt

echo "Installing comfyUI Manager"
cd /ComfyUI/custom_nodes
git clone https://github.com/ltdrdata/ComfyUI-Manager.git
cd /ComfyUI/custom_nodes/ComfyUI-Manager
pip install -r requirements.txt

mkdir -p /workspace/comfy/{custom_nodes,outputs,inputs,user}