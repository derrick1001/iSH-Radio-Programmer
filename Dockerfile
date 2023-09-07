FROM adosztal/network_automation:latest

COPY mk-docker-Ceragon.py /src/

RUN pip3 install --upgrade netmiko && \
    pip3 install rich colorama

CMD python3 /src/mk-docker-Ceragon.py
