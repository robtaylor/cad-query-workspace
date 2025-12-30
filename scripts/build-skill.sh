#!/bin/bash
# Build skill ZIP packages for distribution
# Usage: ./scripts/build-skill.sh [skill-name]
#
# If skill-name is provided, builds only that skill.
# Otherwise, builds all skills found in the skills/ directory.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
SKILLS_DIR="$PROJECT_ROOT/skills"
DIST_DIR="$PROJECT_ROOT/dist"

# Create dist directory
mkdir -p "$DIST_DIR"

build_skill() {
    local skill_path="$1"
    local skill_name
    skill_name="$(basename "$skill_path")"

    if [[ ! -f "$skill_path/SKILL.md" ]]; then
        echo "Error: No SKILL.md found in $skill_path"
        return 1
    fi

    local zip_file="$DIST_DIR/${skill_name}.zip"

    echo "Building $skill_name..."

    # Remove old zip if exists
    rm -f "$zip_file"

    # Create zip from skill directory
    (cd "$skill_path" && zip -r "$zip_file" . \
        -x "*.pyc" \
        -x "__pycache__/*" \
        -x ".DS_Store" \
        -x "*.egg-info/*" \
        -x ".git/*" \
        -x "node_modules/*" \
        -x "tests/*" \
    )

    echo "Created: $zip_file"
}

# Main
if [[ $# -ge 1 ]]; then
    # Build specific skill
    skill_name="$1"
    skill_path="$SKILLS_DIR/$skill_name"

    if [[ ! -d "$skill_path" ]]; then
        echo "Error: Skill '$skill_name' not found in $SKILLS_DIR"
        exit 1
    fi

    build_skill "$skill_path"
else
    # Build all skills
    if [[ ! -d "$SKILLS_DIR" ]]; then
        echo "Error: Skills directory not found: $SKILLS_DIR"
        exit 1
    fi

    skill_count=0
    for skill_path in "$SKILLS_DIR"/*/; do
        if [[ -f "${skill_path}SKILL.md" ]]; then
            build_skill "${skill_path%/}"
            skill_count=$((skill_count + 1))
        fi
    done

    if [[ $skill_count -eq 0 ]]; then
        echo "No skills found in $SKILLS_DIR"
        exit 1
    fi

    echo ""
    echo "Built $skill_count skill(s)"
fi

echo ""
echo "Skill packages available in: $DIST_DIR"
ls -la "$DIST_DIR"/*.zip 2>/dev/null || true
