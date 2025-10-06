#!/bin/bash
DIFFUSION_MODEL=$1

cd /
pip install -r requirements.txt
python model_manager.py "$DIR" --manifest "/model_manifests/$DIFFUSION_MODEL.json"