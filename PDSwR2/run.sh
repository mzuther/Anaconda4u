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

cd ..

# ensure that symlinks in image point to an existing directory
mkdir -p "$docker_volume_host/.config/ranger"
mkdir -p "$docker_volume_host/.local/share/jupyter"
mkdir -p "$docker_volume_host/.jupyter"

# open browser (might require a reload if Docker starts VERY slowly)
if [ -z "$1" ]; then
    (curl --silent --retry 30 --retry-delay 1 --retry-connrefused --insecure \
          https://127.0.0.1:$jupyter_port/ ; \
     sleep 2 ; \
     xdg-open https://127.0.0.1:$jupyter_port/) &
fi

# run Docker container
docker run \
       --tty --interactive --init \
       --publish $jupyter_port:$jupyter_port \
       --env=DISPLAY \
       --mount type=bind,source="/tmp/.X11-unix",target="/tmp/.X11-unix" \
       --mount type=bind,source="$docker_volume_host",target="$docker_volume_container" \
       "$docker_tag_custom.pdswr2" \
       $@
