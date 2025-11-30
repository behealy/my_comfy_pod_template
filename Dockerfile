FROM runpod/base:0.6.3-cuda11.8.0

ARG COMFYUI_VERSION
ARG BAKED
ARG COMFYUI_INSTALL_DIR

# Setup env for the comfyUI setup script
ENV BAKED=${BAKED}
ENV COMFYUI_VERSION=${COMFYUI_VERSION}
ENV COMFYUI_INSTALL_DIR=${COMFYUI_INSTALL_DIR}

# For model install scripts
ENV WORKSPACE_FOLDER=/workspace
ENV COMFY_MODELS_INSTALL_DIR="$WORKSPACE_FOLDER/models"
ENV HF_HOME="${WORKSPACE_FOLDER}/hf_cache"

# Setup Python and pip symlinks
RUN ln -sf /usr/bin/python3.10 /usr/bin/python && \
    ln -sf /usr/bin/python3.10 /usr/bin/python3 && \
    python -m pip install --upgrade pip && \
    ln -sf /usr/local/bin/pip3.10 /usr/local/bin/pip

# Copy comfyui setup.
COPY --chmod=755 install_comfyui.sh /install_comfyui.sh
COPY --chmod=755 load_models.sh /load_models.sh
COPY --chmod=755 pre_start.sh /pre_start.sh

# Add tool functions to run in web shell
COPY --chmod=775 tools.sh /tools.sh

# Copy model management stuff
COPY model_manifests /model_manifests
COPY model_manager.py /model_manager.py
COPY requirements.txt /requirements.txt

# Copy the README.md, extra_model_paths.yml and start script
COPY README.md /usr/share/nginx/html/README.md
COPY extra_model_paths.yaml /extra_model_paths.yaml

RUN if [[ "$BAKED" == "yes" ]]; then ./install_comfyui.sh "$COMFYUI_INSTALL_DIR" "$COMFYUI_VERSION"; fi

RUN echo "source /tools.sh" >> /root/.bashrc

CMD [ "/start.sh" ]