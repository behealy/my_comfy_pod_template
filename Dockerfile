FROM runpod/base:0.6.3-cuda11.8.0

ARG COMFYUI_VERSION

# Create model directories and download models first (this layer will be cached)
RUN mkdir -p /ComfyUI
RUN mkdir -p /ComfyUI/models/{checkpoints,clip,clip_vision,controlnet,diffusion_models,embeddings,loras,upscale_models,vae,unet,configs,text_encoders}
# Create user directory to store logs
RUN mkdir -p /ComfyUI/user

# Setup Python and pip symlinks
RUN ln -sf /usr/bin/python3.10 /usr/bin/python && \
    ln -sf /usr/bin/python3.10 /usr/bin/python3 && \
    python -m pip install --upgrade pip && \
    ln -sf /usr/local/bin/pip3.10 /usr/local/bin/pip

# Copy comfyui setup.
COPY --chmod=755 setup_comfy_ui.sh /setup_comfy_ui.sh

# Copy the README.md, extra_model_paths.yml and start script
COPY README.md /usr/share/nginx/html/README.md
COPY extra_model_paths.yaml /ComfyUI/extra_model_paths.yaml
COPY --chmod=755 pre_start.sh /pre_start.sh

# Copy model management stuff
COPY model_manifests /model_manifests
COPY model_manager.py /model_manager.py
COPY --chmod=755 load_models.sh /load_models.sh
COPY --chmod=755 setup_workspace.sh /setup_workspace.sh
COPY requirements.txt /requirements.txt

# Add tool functions to run in web shell
COPY --chmod=775 tools.sh  /.bashrc

# Setup env for the comfyUI setup script
ENV COMFYUI_VERSION=${COMFYUI_VERSION}

CMD [ "/start.sh" ]