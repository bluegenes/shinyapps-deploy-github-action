# start from shiny-verse to include both the shiny and tidyverse packages,
# saving us time assuming that the app to be deployed doesn't have dependencies
# locked to different versions.
FROM rocker/shiny-verse:4.5.0

# install rsconnect and renv packages, as well as prerequisite libraries
RUN apt-get update && apt-get install -y \
    libssl-dev \
    libcurl4-openssl-dev \
    libproj-dev \
    libgdal-dev \
    libudunits2-dev \
    gdal-bin \
    git \
    libabsl-dev \
    pkg-config \
    cmake

# install renv = 1.1.4
RUN R -e 'install.packages("remotes")'
RUN R -e 'remotes::install_version("renv", version = "1.1.4")'

# copy everything into root of container
COPY . .
# copy deploy script to root of the workspace
#COPY deploy.R /deploy.R

# Set working directory to root
WORKDIR /

# run deploy script, ignoring any .Rprofile files to avoid issues with conflicting
# library paths.
# TODO: this may cause issues if the .Rprofile does any setup required for the app to run
CMD ["Rscript", "--no-init-file", "deploy.R"]
