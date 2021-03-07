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


ARG base_image
FROM $base_image

ARG user
ARG uid
ARG jupyter_port
ENV home=/home/$user

# run commands as non-root with a dedicated home directory
RUN adduser --disabled-password --gecos GECOS --home $home --uid $uid $user

# run as root
RUN mamba install --yes --channel conda-forge scikit-learn
RUN mamba install --yes --channel conda-forge xgboost

# switch to new user
USER $user
WORKDIR $home

COPY --chown=$user ./include/* $home/.include/
RUN ln -s $home/shared/.jupyter $home

EXPOSE $jupyter_port
