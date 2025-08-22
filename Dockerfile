# Use Node.js official image which has better npm support
FROM node:24-bullseye

# Install essential tools
RUN apt-get update && apt-get install -y \
    curl \
    git \
    python3 \
    python3-pip \
    build-essential \
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

# Install Rust nightly toolchain for claude user
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain nightly
ENV PATH="/home/claude/.cargo/bin:${PATH}"

# Install Foundry stable for claude user
RUN curl -L https://foundry.paradigm.xyz | bash
ENV PATH="/home/claude/.foundry/bin:${PATH}"
RUN /home/claude/.foundry/bin/foundryup

# Set CLAUDE_CONFIG_DIR to store all config (including auth) in ~/.claude
ENV CLAUDE_CONFIG_DIR="/home/claude/.claude"

ENTRYPOINT ["claude"]
