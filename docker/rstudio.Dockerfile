FROM rocker/geospatial
# https://hub.docker.com/u/rocker/
# https://rocker-project.org/images/versioned/rstudio.html

LABEL mantainer=guilhermeviegas1993@gmail.com

RUN apt-get update --no-cache -y && \
    apt-get upgrade -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

VOLUME /home/rstudio/

# R packages of interest (that are not already installed in the rocker/geospatial)
RUN R -e "install.packages('Rcpp')"
RUN R -e "install.packages('RcppArmadillo')"

RUN R -e "install.packages('janitor')"
RUN R -e "install.packages('rio')"
RUN R -e "install.packages('styler')"
# RUN R -e "install.packages('DT')"

RUN R -e "install.packages('rnaturalearth')"
# RUN R -e "install.packages('sp')"
# RUN R -e "install.packages('spdep')"
# RUN R -e "install.packages('leaflet')"

# Install HSAR package:
RUN curl -o /home/rstudio/HSAR_0_5_1.tar.gz https://cran.r-project.org/src/contrib/Archive/HSAR/HSAR_0.5.1.tar.gz && \
    tar -xzvf /home/rstudio/HSAR_0_5_1.tar.gz -C /home/rstudio/ && \
    chmod -R 775 /home/rstudio/HSAR && \
    chown -R rstudio:rstudio /home/rstudio/HSAR && \
    R -e "install.packages('/home/rstudio/HSAR', repos = NULL, type = 'source')" && \
    rm -rf /home/rstudio/HSAR_0_5_1.tar.gz

    RUN rm -rf /tmp/*