#!/bin/bash
./install_comfyui.sh

 # --output-directory, --input-directory, --user-directory
nohup python $COMFYUI_INSTALL_DIR/main.py --listen --port 3000 & >> /dev/stdout 2>&1 &

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
