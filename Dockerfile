# Dockerfile
FROM python:3.12-slim

# Variables de Python para entornos containerizados
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

WORKDIR /app

# Dependencias del sistema (psycopg2 necesita libpq)
RUN apt-get update && apt-get install -y --no-install-recommends \
    libpq-dev gcc \
    && rm -rf /var/lib/apt/lists/*

# IMPORTANTE: copiar requirements ANTES del código
# Así la capa de pip install se cachea si solo cambias main.py
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Ahora sí, el código
COPY . .

EXPOSE 8000

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
