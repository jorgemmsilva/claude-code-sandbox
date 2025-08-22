# Use Node.js official image which has better npm support
FROM node:24-bullseye

# Install essential tools
RUN apt-get update && apt-get install -y \
    curl \
    git \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Install Claude Code globally
RUN npm install -g @anthropic-ai/claude-code

# Verify installation (command is 'claude', not 'claude-code')
RUN which claude && claude --version

# Create a non-root user for security
RUN useradd -m -s /bin/bash claude

# Create workspace directory
RUN mkdir -p /workspace && chown claude:claude /workspace

# Switch to non-root user
USER claude
WORKDIR /workspace

# Set CLAUDE_CONFIG_DIR to store all config (including auth) in ~/.claude
ENV CLAUDE_CONFIG_DIR="/home/claude/.claude"

ENTRYPOINT ["claude"]
