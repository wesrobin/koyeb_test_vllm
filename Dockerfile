# Use NVIDIA CUDA base image with Python
FROM nvidia/cuda:12.1.0-cudnn8-runtime-ubuntu22.04

# Set working directory
WORKDIR /app

# Install Python and essential packages
RUN apt-get update && apt-get install -y \
    python3.11 \
    python3.11-dev \
    python3-pip \
    git \
    && rm -rf /var/lib/apt/lists/*

# Create symlink for python
RUN ln -s /usr/bin/python3.11 /usr/bin/python

# Copy requirements file
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Set environment variables
ENV CUDA_HOME=/usr/local/cuda
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/cuda/lib64
ENV PATH=$PATH:/usr/local/cuda/bin
ENV VLLM_WORKER_MULTIPROC_METHOD=spawn
ENV HF_TOKEN=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

# Expose port for vLLM API server
EXPOSE 8000

# Run vLLM serve command
CMD ["vllm", "serve", "NousResearch/Meta-Llama-3-8B-Instruct", "--dtype", "auto", "--api-key", "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", "--host", "0.0.0.0", "--port", "8000"]