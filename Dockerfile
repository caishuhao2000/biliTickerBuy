FROM python:3.12
WORKDIR /app
RUN cp /etc/apt/sources.list.d/debian.sources /etc/apt/sources.list.d/debian.sources.bak

RUN sed -i 's|URIs: http://deb.debian.org/debian|URIs: https://mirrors.aliyun.com/debian|g' /etc/apt/sources.list.d/debian.sources

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl tzdata libgl1 libglib2.0-0 && \
    ln -sf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
RUN curl -sSf https://sh.rustup.rs  | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
ENV TZ=Asia/Shanghai
COPY requirements.txt .
RUN python -m pip install --no-cache-dir -r requirements.txt  -i https://pypi.tuna.tsinghua.edu.cn/simple
COPY . .
ENV BTB_SERVER_NAME="0.0.0.0"
ENV GRADIO_SERVER_PORT 7860
RUN playwright install-deps
RUN playwright install chromium

CMD ["python", "main.py"]
