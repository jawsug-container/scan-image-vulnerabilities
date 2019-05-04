FROM docker:18.06.3-ce-dind

ENV AWSCLI_VERSION=1.16.162 \
    JUPYTER_VERSION=1.0.0

RUN apk --no-cache add "python3=3.6.8-r2"

# Install AWS CLI
RUN apk --no-cache add "less=530-r0" "groff=1.22.3-r2" "jq=1.6-r0" \
    && find / -depth -type d -name __pycache__ -exec rm -rf {} \; \
    && rm -rf /usr/share/terminfo
RUN apk --no-cache add --virtual build-deps build-base py3-pip \
    && pip3 install "awscli==${AWSCLI_VERSION}" \
    && pip3 install "yq==2.7.2" \
    && find / -depth -type d -name __pycache__ -exec rm -rf {} \; \
    && apk del --purge -r build-deps \
    && rm -rf /root/.cache

# Install Jupyter notebook
RUN apk --no-cache add bash tini curl \
    && apk --no-cache add --virtual build-deps build-base linux-headers python3-dev \
    && pip3 install "jupyter==${JUPYTER_VERSION}" \
    && pip3 install backcall bash_kernel \
    && python3 -m bash_kernel.install \
    && find / -type d -name tests -depth -exec rm -rf {} \; \
    && find / -type d -name \__pycache__ -depth -exec rm -rf {} \; \
    && apk del --purge -r build-deps \
    && rm -rf /root/.cache

WORKDIR /root/notebook
COPY notebooks_config/entrypoint.sh /
RUN chmod +x /entrypoint.sh

VOLUME /root/config

ENTRYPOINT ["/entrypoint.sh"]
CMD ["tini", "--", "jupyter", "notebook"]

COPY notebooks_config/jupyter_notebook.py /root/.jupyter/jupyter_notebook_config.py
COPY notebooks /root/notebook
COPY infrastructure/cfn.yaml /root/notebook/infrastructure/
