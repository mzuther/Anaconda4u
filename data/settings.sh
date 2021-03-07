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


username=$(id -un)
export username

uid=$(id -u)
export uid

export docker_base_image="anaconda4u.base:latest"
export docker_image="anaconda4u:latest"

export jupyter_port=8888
export jupyter_cert_file="./include/jupyter.pem"

export shared_local="$HOME/Documents/data_science/anaconda4u/shared"
export shared_docker="/home/$username/shared"
