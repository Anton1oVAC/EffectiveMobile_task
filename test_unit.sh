#!/bin/bash

# Создание рабочей директории тест юнита
mkdir -p /opt/misc/test_service_monitoring


# # Создание простого демон-скрипт
# tee /opt/misc/test_service_monitoring/test_monitoring >/dev/null <<'EOF'
# #!/bin/bash
# while true; do
#     echo "$(date) - Test service is running" >> /opt/misc/test_service_monitoring/service_monitoring.log
#     sleep 5
# done
# EOF

# chmod +x /opt/misc/test_service_monitoring/test_monitoring


# Создание systemd юнит
tee /etc/systemd/system/test_monitoring.service >/dev/null <<EOF
[Unit]
Description=Test Monitoring

[Service]
Type=simple
Restart=on-failure
WorkingDirectory=/opt/misc/test_service_monitoring
ExecStart=/opt/misc/test_service_monitoring/main.sh
User=root

[Install]
WantedBy=multi-user.target
EOF

chmod +x /opt/misc/test_service_monitoring/main.sh

# Отправка запроса каждую минуту
tee /etc/systemd/system/test_monitoring.timer >/dev/null <<EOF
[Unit]
Description=Test Monitoring every minute

[Timer]
OnActiveSec=1min
OnUnitActiveSec=1min
Unit=test_monitoring.service

[Install]
WantedBy=timers.target
EOF



systemctl daemon-reload

systemctl enable test_monitoring.service
systemctl enable test_monitoring.timer

systemctl start test_monitoring.service
systemctl start test_monitoring.timer

systemctl status test_monitoring.service
systemctl status test_monitoring.timer