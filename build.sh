#!/bin/bash

#  ----------------------------------------------------------------------------
#
#  Anaconda4u
#  ==========
#  Build your own Anaconda container easily.
#
#  Copyright (c) 2021 Martin Zuther (http://www.mzuther.de/)
#
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
#  Thank you for using free software!
#
#  ----------------------------------------------------------------------------


function copy_settings {
    mkdir -p "./include"

    # check whether variable "force_copy" exists
    # (https://stackoverflow.com/a/13864829)
    if [ ${force_copy+x} ]; then
        printf "Copying differing files from \"./data/\" to \".\"...\n\n"

        rsync -avAHX --update "./data/" "."
    else
        printf "Copying missing files from \"./data/\" to \".\"...\n\n"

        rsync -avAHX --ignore-existing "./data/" "."
    fi

    printf "\nDone.\n\n"
}


function generate_jupyter_password {
    password_file="jupyter_notebook_config.json"
    dest="include/$password_file"

    if [ ! -f "$dest" ]; then
        printf "Please enter a password for Jupyter Lab:\n"

        password_base_dir="$(realpath ./password_creation)"
        mkdir -p "$password_base_dir"

        # run Docker container to create password
        docker run \
               --tty --interactive \
               --publish $jupyter_port:$jupyter_port \
               --mount type=bind,source="$password_base_dir",target="$shared_docker" \
               "$docker_base_image" \
               /bin/bash -c "/opt/conda/bin/jupyter notebook password --config=$shared_docker/$password_file"

        mv "$password_base_dir/$password_file" "$dest"
        rm -rf "$password_base_dir"

        printf "\n"
    fi
}


function generate_tls_certificate {
    dest="$1"

    if [ ! -f "$dest" ]; then
        # https://wiki.archlinux.org/index.php/OpenSSL#Generate_a_self-signed_certificate_with_private_key_in_a_single_command
        openssl req -x509 -newkey rsa:4096 -days 730 -nodes -batch -keyout "$dest" -out "$dest"
        printf "\n"
    fi
}


# bootstrap
printf "\n"
copy_settings

source "./settings.sh"
printf "\n"


# build Docker base image
printf "Building base image...\n\n"

docker build \
       --file="./Dockerfile.base" \
       --tag "$docker_base_image" \
       --build-arg=base_image="$anaconda_distribution" \
       --build-arg=user="$username" \
       --build-arg=uid="$uid" \
       --build-arg=home="$docker_home" \
       --build-arg=jupyter_port=$jupyter_port \
       --pull \
       .

printf "\nDone.\n\n\n"


# create Jupyter Lab configuration
generate_jupyter_password
generate_tls_certificate "$jupyter_cert_file"


# build Docker worker image
printf "Building worker image...\n\n"

docker build \
       --file="./Dockerfile" \
       --tag "$docker_image" \
       --build-arg=base_image="$docker_base_image" \
       --build-arg=user="$username" \
       --build-arg=uid="$uid" \
       --build-arg=home="$docker_home" \
       --build-arg=jupyter_port=$jupyter_port \
       "$@" \
       .

printf "\nDone.\n\n"
