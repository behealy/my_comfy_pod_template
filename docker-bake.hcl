variable "RELEASE" {
    default = "0.0.3"
}

variable "COMFYUI_VERSION" {
    default = "v0.3.43"
}

variable "GITHUB_WORKSPACE" {
    default = "."
}

group "default" {
    targets = ["comfyui"]
}

target "comfyui" {
    dockerfile = "Dockerfile"
    tags = ["behealy/my_comfy_pod:${RELEASE}"]
    args = {
        COMFYUI_VERSION = "${COMFYUI_VERSION}"
        RELEASE = "${RELEASE}"
        GITHUB_WORKSPACE = "${GITHUB_WORKSPACE}"
    }
    platforms = ["linux/amd64"]
}
