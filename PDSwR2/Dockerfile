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

# try to use as many CPUs as possible when using "make"
RUN Rscript -e "install.packages(c( \
      'arules', 'bitops', 'caTools', 'cdata', 'data.table', 'DBI', \
      'dbplyr', 'DiagrammeR', 'dplyr', 'e1071', 'fpc', 'ggplot2', \
      'glmnet', 'glmnetUtils', 'gridExtra', 'hexbin', 'kernlab', \
      'igraph', 'knitr', 'lime', 'lubridate', 'magrittr', 'MASS', \
      'mgcv', 'pander', 'plotly', 'pwr', 'randomForest', 'readr', \
      'readxl', 'rmarkdown', 'rpart', 'rpart.plot', 'RPostgres', \
      'rqdatatable', 'rquery', 'RSQLite', 'scales', 'sigr', 'sqldf', \
      'tidypredict', 'text2vec', 'tidyr', 'vtreat', 'wrapr', 'WVPlots', \
      'xgboost', 'xts', 'webshot', 'zeallot', 'zoo'), \
    repos = 'https://cloud.r-project.org/', \
    dependencies = c('Depends', 'Imports', 'LinkingTo'), \
    Ncpus = $(nproc))"

# switch to new user
USER $user
WORKDIR $home

EXPOSE $jupyter_port
CMD /opt/conda/bin/jupyter-lab --config=.include/jupyter_lab_config.py
