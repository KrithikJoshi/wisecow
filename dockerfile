FROM ubuntu:22.04

# Install required packages including dos2unix
RUN apt-get update && apt-get install -y \
    bash \
    fortune-mod \
    cowsay \
    netcat-openbsd \
    dos2unix \
    && rm -rf /var/lib/apt/lists/*

# Add /usr/games to PATH
ENV PATH="/usr/games:$PATH"

# Set working directory
WORKDIR /app

# Copy the script file
COPY wisecow.sh .

# Convert Windows line endings to Unix and make executable
RUN dos2unix wisecow.sh && chmod +x wisecow.sh

# Create non-root user
RUN groupadd -r wisecow && useradd -r -g wisecow wisecow
RUN chown -R wisecow:wisecow /app
USER wisecow

# Expose port
EXPOSE 4499

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD nc -z localhost 4499 || exit 1

# Run the script
CMD ["./wisecow.sh"]
