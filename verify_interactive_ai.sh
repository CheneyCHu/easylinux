#!/bin/bash

echo "🤖 WebSSH 交互式AI功能验证脚本"
echo "=================================="

# 检查服务状态
echo "1. 检查WebSSH服务状态..."
if pgrep -f "gossh" > /dev/null; then
    echo "✅ WebSSH服务正在运行"
    echo "   进程ID: $(pgrep -f gossh)"
else
    echo "❌ WebSSH服务未运行"
    echo "   请先启动服务: cd WebSSH/gossh && ./gossh"
    exit 1
fi

# 检查端口
echo ""
echo "2. 检查服务端口..."
if netstat -tuln 2>/dev/null | grep -q ":8899"; then
    echo "✅ 端口8899正在监听"
else
    echo "⚠️  端口8899可能未正确监听"
fi

# 检查前端文件时间戳
echo ""
echo "3. 检查前端文件更新时间..."
if [ -f "WebSSH/gossh/webroot/index.html" ]; then
    file_time=$(stat -f "%Sm" -t "%Y-%m-%d %H:%M:%S" "WebSSH/gossh/webroot/index.html" 2>/dev/null || stat -c "%y" "WebSSH/gossh/webroot/index.html" 2>/dev/null)
    echo "✅ 前端文件最后更新: $file_time"
    
    # 检查是否是最近更新的（最近1小时内）
    if [ -n "$(find WebSSH/gossh/webroot -name "index.html" -mtime -1 2>/dev/null)" ]; then
        echo "✅ 前端文件是最近更新的"
    else
        echo "⚠️  前端文件可能不是最新的，建议重新编译"
    fi
else
    echo "❌ 前端文件不存在，请重新编译"
fi

# 检查API端点
echo ""
echo "4. 测试API端点..."
api_response=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8899/api/ai/providers 2>/dev/null)
if [ "$api_response" = "401" ]; then
    echo "✅ AI API端点正常响应（需要认证）"
elif [ "$api_response" = "000" ]; then
    echo "❌ 无法连接到API端点"
else
    echo "⚠️  API端点响应异常: HTTP $api_response"
fi

# 检查交互式API端点
interactive_response=$(curl -s -o /dev/null -w "%{http_code}" -X POST http://localhost:8899/api/ai/interactive 2>/dev/null)
if [ "$interactive_response" = "401" ]; then
    echo "✅ 交互式AI API端点存在（需要认证）"
elif [ "$interactive_response" = "000" ]; then
    echo "❌ 无法连接到交互式API端点"
else
    echo "✅ 交互式AI API端点响应: HTTP $interactive_response"
fi

# 检查关键文件
echo ""
echo "5. 检查关键实现文件..."
files=(
    "WebSSH/gossh/app/service/ai_interactive.go"
    "WebSSH/webssh/src/views/Home.vue"
    "WebSSH/gossh/main.go"
)

for file in "${files[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file 存在"
    else
        echo "❌ $file 不存在"
    fi
done

# 检查关键函数是否存在
echo ""
echo "6. 检查关键实现..."
if grep -q "ProcessInteractiveMessage" WebSSH/gossh/app/service/ai_interactive.go 2>/dev/null; then
    echo "✅ 后端交互式函数已实现"
else
    echo "❌ 后端交互式函数缺失"
fi

if grep -q "waitingExecutionResult" WebSSH/webssh/src/views/Home.vue 2>/dev/null; then
    echo "✅ 前端交互式状态已实现"
else
    echo "❌ 前端交互式状态缺失"
fi

if grep -q "/api/ai/interactive" WebSSH/gossh/main.go 2>/dev/null; then
    echo "✅ 交互式API路由已注册"
else
    echo "❌ 交互式API路由缺失"
fi

echo ""
echo "=================================="
echo "🔧 解决建议："
echo ""
echo "如果发现问题，请按以下顺序尝试："
echo "1. 重新编译: ./rebuild_ai_interactive.sh"
echo "2. 强制清除浏览器缓存 (Ctrl+Shift+R)"
echo "3. 重启服务: killall gossh && cd WebSSH/gossh && ./gossh"
echo "4. 使用无痕/隐私模式访问"
echo ""
echo "🧪 测试方法："
echo "1. 访问 http://localhost:8899/app"
echo "2. 连接SSH主机"
echo "3. 打开AI助手"
echo "4. 输入需求，观察是否出现'等待执行结果'提示"
echo "5. 观察输入框和按钮文字是否变化"
echo ""
echo "📋 预期行为："
echo "- 发送请求后显示黄色'等待执行结果'提示框"
echo "- 输入框提示变为'请输入命令执行结果...'"
echo "- 发送按钮文字变为'提交结果'"
echo ""
echo "如果问题仍然存在，请开启浏览器开发者工具(F12)查看控制台错误。" 