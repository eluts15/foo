FROM rust:1.76-slim as builder

WORKDIR /usr/src/app
COPY . .

# Build the application with release optimizations
RUN cargo build --release

# Create a smaller final image
FROM debian:bookworm-slim

# Install dependencies required at runtime
RUN apt-get update && apt-get install -y \
    libssl-dev \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy the binary from the builder stage
COPY --from=builder /usr/src/app/target/release/foo /app/

# Set the binary as the entrypoint
ENTRYPOINT ["/app/foo"]
