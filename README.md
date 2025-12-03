A repository for our gathering on reproducibility on the 2nd of December 2025

# Instructions
1. Install the [uv python package manager](https://docs.astral.sh/uv/)
2. Clone the repository
3. Create a new branch locally
5. Install the environment specified by `environment.yml` using `uv`
6. Use uv to run `try_to_run_me_after_env_install.py`
7. Try adding a new dependency to the project and also to the script
8. Commit changes made to `pyproject.toml` and `uv.lock` file to your branch
9. (Optional) Push your branch to this repository (only possible for menchelab members otherwise you can also try to fork and push to your own)

# Bonus level
Once you managed to install the environment with `uv` you can try to create a container image containing the envrionment. To do so try the following
1. Make sure you have [Docker](https://www.docker.com/) (or similar like [Apptainer](https://apptainer.org/)) installed
2. Find suitable images of `uv` and a linux distribution of your choice on a registry like [docker hub](https://hub.docker.com/)
3. Use these images to generate a build script for a container (try following [this](https://devopscube.com/reduce-docker-image-size/) or [that](https://medium.com/@ksaquib/how-i-cut-docker-image-size-by-90-best-practices-for-lean-containers-1f705cead02b) guide to reduce the size of the resulting image)
4. Run the container and try to execute `try_to_run_me_after_env_install.py` again

# Happy reproducing :)
# My solution
## Environment conversion
The easiest way for me to do the following
```bash
git clone git@github.com:menchelab/gathering_reproducibility.git
cd gathering_reproducibility
uv init
# this is necessary to ensure correct python version
# because for me the default was the system wide which was not compatible with conda
uv python install 3.12
uv python pin 3.12
uv run try_to_run_me_after_env_install.py
```
On my mac it was also necessary to add the commented out settings to the pyproject.toml in order to get the correct torch wheel
## Build a docker image
To build a docker image it is necessary get a linux distribution of your choice and then follow [the instructions in the docs](https://docs.astral.sh/uv/guides/integration/docker/)
The `Dockerfile` contains the final build script that worked for me on my mac with Docker Desktop with some explanatory comments. After building it via the docker cli
```bash
cd gathering_reproducibility
docker build .
```
you can run the container with the directory mounted as follows
```bash
docker run -it -v <path_to_gathering_repo>:<absolute_path_to_directory_in_container> <image_hash>
```
After starting up you can then just navigate to <absolute_path_to_directory_in_container> and use `python try_to_run_me_after_env_install.py` to run the script.
Here <path_to_gathering_repo> is the directory the repo resided on your computer and <absolute_path_to_directory_in_container> is the directory you want the repo to show up in your container session.
e.g. I used the following `-v ~/gathering_reproducibility:/workdir` (path has to be absolute after the colon) which allowed me to do the following after startup
```bash
cd workdir
python try_to_run_me_after_env_install.py
```

Also please not that the image is quite large because the environment is also quite large. I tried to solve it with a multistage build but it did not result in a notable size reduction. Maybe there are more
advanced techniques but I am too lazy to do more here :)


