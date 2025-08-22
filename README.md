# Dead Simple Docker Sandbox for Claude Code


## Instructions

Build the Docker image:

```shell
docker build -t claude-code-sandbox .
```

Add this to your ~/.bashrc, ~/.zshrc, or ~/.bash_profile:

```bash
claude-sandbox() {
    # Get the directory argument (default to current directory)
    local project_dir=${1:-$(pwd)}
    
    # Convert to absolute path
    project_dir=$(realpath "$project_dir")
    
    # Check if directory exists
    if [ ! -d "$project_dir" ]; then
        echo "Error: Directory '$project_dir' does not exist"
        return 1
    fi
    
    echo "Starting claude-code sandbox in: $project_dir"

    # Create Claude config directory if it doesn't exist
    mkdir -p ~/.claude
    
    # Run the docker container
    docker run -it --rm \
        -v "$project_dir:/workspace" \
        -v "$HOME/.claude:/home/claude/.claude" \
        -e ANTHROPIC_API_KEY="$ANTHROPIC_API_KEY" \
        --name "claude-sandbox-$(basename "$project_dir")" \
        claude-code-sandbox
}
export CLAUDE_CONFIG_DIR="$HOME/.claude" # allows auth to be re-used from claude agent on your host machine
```

Then, run the sandbox with:

```shell
claude-sandbox .
```

This will start the sandbox in the specified directory.
