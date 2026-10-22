#!/bin/bash
# ============================================
# web 컨테이너 개수 유지 스크립트
# 사용법: ./keep-web-3.sh [원하는_개수] [점검_간격_초]
# 예)     ./keep-web-3.sh 3 10
# 종료:   Ctrl + C (백그라운드 실행 시 kill <PID>)
# ============================================
cd "$(dirname "$0")" || exit 1   # compose.yaml이 있는 디렉터리 기준으로 실행

DESIRED=${1:-3}      # 인자 없으면 3개
INTERVAL=${2:-10}    # 인자 없으면 10초

echo "감시 시작: web=${DESIRED} 유지 (${INTERVAL}초 간격, 종료: Ctrl+C)"

while true; do
  # 실행 중인 web 컨테이너 ID를 한 줄씩 출력 -> 줄 수 = 개수
  RUNNING=$(docker compose ps --status running -q web | wc -l | tr -d " ")

  if [ "$RUNNING" -ne "$DESIRED" ]; then
    echo "$(date "+%Y-%m-%d %H:%M:%S") web ${RUNNING}개 -> ${DESIRED}개로 복구"
    docker compose up -d --scale web="$DESIRED"
  fi

  sleep "$INTERVAL"
done
