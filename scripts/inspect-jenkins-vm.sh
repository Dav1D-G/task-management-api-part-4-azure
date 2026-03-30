#!/bin/bash
set -e

echo "== docker ps -a =="
docker ps -a || true

echo "== ss 8080 =="
ss -lntp | grep 8080 || true

echo "== compose files =="
ls -la /opt/jenkins-platform || true

echo "== jenkins logs =="
docker logs --tail 100 jenkins-part4-azure 2>/dev/null || true

echo "== initial admin password =="
docker exec jenkins-part4-azure cat /var/jenkins_home/secrets/initialAdminPassword 2>/dev/null || true
