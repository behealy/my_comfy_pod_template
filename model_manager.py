import os
import json
import argparse
import shutil
import requests
from urllib.parse import urlparse
from huggingface_hub import hf_hub_download

def download_models(
    base_dir: str,
    manifest,
):
    # Process each section of models (model_type_name would be 'checkpoints', 'loras', etc.)
    for model_type_name, models_list in manifest.items():
        section_dir = os.path.join(base_dir, model_type_name)
        os.makedirs(section_dir, exist_ok=True)

        # Iterate through models in this section
        for model in models_list:
            download_source = model.get('downloadSource', {})
            hf_info = download_source.get('huggingface_hub', {})
            hf_repo_id = hf_info.get('repo_id')
            hf_hub_filename = hf_info.get('filename')
            has_filename_override = 'local_filename' in model
            
            # Check if the model is already downloaded
            lfn = determine_local_filename(model)
            if lfn and os.path.exists(os.path.join(section_dir, lfn)):
                print(f"✅ {lfn} is already downloaded, skipping")
                continue

            if hf_repo_id and hf_hub_filename:
                # Download from Hugging Face Hub if we have that info
                try:
                    local_file_path = hf_hub_download(
                        repo_id=hf_repo_id, 
                        filename=hf_hub_filename,
                        local_dir=section_dir
                    )
                    print(f"✅ Downloaded model from Hugging Face Hub: {hf_repo_id}/{hf_hub_filename} -> {local_file_path}")
                    if has_filename_override: 
                        new_name = model.get('local_filename')
                        os.rename(local_file_path, os.path.join(section_dir, new_name))
                        print(f"✅ Renamed model from Hugging Face Hub to {new_name}")
                  
                except Exception as e:
                    print(f"⚠️ Failed to download model from Hugging Face Hub: {hf_repo_id}/{hf_hub_filename}. Error: {e}")
            elif 'default_url' in download_source:
                try:
                    url = download_source['default_url']
                    response = requests.get(download_source['default_url'], stream=True)
                    response.raise_for_status()

                    # Parse url to determine local filename
                    local_filename = model.get('local_filename') if has_filename_override else get_filename_from_url(url)
                    with open(os.path.join(base_dir, model_type_name, local_filename), 'wb') as file:
                        for chunk in response.iter_content(chunk_size=8192):
                            file.write(chunk)
                    print(f"✅ Downloaded model from default URL: {download_source['default_url']} -> {local_filename}")
                except Exception as e:
                    print(f"⚠️ Failed to download model from default URL: {download_source['default_url']}. Error: {e}")
            else:
                print(f"⚠️ Skipping model with incomplete download info: {model}")

def load_manifest_and_download_models(
    base_dir: str,
    manifest_path: str = 'models_manifest.json'
):
    # Root directory to store all models
    os.makedirs(base_dir, exist_ok=True)
    # Load the models manifest
    with open(manifest_path, 'r') as f:
        download_models(base_dir, json.load(f))

def determine_local_filename(model):
    download_source = model.get('downloadSource', {})
    hf_info = download_source.get('huggingface_hub', {})
    forced_filename = model.get('local_filename', None)
    default_url = model.get('default_url', None)

    if forced_filename: 
        fn = forced_filename
    elif hf_info:
        fn = hf_info.get('filename')
    elif default_url:
        fn = get_filename_from_url(default_url)
    else:
        fn = None

    return fn

def get_filename_from_url(url):
    return os.path.basename(urlparse(url))

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Process some file management tasks.')
    parser.add_argument('base_directory', type=str, help='Base directory to save files')
    parser.add_argument('--manifest', type=str, default=None, help='Location of the manifest file')

    args = parser.parse_args()

    print(f'Base Directory: {args.base_directory}')
    print(f'Manifest File Location: {args.manifest}')
    if args.manifest:
        load_manifest_and_download_models(args.base_directory, args.manifest)
    else: 
        load_manifest_and_download_models(args.base_directory)
