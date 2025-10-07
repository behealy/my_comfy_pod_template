#!/bin/bash
install_dir=$1
target_comfyui_version=$2
currently_installed_version=""

if [[ "$install_dir" == "" || "$target_comfyui_version" == "" ]]; then 
    echo "Usage: 'install_comfyui.sh <install_directory> <target_comfyui_version>'"
    exit 1
fi

echo "Targeted ComfyUI version is $target_comfyui_version"
workdir=$(pwd)
version_file="$workdir/.comfy_version"

if [[ -f $version_file ]]; then
    currently_installed_version=$(cat $version_file)
    echo "ComfyUI version $currently_installed_version is currently installed in $install_dir"
fi

if [[ "$currently_installed_version" != "$target_comfyui_version" ]]; then 
    echo "Cleaning up existing ComfyUI folder"
    rm -rf $install_dir
fi

if [[ ! -d $install_dir ]]; then 
    echo "Installing comfyUI version $target_comfyui_version"
    mkdir -p $install_dir
    cd $install_dir
    git init
    git remote add origin https://github.com/comfyanonymous/ComfyUI.git
    git fetch --depth 1 origin tag ${target_comfyui_version}
    git checkout FETCH_HEAD

    echo "Installing comfyUI Manager"
    cd $install_dir/custom_nodes
    git clone https://github.com/ltdrdata/ComfyUI-Manager.git

    echo "$target_comfyui_version" > $version_file

    pip install -r $install_dir/requirements.txt
    pip install -r $install_dir/custom_nodes/ComfyUI-Manager/requirements.txt
else
    echo "Target comfyUI version already installed, skipping new install"
fi


