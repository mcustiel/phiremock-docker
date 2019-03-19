FROM composer

RUN composer global require mcustiel/phiremock

ENV COMPOSER_HOME /tmp
ENV PATH /tmp/vendor/bin:$PATH
ENV COMPOSER_ALLOW_SUPERUSER 1

ENTRYPOINT ["phiremock"]
