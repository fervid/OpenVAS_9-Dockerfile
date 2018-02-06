FROM jessie:8.10


RUN apt-get update && \
    apt-get upgrade && \
    apt-get clean


RUN wget https://raw.githubusercontent.com/leonov-av/openvas-commander/master/openvas_commander.sh && \
    chmod +x openvas_commander.sh && \
    ./openvas_commander.sh --install-dependencies


RUN ./openvas_commander.sh --download-sources "OpenVAS-9" && \
    ./openvas_commander.sh --create-folders && \
    ./openvas_commander.sh --install-all


RUN ./openvas_commander.sh --update-content && \
    ./openvas_commander.sh --configure-all


RUN service redis-server start && \
    ./openvas_commander.sh --start-all && \
    echo "loop over grep" && \
    while [ $? -eq 1 ]; do ./openvas_commander.sh --check-proc | grep 'openvassd: Waiting for incoming connections' | grep -v grep; done && \
    ./openvas_commander.sh --rebuild-content && \
    ./openvas_commander.sh --check-status v9 | grep 'It seems like your OpenVAS-9 installation is OK.' | grep -v grep


ENTRYPOINT ["/sbin/init"]
