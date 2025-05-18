#!/bin/bash


sudo systemctl stop test_monitoring.service
sudo systemctl disable test_monitoring.service
sudo rm /etc/systemd/system/test_monitoring.service
sudo systemctl stop test_monitoring.timer
sudo systemctl disable test_monitoring.timer
sudo rm /etc/systemd/system/test_monitoring.timer
sudo systemctl daemon-reload
sudo rm /var/log/monitoring_test.log
sudo rm /var/run/test_monitoring_pid 

