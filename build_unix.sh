#!/usr/bin/env bash
set -euo pipefail

# === 스크립트 위치 기준 루트 절대경로 ===
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-${(%):-%x}}")" && pwd)"
ROOT="$SCRIPT_DIR"

# === 프로젝트 경로 ===
LABELME_PATH="$ROOT/labelme"
ENTRY="$LABELME_PATH/__main__.py"

# === OSAM 모듈 설치 경로 ===
OSAM_PATH="$(python3 -c 'import os, osam; print(os.path.dirname(osam.__file__))')"

# === 산출물 경로 ===
SPEC_DIR="$ROOT/build"
WORK_DIR="$ROOT/build/work"
DIST_DIR="$ROOT/dist"

# === 사전 체크 ===
command -v pyinstaller >/dev/null 2>&1 || {
    echo "ERROR: pyinstaller not found in PATH. Activate your env first." >&2
    exit 1
}

[[ -f "$ENTRY" ]] || {
    echo "ERROR: Entry not found: $ENTRY" >&2
    exit 1
}

CLIP_VOCAB="$OSAM_PATH/_models/yoloworld/clip/bpe_simple_vocab_16e6.txt.gz"
[[ -f "$CLIP_VOCAB" ]] || {
    echo "ERROR: Missing vocab file: $CLIP_VOCAB" >&2
    exit 1
}

[[ -f "$LABELME_PATH/config/default_config.yaml" ]] || {
    echo "ERROR: Missing config: $LABELME_PATH/config/default_config.yaml" >&2
    exit 1
}

# === 이전 산출물 정리 ===
rm -rf "$SPEC_DIR" "$DIST_DIR"

# === PyInstaller 실행 (Unix: SRC:DST) ===
pyinstaller "$ENTRY" \
    --name=Labelme \
    --windowed \
    --noconfirm \
    --specpath="$SPEC_DIR" \
    --workpath="$WORK_DIR" \
    --distpath="$DIST_DIR" \
    --add-data="$CLIP_VOCAB:osam/_models/yoloworld/clip" \
    --add-data="$LABELME_PATH/config/default_config.yaml:labelme/config" \
    --add-data="$LABELME_PATH/icons:labelme/icons" \
    --add-data="$LABELME_PATH/translate:translate" \
    --icon="$LABELME_PATH/icons/icon.png" \
    --onefile

echo
echo "Build finished. Output: $DIST_DIR/Labelme"