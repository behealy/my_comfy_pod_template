import pytest
from unittest.mock import patch, mock_open, MagicMock, ANY, call
import os
import json
import tempfile
import model_manager

@pytest.fixture
def setup_data():
    base_dir = "diffusion"
    manifest = {
        "diffusion": {
            "checkpoints": [{
                "name": "test_model",
                "downloadSource": {
                    "huggingface_hub": {
                        "repo_id": "test/repo",
                        "filename": "test_model.safetensors"
                    }
                },
                "local_filename": "custom_name.safetensors"
            }],
            "loras": [{
                "name": "test_lora",
                "downloadSource": {
                    "default_url": "https://example.com/test_lora.safetensors"
                }
            }]
        }
    }
    return base_dir, manifest

@patch('model_manager.shutil.copyfile')
@patch('model_manager.requests.get')
@patch('model_manager.hf_hub_download')
@patch('model_manager.os.makedirs')
def test_download_models(mock_makedirs, mock_hf_download, mock_requests_get, mock_copy, setup_data):
    base_dir, manifest = setup_data
    
    # Set up mock responses
    mock_hf_download.return_value = "/mock/path/test_model.safetensors"
    mock_response = MagicMock()
    mock_response.iter_content.return_value = [b"chunk"]
    mock_response.raise_for_status.return_value = None
    mock_requests_get.return_value = mock_response
    
    # Test with empty directory (no existing files)
    model_manager.download_models(base_dir, manifest)
    
    # Verify HuggingFace download
    mock_hf_download.assert_called_once_with(
        hf_repo_id="test/repo",
        filename="test_model.safetensors",
        local_dir=os.path.join(base_dir, "checkpoints")
    )
    
    # Verify file copy for filename override
    mock_copy.assert_called_once_with(
        ANY,
        os.path.join(base_dir, "checkpoints", "custom_name.safetensors")
    )
    
    # Verify default URL download
    mock_requests_get.assert_called_once_with(
        "https://example.com/test_lora.safetensors",
        stream=True
    )

    mock_makedirs.assert_has_calls(
       [ call("diffusion/checkpoints", exist_ok=True), call("diffusion/loras", exist_ok=True) ]
    )

    
@patch('model_manager.hf_hub_download')
@patch('model_manager.os.path.exists')
@patch('model_manager.os.makedirs')
@patch('model_manager.requests.get')
def test_skip_existing_file(mock_get, mock_makedirs, mock_exists, mock_hf_download, setup_data):
    base_dir, manifest = setup_data
    
    # Test skipping when file already exists
    mock_exists.return_value = True
    
    model_manager.download_models(base_dir, {base_dir: {"checkpoints": manifest["diffusion"]["checkpoints"]}})
    
    # Verify hf_hub_download was not called
    mock_hf_download.assert_not_called()
    mock_get.assert_not_called()
