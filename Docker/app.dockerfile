FROM python:3.8

# Metadata
LABEL name="Journal Finder Test UI"
LABEL maintainer="MDPI AI Team"
LABEL version="0.1"

ARG YOUR_ENV="virtualenv"

ENV YOUR_ENV=${YOUR_ENV} \
    PYTHONFAULTHANDLER=1 \
    PYTHONUNBUFFERED=1 \
    PYTHONHASHSEED=random \
    PIP_NO_CACHE_DIR=off \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    PIP_DEFAULT_TIMEOUT=100 \
    POETRY_VERSION=1.1.13 \
    LC_ALL=C.UTF-8 \
    LANG=C.UTF-8 \
    PATH="$POETRY_HOME/bin:$VENV_PATH/bin:$PATH" 

# Project Python definition
WORKDIR /mde

#Copy all the project files
COPY pyproject.toml .
COPY poetry.lock .

RUN DEBIAN_FRONTEND=noninteractive apt update && apt install -y \
    vim libpq-dev gcc curl openssh-client git unixodbc-dev libxml2-dev libxslt1-dev zlib1g-dev g++\
    && pip install "poetry==$POETRY_VERSION" \
    && poetry config virtualenvs.create false \
    && poetry install $(test "$YOUR_ENV" = production) --no-interaction --no-ansi

COPY /app ./app
COPY ./scripts/launch.sh .

#Launch the main (if required)
RUN chmod +x launch.sh
CMD ["bash", "launch.sh"]