#!/bin/bash
# Claude Code Notification(permission_prompt) 이벤트 → Slack 알림
# 권한 요청 시 모바일 Slack으로 알림을 전송한다. exit 0 보장으로 Claude Code 동작에 영향 없음

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

# Notification 페이로드에 tool 정보가 포함된 경우 추가 표시
tool_name = data.get("tool_name", "")
tool_input = data.get("tool_input", {})

blocks = [
    {
        "type": "header",
        "text": {"type": "plain_text", "text": "🔐 Claude Code 권한 요청", "emoji": True}
    },
    {
        "type": "section",
        "fields": [
            {"type": "mrkdwn", "text": "*프로젝트:*\n" + project},
            {"type": "mrkdwn", "text": "*요청 시각:*\n" + timestamp}
        ]
    }
]

# tool 정보가 있으면 추가
if tool_name:
    detail = ""
    if tool_name == "Bash":
        cmd = tool_input.get("command", "")
        detail = (cmd[:200] + "...") if len(cmd) > 200 else cmd
    elif "file_path" in tool_input:
        detail = tool_input["file_path"]
    elif tool_input:
        first_key = list(tool_input.keys())[0]
        val = str(tool_input[first_key])
        detail = (val[:200] + "...") if len(val) > 200 else val

    blocks.append({
        "type": "section",
        "fields": [
            {"type": "mrkdwn", "text": "*도구:*\n`" + tool_name + "`"},
            {"type": "mrkdwn", "text": "*내용:*\n" + (detail if detail else "-")}
        ]
    })

blocks.append({
    "type": "context",
    "elements": [{"type": "mrkdwn", "text": "📁 " + cwd}]
})

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
