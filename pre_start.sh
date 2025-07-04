#!/bin/bash

# Create model directories in workspace if they don't exist
mkdir -p /workspace/comfyui/models/{checkpoints,clip,clip_vision,controlnet,diffusers,embeddings,loras,upscale_models,vae,unet,configs}

cd /workspace/comfyui/models/checkpoints
wget -O sd_xl_base_1.0.safetensors https://huggingface.co/stabilityai/stable-diffusion-xl-base-1.0/resolve/main/sd_xl_base_1.0.safetensors
wget -O sd_xl_refiner_1.0.safetensors https://huggingface.co/stabilityai/stable-diffusion-xl-refiner-1.0/resolve/main/sd_xl_refiner_1.0.safetensors
wget -O flux1-schnell-fp8.safetensors https://huggingface.co/Comfy-Org/flux1-schnell/resolve/main/flux1-schnell-fp8.safetensors
cd /

cd /workspace/comfyui/models/controlnet
wget -O controlnet-union-sdxl-1.0.safetensors https://huggingface.co/xinsir/controlnet-union-sdxl-1.0/resolve/main/diffusion_pytorch_model.safetensors
cd /

cd /workspace/comfyui/models/loras
wget -O analog-photo-lora.safetensors https://huggingface.co/artificialguybr/analogredmond-v2/resolve/main/AnalogRedmondV2-Analog-AnalogRedmAF.safetensors
wget -O lineart-manga-lora.safetensors https://huggingface.co/artificialguybr/LineAniRedmond-LinearMangaSDXL/resolve/main/LineAniRedmond-LineAniAF.safetensors
cd /

cd /ComfyUI
nohup python main.py --listen --port 3000 >> /dev/stdout 2>&1 &

# Ensure the process started
sleep 2
if ! pgrep -f "python.*main.py.*--port.*3000" > /dev/null; then
    echo "Failed to start ComfyUI"
    exit 1
fi
