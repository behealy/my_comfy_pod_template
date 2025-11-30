variable "RELEASE" {
    default = "0.0.7"
}

variable "COMFYUI_VERSION" {
    default = "v0.3.62"
}

variable "GITHUB_WORKSPACE" {
    default = "."
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
        GITHUB_WORKSPACE = "${GITHUB_WORKSPACE}"
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
        GITHUB_WORKSPACE = "${GITHUB_WORKSPACE}"
        BAKED = "yes"
    }
    platforms = ["linux/amd64"]
}

