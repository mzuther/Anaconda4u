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
printf "Building base image...\n\n"

docker build \
       --file="./Dockerfile.base" \
       --tag "$docker_tag_base" \
       --build-arg=base_image="$docker_tag_anaconda" \
       --build-arg=user="$username" \
       --build-arg=uid="$uid" \
       --build-arg=home="$docker_home" \
       --build-arg=jupyter_port=$jupyter_port \
       --pull \
       .

printf "\nDone.\n\n\n"
printf "Building intermediate image...\n\n"

docker build \
       --file="./Dockerfile.intermediate" \
       --tag "$docker_tag_intermediate" \
       --build-arg=base_image="$docker_tag_base" \
       --build-arg=user="$username" \
       --build-arg=uid="$uid" \
       --build-arg=home="$docker_home" \
       --build-arg=jupyter_port=$jupyter_port \
       "$@" \
       .

# create Jupyter Lab configuration
generate_tls_certificate "$jupyter_cert_file"

printf "\nDone.\n\n\n"
printf "Building work image...\n\n"

docker build \
       --file="./Dockerfile.work" \
       --tag "$docker_tag_work" \
       --tag "$docker_tag_work_unique" \
       --build-arg=base_image="$docker_tag_intermediate" \
       --build-arg=user="$username" \
       --build-arg=uid="$uid" \
       --build-arg=home="$docker_home" \
       --build-arg=jupyter_port=$jupyter_port \
       "$@" \
       .

printf "\nDone.\n\n"
