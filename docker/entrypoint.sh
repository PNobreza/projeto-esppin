#!/bin/bash
# Inicia o serviço de cron
service cron start

# Inicia o Apache em foreground para manter o container rodando
exec apachectl -D FOREGROUND
