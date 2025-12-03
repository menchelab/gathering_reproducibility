# get some linux distribution
FROM ubuntu:resolute-20251130

# copy uv specific things and uv to image
COPY uv.lock .
COPY pyproject.toml .
COPY --from=docker.io/astral/uv:latest /uv /uvx /bin/

# run everything at once to ensure single layer build
# this installs the required python version
# pins it
# syncs the environment aka create .venv
# and cleans the uv cache to reduce image size
RUN uv python install 3.12 && \
    uv python pin 3.12 && \
    uv sync && \
    uv cache clean

# set env so we can use python as is
ENV PATH=/.venv/bin:$PATH

# set entrypoint to default shell
CMD ["/bin/bash"]
