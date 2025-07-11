#!/bin/bash

# Create model directories in workspace if they don't exist
mkdir -p /workspace/sdxl/{checkpoints,clip,clip_vision,controlnet,diffusers,embeddings,loras,upscale_models,vae,unet,configs,text_encoders}
mkdir -p /workspace/flux/{checkpoints,clip,clip_vision,controlnet,diffusers,embeddings,loras,upscale_models,vae,unet,configs,text_encoders}

# run setup_comfy_ui.sh
./setup_comfy_ui.sh

# check if environment variable is set, if so, use it's value to run load_models.sh
if [ -n "$MODEL_SET_ONSTARTUP" ]; then
    ./load_models.sh $MODEL_SET_ONSTARTUP
fi

cd /ComfyUI
nohup python main.py --listen --port 3000 >> /dev/stdout 2>&1 &

# Ensure the process started
sleep 2
if ! pgrep -f "python.*main.py.*--port.*3000" > /dev/null; then
    echo "Failed to start ComfyUI"
    exit 1
fi
