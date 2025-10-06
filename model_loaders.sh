#!/bin/bash
$COMFY_MODELS_WORKSPACE_DIR=/workspace/comfy/models

function load_qwen_image_models() {
    mkdir -p $COMFY_MODELS_WORKSPACE_DIR/{checkpoints,clip,clip_vision,controlnet,diffusion_models,embeddings,loras,upscale_models,vae,unet,configs,text_encoders}
    wget https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/vae/qwen_image_vae.safetensors -o $COMFY_MODELS_WORKSPACE_DIR/vae/qwen_image_vae.safetensors
    wget https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/text_encoders/qwen_2.5_vl_7b_fp8_scaled.safetensors -o $COMFY_MODELS_WORKSPACE_DIR/text_encoders/qwen_2.5_vl_7b_fp8_scaled_text_encoder.safetensors
    wget https://huggingface.co/lightx2v/Qwen-Image-Lightning/resolve/main/Qwen-Image-Lightning-8steps-V1.0.safetensors -o $COMFY_MODELS_WORKSPACE_DIR/loras/Qwen-Image-Lightning-8steps-V1.0.safetensors
    wget https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/diffusion_models/qwen_image_fp8_e4m3fn.safetensors -o $COMFY_MODELS_WORKSPACE_DIR/diffusion_models/qwen_image_fp8_e4m3fn.safetensors
}

function load_qwen_image_edit_models() {
    load_qwen_image_models()
    wget https://huggingface.co/Comfy-Org/Qwen-Image-Edit_ComfyUI/blob/main/split_files/diffusion_models/qwen_image_edit_2509_fp8_e4m3fn.safetensors -o $COMFY_MODELS_WORKSPACE_DIR/diffusion_models/qwen_image_edit_2509_fp8_e4m3fn.safetensors
}