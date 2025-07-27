#!/bin/bash
mkdir -p /workspace

# run setup_comfy_ui.sh
./setup_comfy_ui.sh

function install_controlnet_nodes() {
    # Setup custom nodes be stored on the pod volume.
    echo "Installing ComfyUI Controlnet Aux"
    cd /workspace/comfy/custom_nodes
    git clone https://github.com/Fannovel16/comfyui_controlnet_aux/
    git checkout 59b027e088c1c8facf7258f6e392d16d204b4d27
    cd /workspace/comfy/custom_nodes/comfyui_controlnet_aux
    pip install -r requirements.txt
    cd /
}

 # --output-directory, --input-directory, --user-directory
nohup python /ComfyUI/main.py --listen --port 3000 --output-directory /workspace/comfy/outputs --user-directory /workspace/comfy/user  --input-directory /workspace/comfy/inputs & >> /dev/stdout 2>&1 &

# check if environment variable is set, if so, use it's value to run load_models.sh
if [ -n "$MODEL_SET_ONSTARTUP" ]; then
    cd /
    load_models.sh $MODEL_SET_ONSTARTUP
fi

# Ensure the process started
sleep 2
if ! pgrep -f "python.*main.py.*--port.*3000" > /dev/null; then
    echo "Failed to start ComfyUI"
    exit 1
fi
