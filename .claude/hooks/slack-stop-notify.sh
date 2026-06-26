#!/bin/bash
# Claude Code Stop 이벤트 → Slack 알림
# 작업 완료 시 모바일 Slack으로 알림을 전송한다. exit 0 보장으로 Claude Code 동작에 영향 없음

INPUT=$(cat)

# Webhook URL 로드: shell 환경변수 우선, 없으면 프로젝트 .env.local fallback
WEBHOOK_URL="${SLACK_WEBHOOK_URL:-}"
if [ -z "$WEBHOOK_URL" ] && [ -n "${CLAUDE_PROJECT_DIR:-}" ] && \
   [ -f "$CLAUDE_PROJECT_DIR/.env.local" ]; then
    WEBHOOK_URL=$(grep '^SLACK_WEBHOOK_URL=' "$CLAUDE_PROJECT_DIR/.env.local" \
                  | head -1 | cut -d'=' -f2- | tr -d '"'"'")
fi
[ -z "$WEBHOOK_URL" ] && exit 0

export WEBHOOK_URL
HOOK_TIMESTAMP=$(date '+%H:%M:%S')
export HOOK_TIMESTAMP

echo "$INPUT" | PYTHONUTF8=1 python3 -c '
import json, sys, os, urllib.request

webhook_url = os.environ.get("WEBHOOK_URL", "")
timestamp = os.environ.get("HOOK_TIMESTAMP", "")
if not webhook_url:
    sys.exit(0)

try:
    data = json.load(sys.stdin)
except Exception:
    sys.exit(0)

cwd = data.get("cwd", "")
project = cwd.split("/")[-1] if cwd else "Unknown"

blocks = [
    {
        "type": "header",
        "text": {"type": "plain_text", "text": "✅ Claude Code 작업 완료", "emoji": True}
    },
    {
        "type": "section",
        "fields": [
            {"type": "mrkdwn", "text": "*프로젝트:*\n" + project},
            {"type": "mrkdwn", "text": "*완료 시각:*\n" + timestamp}
        ]
    },
    {
        "type": "context",
        "elements": [{"type": "mrkdwn", "text": "📁 " + cwd}]
    }
]

payload = json.dumps({"blocks": blocks}).encode("utf-8")
req = urllib.request.Request(
    webhook_url,
    data=payload,
    headers={"Content-Type": "application/json"}
)
try:
    urllib.request.urlopen(req, timeout=5)
except Exception:
    pass
'

exit 0
