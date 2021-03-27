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


source "../settings.sh"

# clone PDSwR2 files to "Documents" folder
if [ ! -d "$docker_volume_host/PDSwR2" ]; then
    git clone https://github.com/WinVector/PDSwR2.git "$docker_volume_host/PDSwR2"
fi

# build images this image depends on
cd ..
source "./build.sh"
cd "PDSwR2" || exit

printf "\nBuilding PDSwR2 image...\n\n"

docker build \
       --file="./Dockerfile" \
       --tag "$docker_tag_custom.pdswr2:latest" \
       --build-arg=base_image="$docker_tag_work" \
       --build-arg=user="$username" \
       --build-arg=uid="$uid" \
       --build-arg=home="$docker_home" \
       --build-arg=jupyter_port=$jupyter_port \
       .

printf "\nDone.\n\n"
