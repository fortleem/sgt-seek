#!/bin/bash
echo "🚨 EMERGENCY SHUTDOWN INITIATED AT $(date)" >> /Users/tonsy/Documents/sgt-seek/reports/sentry.log

# 1. Stop Docker Stack
cd /Users/tonsy/Documents/sgt-seek/infra/docker
docker-compose down

# 2. Disable SSH Gateway
sudo launchctl unload /System/Library/LaunchDaemons/ssh.plist

echo "✅ System is now OFFLINE and SECURE." >> /Users/tonsy/Documents/sgt-seek/reports/sentry.log
