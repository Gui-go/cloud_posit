FROM rocker/geospatial

LABEL mantainer=guilhermeviegas1993@gmail.com

# system dependencies
RUN apt update -y
RUN apt install -y 
    #\
    # sudo \
    # pandoc \
    # libcurl4-gnutls-dev \
    # libcairo2-dev \
    # libxt-dev \
    # libssl-dev \
    # libssh2-1-dev \
    # xorg-dev \
    # libxml2-dev \
    # libmpfr-dev \
    # libsasl2-dev \
    # libudunits2-dev \
    # libgdal-dev
    # pandoc-citeproc \
    
VOLUME /home/rstudio/

RUN R -e "install.packages('Rcpp')"
RUN R -e "install.packages('RcppArmadillo')"

RUN R -e "install.packages('janitor')"
RUN R -e "install.packages('rio')"
RUN R -e "install.packages('styler')"

RUN R -e "install.packages('rnaturalearth')"


# HSAR package:
RUN curl -o /home/rstudio/HSAR_0_5_1.tar.gz https://cran.r-project.org/src/contrib/Archive/HSAR/HSAR_0.5.1.tar.gz
RUN tar -xzvf /home/rstudio/HSAR_0_5_1.tar.gz -C /home/rstudio/
RUN sudo chmod -R 775 /home/rstudio/HSAR/ && sudo chown -R rstudio:rstudio /home/rstudio/HSAR/
RUN R -e "install.packages('/home/rstudio/HSAR/', repos = NULL, type = 'source')"



# WORKDIR /home/rstudio/volume/

# RUN curl -o /home/rstudio/volume/HSAR_0_5_1.tar.gz https://cran.r-project.org/src/contrib/Archive/HSAR/HSAR_0.5.1.tar.gz
# RUN mkdir -p /home/rstudio/volume/HSAR
# RUN tar -xzvf /home/rstudio/volume/HSAR_0_5_1.tar.gz -C /home/rstudio/volume/HSAR --strip-components=1
# RUN sudo chown -R rstudio:rstudio /home/rstudio/volume/HSAR/
# RUN sudo chmod -R 775 /home/rstudio/volume/HSAR/
# RUN R -e "install.packages('/home/rstudio/volume/HSAR/', repos = NULL, type = 'source')"


# basic R packages
# RUN R -e "install.packages(c('shiny', 'rmarkdown'), repos='https://cloud.r-project.org/')" # main libs
# RUN R -e "install.packages(c('XML', 'devtools', 'bit64', 'xtable'))" # dev libs
# RUN R -e "install.packages(c('readr', 'rio'))" # load libs
# RUN R -e "install.packages(c('dplyr', 'plyr', 'janitor'))" # Treatment libs
# RUN R -e "install.packages(c('ggplot2'))" # viz libs

# additional R packages
# RUN R -e "install.packages('tidyverse')"
# RUN R -e "install.packages('mongolite')"
# RUN R -e "install.packages('reticulate')"
# RUN R -e "install.packages('shinydashboard')"
# RUN R -e "install.packages('shinyWidgets')"
# RUN R -e "install.packages('shinyjs')"
# RUN R -e "install.packages('shinycssloaders')"
# RUN R -e "install.packages('DT')"
# RUN R -e "install.packages('sparklyr')"

# spatial R packages
# RUN R -e "install.packages('sp')"
# RUN R -e "install.packages('spdep')"
# RUN R -e "install.packages('leaflet')"

# EXPOSE 8787

# ENV ROOT=true
# ENV USER=rstudio
# ENV PASSWORD=rstudio

# USER root

# CMD ["rstudio-server"]
