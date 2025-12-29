variable "RELEASE" {
    default = "0.0.7"
}

variable "COMFYUI_VERSION" {
    default = "v0.3.76"
}

group "default" {
    targets = ["comfyui", "comfyui-bakedin"]
}

target "comfyui" {
    dockerfile = "Dockerfile"
    tags = ["behealy/my_comfy_pod:${RELEASE}"]
    args = {
        COMFYUI_INSTALL_DIR = "/workspace/ComfyUI"
        COMFYUI_VERSION = "${COMFYUI_VERSION}"
        RELEASE = "${RELEASE}"
    }
    platforms = ["linux/amd64"]
}

target "comfyui-bakedin" {
    dockerfile = "Dockerfile"
    tags = ["behealy/my_comfy_pod:${RELEASE}-bakedin"]
    args = {
        COMFYUI_INSTALL_DIR = "/ComfyUI"
        COMFYUI_VERSION = "${COMFYUI_VERSION}"
        RELEASE = "${RELEASE}"
        BAKED = "yes"
    }
    platforms = ["linux/amd64"]
}

target "comfyui-bakedin-cpu" {
    dockerfile = "Dockerfile"
    tags = ["behealy/my_comfy_pod:${RELEASE}-bakedin-cpu"]
    args = {
        COMFYUI_INSTALL_DIR = "/ComfyUI"
        COMFYUI_VERSION = "${COMFYUI_VERSION}"
        RELEASE = "${RELEASE}"
        BASE_IMAGE="behealy/dev-base:1.0.3-ubuntu2404
        BAKED = "yes"
    }
    platforms = ["linux/amd64"]
}



