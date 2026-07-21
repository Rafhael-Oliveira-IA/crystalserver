#!/usr/bin/env bash

set -u

BIN_PATH=${1:-"./crystalserver"}
RESTART_DELAY=${RESTART_DELAY:-2}
RESTART_COUNT=0

if [[ ! -x "$BIN_PATH" ]]; then
    echo "[Error] Executable not found or not executable: $BIN_PATH"
    echo "[Hint] Build the server first or pass the binary path as argument."
    exit 1
fi

echo "[Info] Auto-restart enabled for: $BIN_PATH"
echo "[Info] Press Ctrl+C to stop."

while true; do
    RESTART_COUNT=$((RESTART_COUNT + 1))
    echo ""
    echo "[Info] Starting CrystalServer (attempt #$RESTART_COUNT) at $(date '+%F %T')"

    "$BIN_PATH"
    EXIT_CODE=$?

    echo "[Warn] CrystalServer exited with code $EXIT_CODE at $(date '+%F %T')"
    echo "[Info] Restarting in ${RESTART_DELAY}s..."
    sleep "$RESTART_DELAY"
done