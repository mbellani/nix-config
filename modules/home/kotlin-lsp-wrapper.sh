#!/usr/bin/env bash
export JAVA_TOOL_OPTIONS="-Xmx8g"
exec kotlin-language-server "$@"
