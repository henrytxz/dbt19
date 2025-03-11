FROM python:3.11-slim-bullseye

COPY requirements.txt ./

RUN pip install -U pip && \
    pip install -r requirements.txt \
    --no-cache-dir

ENV DBT_DIR=/dbt/eda1
ENV DBT_PROFILES_DIR=$DBT_DIR

WORKDIR $DBT_DIR

# this initially confused me a bit
# but then I think this mkdir ./dbt and copies all files over
COPY dbt/eda1 ./

RUN dbt deps