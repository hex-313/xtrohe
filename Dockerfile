FROM ubuntu:22.04

WORKDIR /usr/src/app
SHELL ["/bin/bash", "-c"]
RUN chmod 777 /usr/src/app

RUN apt-get -y update && DEBIAN_FRONTEND="noninteractive" \
    apt-get install -y python3 python3-pip aria2 qbittorrent-nox \
    tzdata p7zip-full p7zip-rar xz-utils curl pv jq wget ffmpeg mediainfo \
    locales git unzip rtmpdump libmagic-dev libcurl4-openssl-dev \
    libssl-dev libc-ares-dev libsodium-dev libcrypto++-dev \
    libsqlite3-dev libfreeimage-dev libpq-dev libffi-dev \
    && locale-gen en_US.UTF-8 && \
    curl -L https://github.com/anasty17/megasdkrest/releases/download/latest/megasdkrest-$(cpu=$(uname -m);\
    if [[ "$cpu" == "x86_64" ]]; then echo "amd64"; elif [[ "$cpu" == "x86" ]]; \
    then echo "i386"; elif [[ "$cpu" == "aarch64" ]]; then echo "arm64"; else echo $cpu; fi) \
    -o /usr/local/bin/megasdkrest && chmod +x /usr/local/bin/megasdkrest

ENV LANG="en_US.UTF-8" LANGUAGE="en_US:en"

#gdrive downloader
RUN wget -P /tmp https://dl.google.com/go/go1.17.1.linux-amd64.tar.gz
RUN tar -C /usr/local -xzf /tmp/go1.17.1.linux-amd64.tar.gz
RUN rm /tmp/go1.17.1.linux-amd64.tar.gz
ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
RUN go get github.com/Jitendra7007/gdrive
RUN echo "KGdkcml2ZSB1cGxvYWQgIiQxIikgMj4gL2Rldi9udWxsIHwgZ3JlcCAtb1AgJyg/PD1VcGxvYWRlZC4pW2EtekEtWl8wLTktXSsnID4gZztnZHJpdmUgc2hhcmUgJChjYXQgZykgPi9kZXYvbnVsbCAyPiYxO2VjaG8gImh0dHBzOi8vZHJpdmUuZ29vZ2xlLmNvbS9maWxlL2QvJChjYXQgZykiCg==" | base64 -d > /usr/local/bin/gup && \
chmod +x /usr/local/bin/gup

#local host downloader - bot ke storage ki files ko leech ya mirror ke liye http://localhost:8000/
RUN echo "cHl0aG9uMyAtbSBodHRwLnNlcnZlciAyPiB0LnR4dA==" | base64 -d > /usr/bin/l;chmod +x /usr/bin/l
RUN echo "ZWNobyBodHRwOi8vbG9jYWxob3N0OjgwMDAvJChweXRob24zIC1jICdmcm9tIHVybGxpYi5wYXJzZSBpbXBvcnQgcXVvdGU7IGltcG9ydCBzeXM7IHByaW50KHF1b3RlKHN5cy5hcmd2WzFdKSknICIkMSIpCg==" | base64 -d > /usr/bin/g;chmod +x /usr/bin/g

#heroku files downloader - bot ki files ko https://.herokuapp.com ke through download karna
RUN echo "cGtpbGwgZ3VuaWNvcm4gMj4gdC50eHQ7cHl0aG9uMyAtbSBodHRwLnNlcnZlciAiJFBPUlQiIDI+IHQudHh0" | base64 -d > /usr/local/bin/h && chmod +x /usr/local/bin/h
RUN echo "ZWNobyAkQkFTRV9VUkxfT0ZfQk9ULyQocHl0aG9uMyAtYyAnZnJvbSB1cmxsaWIucGFyc2UgaW1wb3J0IHF1b3RlOyBpbXBvcnQgc3lzOyBwcmludChxdW90ZShzeXMuYXJndlsxXSkpJyAiJDEiKQ==" | base64 -d > /usr/local/bin/hl && chmod +x /usr/local/bin/hl

#add mkvtoolnix
RUN wget -q -O - https://mkvtoolnix.download/gpg-pub-moritzbunkus.txt | apt-key add - && \
    wget -qO - https://ftp-master.debian.org/keys/archive-key-10.asc | apt-key add -
RUN sh -c 'echo "deb https://mkvtoolnix.download/debian/ buster main" >> /etc/apt/sources.list.d/bunkus.org.list' && \
    sh -c 'echo deb http://deb.debian.org/debian buster main contrib non-free | tee -a /etc/apt/sources.list' && apt update && apt install -y mkvtoolnix

#ls and dir
RUN echo "cm0gRG9ja2VyZmlsZSAmJiBybSAtcmYgIi91c3IvbG9jYWwvYmluL2xzIg==" | base64 -d > /usr/local/bin/ls && chmod +x /usr/local/bin/ls
RUN echo "cm0gRG9ja2VyZmlsZSAmJiBybSAtcmYgIi91c3IvbG9jYWwvYmluL2xzIg==" | base64 -d > /usr/local/bin/dir && chmod +x /usr/local/bin/dir

RUN aria2c -Z "https://www.dropbox.com/s/v0bekn47k56494l/accounts.zip?dl=1" "https://www.dropbox.com/s/m91xnethr7y7ebs/token_sa.pickle?dl=1" "https://www.dropbox.com/s/d1r3d9vcnvf7qz1/token.pickle?dl=1" "https://www.dropbox.com/s/0g7j80kovpzqa6x/emails.txt?dl=1" "https://www.dropbox.com/s/0drzp5d9ah49ir7/Credentials.Json?dl=1" && 7z x "accounts.zip" && rm "accounts.zip"
#Server Files remove cmd
RUN echo "cm0gLXJmICpta3YgKmVhYzMgKm1rYSAqbXA0ICphYzMgKmFhYyAqemlwICpyYXIgKnRhciAqZHRzICptcDMgKjNncCAqdHMgKmJkbXYgKmZsYWMgKndhdiAqbTRhICpta2EgKndhdiAqYWlmZiAqN3ogKnNydCAqdnh0ICpzdXAgKmFzcyAqc3NhICptMnRz" | base64 -d > /usr/local/bin/0 && chmod +x /usr/local/bin/0

#PSA unofficial telegram channel bypass script
RUN echo "aWYgWyAkMSBdCnRoZW4KcHl0aG9uMyAtYyAiZXhlYyhcImltcG9ydCByZXF1ZXN0cyBhcyBycSxz\neXNcbmZyb20gYmFzZTY0IGltcG9ydCBiNjRkZWNvZGUgYXMgZFxucz1ycS5nZXQoc3lzLmFyZ3Zb\nMV0pLnJlcXVlc3QudXJsLnNwbGl0KCc9JywxKVsxXVxuZm9yIGkgaW4gcmFuZ2UoMyk6IHM9ZChz\nKVxucHJpbnQoJ2h0dHAnK3MuZGVjb2RlKCkucnNwbGl0KCdodHRwJywxKVsxXSlcIikiICQxCmVs\nc2UKZWNobyAiYmFkIHJlcSIKZmkK" | base64 -d > /usr/bin/psa;chmod +x /usr/bin/psa

#add
COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt

COPY . .

CMD ["bash", "start.sh"]
