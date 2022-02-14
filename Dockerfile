FROM zmkfirmware/zmk-build-arm:2.5-branch

COPY config/west.yml /workspace/config/west.yml

WORKDIR /workspace

RUN west init -l config
RUN west update
RUN west zephyr-export
