#!/bin/bash

SERVICE_NAME="test_monitoring"
LOG_FILE='/var/log/monitoring_test.log'
URL_LINK='https://test.com/monitoring/test/api'

# Проверка на существование лог-файла
if [[ ! -f "$LOG_FILE" ]]; then
	# Создание лог файла
	touch "$LOG_FILE" 2>/dev/null || {
		echo "Ошибка создания лог-файла"
		exit 1
	}
fi


# Проверка запуска сервиса
service_running() {
	if systemctl is-active "$SERVICE_NAME"; then
		return 0
	else
		return 1
	fi
}

# Логгирование 
log_message() {
	echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}


main() {
	if service_running; then
		log_message "Сервер $SERVICE_NAME запущен"
	else
		log_message "Сервер не $SERVICE_NAME запущен"
	fi
}

main