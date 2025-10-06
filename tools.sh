#!/bin/bash
COMFY_MODELS_WORKSPACE_DIR=workspace/comfy/models

function load_diffusion_model() {
    local url=$1
    local filename=$(basename $url)
    wget $url -O $COMFY_MODELS_WORKSPACE_DIR/diffusion_models/$filename
}

function load_vae() {
    local url=$1
    local filename=$(basename $url)
    wget $url -O $COMFY_MODELS_WORKSPACE_DIR/vae/$filename
}

function load_text_encoder() {
    local url=$1
    local filename=$(basename $url)
    wget $url -O $COMFY_MODELS_WORKSPACE_DIR/text_encoders/$filename
}

function load_lora() {
    local url=$1
    local filename=$(basename $url)
    wget $url -O $COMFY_MODELS_WORKSPACE_DIR/loras/$filename
}

function load_qwen_image_models() {
    load_vae https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/vae/qwen_image_vae.safetensors
    load_text_encoder https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/text_encoders/qwen_2.5_vl_7b_fp8_scaled.safetensors
    load_lora https://huggingface.co/lightx2v/Qwen-Image-Lightning/resolve/main/Qwen-Image-Lightning-8steps-V1.0.safetensors
    load_diffusion_model https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/diffusion_models/qwen_image_fp8_e4m3fn.safetensors
}

function load_qwen_image_edit_models() {
    load_qwen_image_models
    load_diffusion_model https://huggingface.co/Comfy-Org/Qwen-Image-Edit_ComfyUI/blob/main/split_files/diffusion_models/qwen_image_edit_2509_fp8_e4m3fn.safetensors
}

function load_hunyuan_models () {
    load_text_encoder https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/clip_l.safetensors
    load_text_encoder https://huggingface.co/Comfy-Org/HunyuanVideo_repackaged/resolve/main/split_files/text_encoders/llava_llama3_fp8_scaled.safetensors
    load_diffusion_model https://huggingface.co/Comfy-Org/HunyuanVideo_repackaged/resolve/main/split_files/diffusion_models/hunyuan_video_t2v_720p_bf16.safetensors
    load_vae https://huggingface.co/Comfy-Org/HunyuanVideo_repackaged/resolve/main/split_files/vae/hunyuan_video_vae_bf16.safetensors
}

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