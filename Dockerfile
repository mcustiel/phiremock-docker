FROM composer/composer

ENV PHARS_DIR /opt/phars
RUN mkdir $PHARS_DIR
ENV PATH $PHARS_DIR:$PATH

RUN composer global require mcustiel/phiremock

ENTRYPOINT ["phiremock"]

