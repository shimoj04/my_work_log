FROM python:3.11-slim

# システムパッケージ_pip・dbtのインストール
RUN apt-get update && \
    apt-get install -y jq git build-essential libpq-dev && \
    pip install --upgrade pip && \
    pip install --no-cache-dir dbt-postgres && \
    rm -rf /var/lib/apt/lists/*
