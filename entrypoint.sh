#!/bin/bash

echo "Esperando a que la base de datos esté disponible..."

while ! bash -c "echo > /dev/tcp/$DATABASE_HOST/$DATABASE_PORT" 2>/dev/null; do
  sleep 1
done

echo "Base de datos disponible."

# Ejecutar migraciones
echo "Ejecutando migraciones..."
python manage.py migrate --noinput

# Recolectar archivos estáticos
echo "Recolectando archivos estáticos..."
python manage.py collectstatic --noinput

# Ejecutar el comando principal
echo "Iniciando aplicación..."
exec "$@"