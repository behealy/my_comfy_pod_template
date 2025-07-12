#!/bin/bash
DIFFUSION_MODEL=$1

DIR=/workspace/models

# Create model directories in workspace if they don't exist
mkdir -p $DIR/{checkpoints,clip,clip_vision,controlnet,diffusers,embeddings,loras,upscale_models,vae,unet,configs,text_encoders}

cd /
pip install requirements.txt
python model_manager.py "$DIR" --manifest "/model_manifests/$DIFFUSION_MODEL.json"