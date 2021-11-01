FROM --platform=$BUILDPLATFORM openjdk:8-jdk-slim AS builder
COPY . /
RUN ./gradlew --no-daemon distTar

FROM openjdk:8-jre-alpine
COPY --from=builder /app/build/distributions/healthchek.tar .
RUN tar -xf healthchek.tar

RUN apk add busybox-extras tcpdump iptables bind-tools ngrep postgresql netcat-openbsd nmap

# MSSQL_VERSION can be changed, by passing `--build-arg MSSQL_VERSION=<new version>` during docker build
ARG MSSQL_VERSION=17.5.2.1-1
ENV MSSQL_VERSION=${MSSQL_VERSION}

WORKDIR /tmp
# Installing system utilities
RUN apk add --no-cache curl gnupg --virtual .build-dependencies -- && \
    # Adding custom MS repository for mssql-tools and msodbcsql
    curl -O https://download.microsoft.com/download/e/4/e/e4e67866-dffd-428c-aac7-8d28ddafb39b/msodbcsql17_${MSSQL_VERSION}_amd64.apk && \
    curl -O https://download.microsoft.com/download/e/4/e/e4e67866-dffd-428c-aac7-8d28ddafb39b/mssql-tools_${MSSQL_VERSION}_amd64.apk && \
    # Verifying signature
    curl -O https://download.microsoft.com/download/e/4/e/e4e67866-dffd-428c-aac7-8d28ddafb39b/msodbcsql17_${MSSQL_VERSION}_amd64.sig && \
    curl -O https://download.microsoft.com/download/e/4/e/e4e67866-dffd-428c-aac7-8d28ddafb39b/mssql-tools_${MSSQL_VERSION}_amd64.sig && \
    # Importing gpg key
    curl https://packages.microsoft.com/keys/microsoft.asc  | gpg --import - && \
    gpg --verify msodbcsql17_${MSSQL_VERSION}_amd64.sig msodbcsql17_${MSSQL_VERSION}_amd64.apk && \
    gpg --verify mssql-tools_${MSSQL_VERSION}_amd64.sig mssql-tools_${MSSQL_VERSION}_amd64.apk && \
    # Installing packages
    echo y | apk add --allow-untrusted msodbcsql17_${MSSQL_VERSION}_amd64.apk mssql-tools_${MSSQL_VERSION}_amd64.apk && \
    # Deleting packages
    apk del .build-dependencies && rm -f msodbcsql*.sig mssql-tools*.apk

WORKDIR /
# Adding SQL Server tools to $PATH
ENV PATH=$PATH:/opt/mssql-tools/bin

# Oracle client
ENV LD_LIBRARY_PATH=/lib

ARG ORACLE_INSTALLER=instantclient-basic-linux.x64-21.3.0.0.0.zip
RUN wget https://download.oracle.com/otn_software/linux/instantclient/213000/${ORACLE_INSTALLER} && \
    unzip ${ORACLE_INSTALLER} && \
    cp -r instantclient_21_3/* /lib && \
    rm -rf ${ORACLE_INSTALLER} && \
    apk add libaio && \
    apk add libaio libnsl libc6-compat
    cd /lib && \
    ln -s /lib64/* /lib && \
    ln -s libc.so.6 /lib/libresolv.so.2

ARG SQLPLUS_INSTALLER=instantclient-sqlplus-linux.x64-21.3.0.0.0.zip

RUN wget https://download.oracle.com/otn_software/linux/instantclient/213000/${SQLPLUS_INSTALLER} && \
    unzip ${SQLPLUS_INSTALLER} && \
    cp -r instantclient_21_3/* /lib && \
    rm -rf ${SQLPLUS_INSTALLER}

ENV PATH=$PATH:/lib

ENTRYPOINT ["/healthchek/bin/healthchek"]
