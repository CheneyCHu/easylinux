#!/bin/bash

# AI WebSSH 开发启动脚本
# 替代 air 工具的简单热重载方案

echo "🚀 启动 AI WebSSH 开发环境..."

# 检查是否在正确的目录
if [ ! -f "WebSSH/gossh/main.go" ]; then
    echo "❌ 错误：请在项目根目录运行此脚本"
    exit 1
fi

# 进入后端目录
cd WebSSH/gossh

echo "📦 检查 Go 模块..."
go mod tidy

echo "🔨 编译项目..."
go build -o gossh main.go

if [ $? -eq 0 ]; then
    echo "✅ 编译成功！"
    echo "🌐 启动服务器..."
    ./gossh
else
    echo "❌ 编译失败，请检查代码"
    exit 1
fi 