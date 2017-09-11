FROM composer

RUN composer global require mcustiel/phiremock

ENTRYPOINT ["phiremock"]

