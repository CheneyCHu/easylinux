#!/bin/bash

# AI助手交互式功能重新编译脚本
echo "🤖 开始编译交互式AI助手功能..."

# 进入项目目录
cd WebSSH

echo "📦 步骤1: 编译前端..."
cd webssh

# 安装依赖（如果需要）
if [ ! -d "node_modules" ]; then
    echo "安装前端依赖..."
    npm install
fi

# 构建前端
echo "构建前端项目..."
npm run build

if [ $? -ne 0 ]; then
    echo "❌ 前端构建失败"
    exit 1
fi

echo "✅ 前端构建成功"

# 复制前端文件到后端
echo "📋 步骤2: 复制前端文件到后端..."
cd ..
cp -r webssh/dist/* gossh/webroot/

echo "✅ 前端文件复制完成"

# 编译后端
echo "🔧 步骤3: 编译后端..."
cd gossh

# 编译Go程序
echo "编译Go后端程序..."
go build -o gossh main.go

if [ $? -ne 0 ]; then
    echo "❌ 后端编译失败"
    exit 1
fi

echo "✅ 后端编译成功"

echo ""
echo "🎉 交互式AI助手编译完成！"
echo ""
echo "新功能说明："
echo "1. 🤖 AI助手现在支持交互式对话"
echo "2. 💬 用户提出需求 → AI生成命令 → 等待执行结果 → 根据结果继续对话"
echo "3. ✅ 执行成功时会总结结果并结束会话"
echo "4. ❌ 执行失败时会分析原因并提供解决建议"
echo "5. 🔄 支持多轮对话直到问题解决"
echo ""
echo "启动服务："
echo "cd WebSSH/gossh && ./gossh"
echo ""
echo "API端点："
echo "POST /api/ai/interactive - 交互式AI对话"
echo "GET /api/ai/session/status/:sessionId - 获取会话状态"
echo "" 