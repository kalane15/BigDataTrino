#!/bin/bash
# Скрипт для генерации всех отчетов (витрин) через Trino внутри контейнера
# Ожидает, что SQL-файлы находятся в /trino/scripts и имеют имена dm*.sql

set -e  # остановка при любой ошибке

SCRIPT_DIR="/trino/scripts"

if [ ! -d "$SCRIPT_DIR" ]; then
    echo "Ошибка: директория $SCRIPT_DIR не найдена!"
    exit 1
fi
echo "=== Начинаем загрузку данных ==="
trino --file "$SCRIPT_DIR/load.sql"
echo "=== Данные загружены ==="

echo "=== Начинаем генерацию отчетов ==="

for sql_file in "$SCRIPT_DIR"/dm*.sql; do
    if [ -f "$sql_file" ]; then
        echo "Выполняется: $(basename "$sql_file") ..."
        trino --file "$sql_file"
        echo "Готово: $(basename "$sql_file")"
    else
        echo "Предупреждение: файлы dm*.sql не найдены в $SCRIPT_DIR"
        exit 0
    fi
done

echo "=== Все отчеты успешно созданы ==="