#!/usr/bin/env bash
set -euo pipefail



run_layered() {
    local phase="${1:-}"
    local group="${2:-}"
    local op="${3:-}"

    for fn in $(declare -F | awk '{print $3}'); do

        # ONLY allow task functions

        # must match phase
        [[ "$fn" != "task_${phase}_"* ]] && continue

        # if group provided, enforce it
        if [[ -n "$group" ]]; then
            [[ "$fn" != *"_${group}_"* ]] && continue
        fi

        # if op provided, enforce it
        if [[ -n "$op" ]]; then
            [[ "$fn" != *"_${op}" ]] && continue
        fi

        "$fn"
    done
}