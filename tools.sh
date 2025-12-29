#!/bin/bash
function comfy_load_model() {
    local url=$2
    local dir="$COMFY_MODELS_INSTALL_DIR/$1"
    local filename=$(basename $url)
    local resolved="$dir/$filename"
    if [[ ! -f $resolved ]] then;
        echo "Downloading $filename to $dir"
        mkdir -p $dir
        wget $url -O $resolved
    else 
        echo "$filename already present in $dir, skipping"
    fi
}

function load_diffusion_model() {
    comfy_load_model "diffusion_models" $1
}

function load_vae() {
    comfy_load_model "vae" $1
}

function load_text_encoder() {
    comfy_load_model "text_encoders" $1
}

function load_lora() { 
     comfy_load_model "loras" $1
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

function load_hunyuan_models() {
    load_text_encoder https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/clip_l.safetensors
    load_text_encoder https://huggingface.co/Comfy-Org/HunyuanVideo_repackaged/resolve/main/split_files/text_encoders/llava_llama3_fp8_scaled.safetensors
    load_diffusion_model https://huggingface.co/Comfy-Org/HunyuanVideo_repackaged/resolve/main/split_files/diffusion_models/hunyuan_video_t2v_720p_bf16.safetensors
    load_vae https://huggingface.co/Comfy-Org/HunyuanVideo_repackaged/resolve/main/split_files/vae/hunyuan_video_vae_bf16.safetensors
}

function load_wan_t2v_models() {
    load_text_encoder https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/text_encoders/umt5_xxl_fp8_e4m3fn_scaled.safetensors
    load_vae https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/vae/wan_2.1_vae.safetensors
    load_diffusion_model https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/diffusion_models/wan2.2_t2v_low_noise_14B_fp8_scaled.safetensors
    load_diffusion_model https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/diffusion_models/wan2.2_t2v_high_noise_14B_fp8_scaled.safetensors
    load_lora https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/loras/wan2.2_t2v_lightx2v_4steps_lora_v1.1_high_noise.safetensors
    load_lora https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/loras/wan2.2_t2v_lightx2v_4steps_lora_v1.1_low_noise.safetensors
}

function load_wan_i2v_models() {
    load_text_encoder https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/text_encoders/umt5_xxl_fp8_e4m3fn_scaled.safetensors
    load_vae https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/vae/wan_2.1_vae.safetensors
    load_diffusion_model https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/diffusion_models/wan2.2_i2v_high_noise_14B_fp8_scaled.safetensors
    load_diffusion_model https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/diffusion_models/wan2.2_i2v_low_noise_14B_fp8_scaled.safetensors
    load_lora https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/loras/wan2.2_i2v_lightx2v_4steps_lora_v1_low_noise.safetensors
    load_lora https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/loras/wan2.2_i2v_lightx2v_4steps_lora_v1_high_noise.safetensors
}

function load_flux_kontext_models() {
    load_vae https://huggingface.co/Comfy-Org/Lumina_Image_2.0_Repackaged/resolve/main/split_files/vae/ae.safetensors
    load_text_encoder https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/clip_l.safetensors
    load_text_encoder https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/t5xxl_fp8_e4m3fn_scaled.safetensors
    load_diffusion_model https://huggingface.co/Comfy-Org/flux1-kontext-dev_ComfyUI/resolve/main/split_files/diffusion_models/flux1-dev-kontext_fp8_scaled.safetensors
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