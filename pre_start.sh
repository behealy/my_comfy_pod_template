#!/bin/bash

mkdir -p /workspace

# run setup_comfy_ui.sh
./setup_comfy_ui.sh

nohup python /ComfyUI/main.py --listen --port 3000 >> /dev/stdout 2>&1 &

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
