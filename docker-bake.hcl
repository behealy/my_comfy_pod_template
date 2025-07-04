variable "RELEASE" {
    default = "0.0.1"
}

variable "COMFYUI_VERSION" {
    default = "v0.3.43"
}

variable "GITHUB_WORKSPACE" {
    default = "."
}

target "default" {
    context = "${GITHUB_WORKSPACE}/official-templates/stable-diffusion-comfyui"
    dockerfile = "Dockerfile"
    tags = ["behealy/my_comfy_pod:${RELEASE}"]
    contexts = {
        scripts = "container-template"
        proxy = "container-template/proxy"
    }
    args = {
        COMFYUI_VERSION = "${COMFYUI_VERSION}"
        RELEASE = "${RELEASE}"
        GITHUB_WORKSPACE = "${GITHUB_WORKSPACE}"
    }
}
