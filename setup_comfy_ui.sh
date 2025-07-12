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

# Setup custom nodes be stored on the pod volume.
mkdir -p /workspace/custom_nodes
echo "Installing ComfyUI Controlnet Aux"
cd /workspace/custom_nodes
git clone https://github.com/Fannovel16/comfyui_controlnet_aux/
git checkout 59b027e088c1c8facf7258f6e392d16d204b4d27
cd /workspace/custom_nodes/comfyui_controlnet_aux
pip install -r requirements.txt
