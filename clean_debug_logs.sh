#!/bin/bash

echo "🧹 清理AI调试日志..."

# 备份原文件
cp WebSSH/webssh/src/views/Home.vue WebSSH/webssh/src/views/Home.vue.debug_backup

# 移除所有AI调试日志
sed -i.bak '/console\.log.*AI Debug/d' WebSSH/webssh/src/views/Home.vue
sed -i.bak '/console\.error.*AI Debug/d' WebSSH/webssh/src/views/Home.vue

# 清理临时文件
rm WebSSH/webssh/src/views/Home.vue.bak

echo "✅ 调试日志已清理"
echo "📋 原文件备份：WebSSH/webssh/src/views/Home.vue.debug_backup"

# 重新编译
echo "🔧 重新编译..."
./rebuild_ai_interactive.sh 