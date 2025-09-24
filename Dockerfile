# Imagen base de Python
FROM python:3.13-slim

# Establecer variables de entorno
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV DJANGO_SETTINGS_MODULE=core.settings

# Establecer el directorio de trabajo dentro del contenedor
WORKDIR /app

# Instalar dependencias del sistema
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    pkg-config \
    default-libmysqlclient-dev \
    curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copiar e instalar dependencias de Python
COPY requirements.txt ./
RUN pip install --upgrade pip && pip install --no-cache-dir -r requirements.txt

# Copiar el resto del proyecto
COPY . .

# Crear directorios necesarios
RUN mkdir -p /app/staticfiles

# Copiar script de arranque
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Exponer puerto
EXPOSE 3000

# Punto de entrada
ENTRYPOINT ["/entrypoint.sh"]

# Comando por defecto
CMD ["gunicorn", "--bind", "0.0.0.0:3000", "--workers", "3", "--timeout", "120", "core.wsgi:application"]