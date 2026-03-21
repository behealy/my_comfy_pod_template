#!/usr/bin/env bash
set -euo pipefail

# Version increment script for ComfyUI RunPod template
# Usage: ./build.sh [--major|--minor|--patch] [--commit] [--tag]

REPO_NAME="behealy/my_comfy_pod"
DEFAULT_VERSION_FILE="VERSION.txt"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

usage() {
    cat <<USAGE_EOF
Usage: $(basename "$0") [OPTIONS]

Build, version bump and push Docker image.

Options:
  --major/-m       Increment major version (X.0.0)
  --minor/-n       Increment minor version (X.Y+1.0)
  --patch/-p       Increment patch version (X.Y.Z+1)
  --dry-run        Show what would be done without making changes

Examples:
  $(basename "$0") --patch                # Bump patch and rebuild
  $(basename "$0") -m --commit --tag      # Major bump with commit and tag
USAGE_EOF
    exit 1
}

# Parse arguments
VERSION_INCREMENT=""
USE_GIT_TAG=0
DRY_RUN=0

while [[ $# -gt 0 ]]; do
    case $1 in
        --major|-m)
            VERSION_INCREMENT="major"
            shift
            ;;
        --minor|-n)
            VERSION_INCREMENT="minor"
            shift
            ;;
        --patch|-p)
            VERSION_INCREMENT="patch"
            shift
            ;;
        --dry-run)
            DRY_RUN=1
            shift
            ;;
        -h|--help)
            usage
            ;;
        *)
            log_error "Unknown option: $1"
            usage
            ;;
    esac
done

# Validate version increment
if [[ -z "$VERSION_INCREMENT" ]]; then
    if [[ $USE_GIT_TAG -eq 0 ]]; then
        VERSION_INCREMENT="patch"
    fi
fi

get_version() {
    if [[ $USE_GIT_TAG -eq 1 ]]; then
        local tag
        tag=$(git describe --tags --exact-match 2>/dev/null) || \
            log_error "No git tag found at HEAD. Use --patch explicitly."
            export RELEASE="$tag"
            echo "$tag"
    elif [[ -f "$DEFAULT_VERSION_FILE" ]]; then
        cat "$DEFAULT_VERSION_FILE" | tr -d '[:space:]'
    else
        log_error "VERSION.txt not found and no git tag at HEAD"
        export RELEASE=""
        exit 1
    fi
}

bump_version() {
    local v_old="$1"
    local result=""
    
    IFS='.' read -r major minor patch <<< "$v_old"
    
    case $VERSION_INCREMENT in
        major)
            ((major++)) || true
            result="${major}.0.0"
            ;;
        minor)
            ((minor++)) || true
            ((patch=0)) || true
            result="${major}.${minor}.0"
            ;;
        patch)
            ((patch++)) || true
            result="${major}.${minor}.${patch}"
            ;;
        *)
            log_error "Unknown version increment: $VERSION_INCREMENT"
            exit 1
            ;;
    esac
    
    echo "$result"
}

main() {
    local old_version new_version
    
    old_version=$(get_version)
    log_info "Current version: $old_version"
    
    new_version=$(bump_version "$old_version")
    log_info "New version: $new_version"
    
    if [[ $DRY_RUN -eq 1 ]]; then
        log_warn "[DRY RUN] Would update VERSION.txt to: $new_version"
        exit 0
    fi
    
    echo "$new_version" > "$DEFAULT_VERSION_FILE"
    log_info "Updated $DEFAULT_VERSION_FILE"
    
    # if [[ $DO_COMMIT -eq 1 ]]; then
        commit_and_tag "$old_version" "$new_version"
    # fi
    
    build_and_push "$old_version" "$new_version"
}

commit_and_tag() {
    local old_ver="$1"
    local new_ver="$2"
    
    log_info "Committing version bump..."
    
    local message="chore: release $new_ver (bumped from $old_ver)"
    git commit -am "$message" || \
        log_error "Failed to commit. Ensure all changes are staged." && return 1
    
    if ! git push origin HEAD; then
        log_warn "Not pushing commits"
        return 1
    fi
    
    log_info "Pushing tag \"$new_ver\"..."
    
    git fetch --tags 2>/dev/null || true
    git tag -f -a "$new_ver" -m "Release $new_ver (bumped from $old_ver)" || \
        log_error "Failed to create tag" && return 1
    
    if ! git push origin "$new_ver"; then
        log_warn "Not pushing tag"
        return 1
    fi
    
    log_info "Created and pushed tag: $new_ver"
}

build_and_push() {
    local old_ver="$1"
    local new_ver="$2"
    
    log_info "Building Docker image..."
    
    if [[ $DRY_RUN -eq 1 ]]; then
        log_warn "[DRY RUN] Would build: $REPO_NAME:$new_ver and $REPO_NAME:$new_ver-bakedin"
        return 0
    fi

    export RELEASE=$(cat "$DEFAULT_VERSION_FILE" | tr -d '[:space:]')
    docker buildx bake --push

    log_info "Successfully built and pushed all variants for version: $new_ver"
}

main
