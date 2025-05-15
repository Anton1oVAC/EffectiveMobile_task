#!/bin/bash

# Создание рабочей директории тест юнита
mkdir -p /opt/misc/test_service_monitoring


# Создание простого демон-скрипт
tee /opt/misc/test_service_monitoring/test_monitoring >/dev/null <<'EOF'
#!/bin/bash
while true; do
    echo "$(date) - Test service is running" >> /opt/misc/test_service_monitoring/service_monitoring.log
    sleep 5
done
EOF

chmod +x /opt/misc/test_service_monitoring/test_monitoring


# Создание systemd юнит
tee /etc/systemd/system/test_monitoring.service >/dev/null <<EOF
[Unit]
Description=Test Monitoring

[Service]
WorkingDirectory=/opt/misc/test_service_monitoring
ExecStart=/opt/misc/test_service_monitoring/test_monitoring
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOF



systemctl daemon-reload

systemctl enable test_monitoring.service

systemctl start test_monitoring.service

systemctl status test_monitoring.service