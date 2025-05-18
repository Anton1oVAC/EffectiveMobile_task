#!/bin/bash

SERVICE_NAME="test_monitoring"
LOG_FILE='/var/log/monitoring_test.log'
URL_LINK='https://www.google.com'
PID_FILE="/var/run/${SERVICE_NAME}_pid"


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
		log_message "Юнит работает"
		echo "Юнит работает"
		return 0
	else
		log_message "Юнит не работает"
		echo "Юнит не работает"
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


# Проверка на PID юнита
get_service_pid() {
	systemctl show -p MainPID "$SERVICE_NAME" | cut -d '=' -f2
}


service_restarted() {
    #текущий PID
    current_pid=$(get_service_pid)
    
    # Проверка на запущ юнит
    if [ -z "$current_pid" ]; then
        return 1
    fi
    
    mkdir -p "$(dirname "$PID_FILE")"
    
    # Чтение предыдущего PID
    previous_pid=""
    if [ -f "$PID_FILE" ] && [ -s "$PID_FILE" ]; then
        previous_pid=$(cat "$PID_FILE")
    fi
    
    # проверка на первый запуск и измененный пид
    if [ -z "$previous_pid" ] || [ "$current_pid" != "$previous_pid" ]; then
        echo "$current_pid" > "$PID_FILE"
        if [ -n "$previous_pid" ]; then
            log_message "Сервис перезапустился. Старый PID: $previous_pid -> Новый PID: $current_pid"
        fi
        return 0
    fi
	
    return 1
}


# Логгирование 
log_message() {
	echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}


main() {
	if service_running; then
		log_message "Сервер $SERVICE_NAME запущен"
		echo "Сервер $SERVICE_NAME запущен"

		sending_request

        service_restarted
		
	else
		log_message "Сервер не $SERVICE_NAME запущен"
		echo "Сервер не $SERVICE_NAME запущен"
	fi
}

main