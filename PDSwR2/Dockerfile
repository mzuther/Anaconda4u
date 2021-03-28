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
ARG home
ARG jupyter_port

# run as root
USER root

RUN mamba install --yes --channel conda-forge r-arules r-bitops \
    r-catools r-dbi r-dbplyr r-diagrammer r-dplyr r-e1071 r-fpc \
    r-ggplot2 r-glmnet r-glmnetutils r-gridextra r-hexbin r-kernlab \
    r-igraph r-knitr r-lime r-lubridate r-magrittr r-mass r-mgcv \
    r-pander r-plotly r-pwr r-randomforest r-readr r-readxl \
    r-rmarkdown r-rpart r-rpart.plot r-rpostgres r-rsqlite r-scales \
    r-sqldf r-tidypredict r-text2vec r-tidyr r-xgboost r-xts \
    r-webshot r-zeallot r-zoo


# try to use as many CPUs as possible when using "make"
RUN Rscript -e "install.packages(c( \
      'cdata', 'data.table', 'rqdatatable', 'rquery', 'sigr', \
      'vtreat', 'wrapr', 'WVPlots'), \
    repos = 'https://cloud.r-project.org/', \
    dependencies = c('Depends', 'Imports', 'LinkingTo'), \
    Ncpus = $(nproc))"

# switch to new user
USER $user
WORKDIR $home

EXPOSE $jupyter_port
CMD /opt/conda/bin/jupyter-lab --config=.include/jupyter_lab_config.py
