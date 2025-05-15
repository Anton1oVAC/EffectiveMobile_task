#!/bin/bash

SERVICE_NAME="test_monitoring"
LOG_FILE='/var/log/monitoring_test.log'
URL_LINK='https://www.google.com'


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


# Отправка запроса на сервер
sending_request() {
	if curl -s --head "$URL_LINK"; then
		log_message "Запрос отправлен успешно"
		echo "Запрос отправлен успешно"

	else
		log_message "Сервер недоступен"
		echo "Сервер недоступен" 
	fi
}


# Логгирование 
log_message() {
	echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}


main() {
	if service_running; then
		log_message "Сервер $SERVICE_NAME запущен"
		echo "Сервер $SERVICE_NAME запущен"
		echo

		sending_request

	else
		log_message "Сервер не $SERVICE_NAME запущен"
		echo "Сервер не $SERVICE_NAME запущен"
		echo
	fi
}

main