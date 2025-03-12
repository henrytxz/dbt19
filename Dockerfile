FROM python:3.11-slim-bullseye

COPY requirements.txt ./

# install dbt and git. git is a required dependency of dbt.
RUN pip install -U pip && \
    pip install -r requirements.txt --no-cache-dir && \
    apt-get update && \
    apt-get install -y git && \
    rm -rf /var/lib/apt/lists/*

ENV DBT_DIR=/dbt/eda1
ENV DBT_PROFILES_DIR=$DBT_DIR

WORKDIR $DBT_DIR

# this initially confused me a bit
# but then I think this mkdir ./dbt and copies all files over
COPY dbt/eda1 ./

RUN dbt deps
