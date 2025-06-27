# AI WebSSH 开发计划 - Cursor 开发指南

> 适合非专业程序员在 Cursor 中开发的详细指南

## 🎯 项目目标

在现有 GoWebSSH 基础上，添加 AI 自然语言控制服务器功能：
- 自动检测服务器操作系统
- 用户用自然语言输入指令
- AI 翻译成系统命令
- 智能执行和错误恢复

## 📋 调整后的开发计划

### 阶段1：环境准备与学习（第1周）

#### 1.1 开发环境设置
```bash
# 确保 Go 已安装（已完成）
go version

# 安装必要的工具
go install github.com/air-verse/air@latest  # 热重载工具
```

#### 1.2 Go 语言基础学习
- **必学概念**：结构体、方法、接口、错误处理
- **推荐资源**：Go 官方教程 tour.golang.org
- **实践方式**：在 Cursor 中创建小练习文件

#### 1.3 熟悉现有代码结构
- 阅读 `main.go` 理解路由结构
- 了解 `app/model/` 数据模型
- 学习 `app/service/` 业务逻辑

### 阶段2：AI 数据模型设计（第2周）

#### 2.1 创建 AI 相关数据模型
**步骤**：
1. 在 Cursor 中打开 `WebSSH/gossh/app/model/`
2. 创建新文件 `ai_session.go`
3. 使用 Cursor AI 辅助编写代码

```go
// app/model/ai_session.go
package model

type AISession struct {
    ID             uint     `gorm:"primaryKey" json:"id"`
    SessionID      string   `gorm:"unique;not null" json:"session_id"`
    UserID         uint     `gorm:"not null" json:"user_id"`
    OSType         string   `json:"os_type"`         // linux, windows, macos
    OSVersion      string   `json:"os_version"`      // Ubuntu 22.04, CentOS 8
    OSDistribution string   `json:"os_distribution"` // ubuntu, centos, debian
    PackageManager string   `json:"package_manager"` // apt, yum, brew
    Context        string   `gorm:"type:text" json:"context"`
    CreatedAt      DateTime `gorm:"column:created_at" json:"-"`
    UpdatedAt      DateTime `gorm:"column:updated_at" json:"-"`
}

// 基础 CRUD 方法 - 可以参考其他模型文件
func (s *AISession) Create(session *AISession) error {
    return Db.Create(session).Error
}

func (s *AISession) FindBySessionID(sessionID string) (AISession, error) {
    var session AISession
    err := Db.First(&session, "session_id = ?", sessionID).Error
    return session, err
}
```

#### 2.2 创建 AI 命令模型
创建 `ai_command.go`：

```go
package model

type AICommand struct {
    ID         uint     `gorm:"primaryKey" json:"id"`
    SessionID  string   `gorm:"not null" json:"session_id"`
    UserPrompt string   `gorm:"type:text" json:"user_prompt"`
    Commands   string   `gorm:"type:text" json:"commands"` // JSON 格式存储
    Status     string   `json:"status"` // pending, executing, completed, failed
    ErrorLog   string   `gorm:"type:text" json:"error_log"`
    Solution   string   `gorm:"type:text" json:"solution"`
    CreatedAt  DateTime `gorm:"column:created_at" json:"-"`
}

// CRUD 方法
func (c *AICommand) Create(command *AICommand) error {
    return Db.Create(command).Error
}

func (c *AICommand) FindBySessionID(sessionID string) ([]AICommand, error) {
    var commands []AICommand
    err := Db.Where("session_id = ?", sessionID).Order("created_at desc").Find(&commands).Error
    return commands, err
}
```

### 阶段3：系统检测功能（第3周）

#### 3.1 创建操作系统检测服务
在 `app/service/` 创建 `os_detector.go`：

```go
package service

import (
    "encoding/json"
    "fmt"
    "gossh/app/model"
    "gossh/crypto/ssh"
    "strings"
)

type OSInfo struct {
    Type           string `json:"type"`
    Version        string `json:"version"`
    Distribution   string `json:"distribution"`
    Architecture   string `json:"architecture"`
    PackageManager string `json:"package_manager"`
    ShellType      string `json:"shell_type"`
}

// 主要检测函数
func DetectOSInfo(sshConn *SshConn) (*OSInfo, error) {
    osInfo := &OSInfo{}
    
    // 检测操作系统类型
    osType, err := executeSSHCommand(sshConn, "uname -s")
    if err != nil {
        return nil, err
    }
    
    osInfo.Type = strings.ToLower(strings.TrimSpace(osType))
    
    // 根据系统类型进行详细检测
    switch osInfo.Type {
    case "linux":
        return detectLinuxInfo(sshConn, osInfo)
    case "darwin":
        return detectMacOSInfo(sshConn, osInfo)
    default:
        return osInfo, nil
    }
}

// Linux 系统详细检测
func detectLinuxInfo(sshConn *SshConn, osInfo *OSInfo) (*OSInfo, error) {
    // 检测发行版
    if distro, err := executeSSHCommand(sshConn, "cat /etc/os-release | grep '^ID=' | cut -d'=' -f2 | tr -d '\"'"); err == nil {
        osInfo.Distribution = strings.TrimSpace(distro)
    }
    
    // 检测版本
    if version, err := executeSSHCommand(sshConn, "cat /etc/os-release | grep '^VERSION=' | cut -d'=' -f2 | tr -d '\"'"); err == nil {
        osInfo.Version = strings.TrimSpace(version)
    }
    
    // 检测包管理器
    osInfo.PackageManager = detectPackageManager(sshConn)
    
    // 检测架构
    if arch, err := executeSSHCommand(sshConn, "uname -m"); err == nil {
        osInfo.Architecture = strings.TrimSpace(arch)
    }
    
    return osInfo, nil
}

// 辅助函数：检测包管理器
func detectPackageManager(sshConn *SshConn) string {
    managers := []string{"apt-get", "yum", "dnf", "pacman", "zypper"}
    
    for _, manager := range managers {
        if _, err := executeSSHCommand(sshConn, fmt.Sprintf("which %s", manager)); err == nil {
            if manager == "apt-get" {
                return "apt"
            }
            return manager
        }
    }
    return "unknown"
}

// SSH 命令执行辅助函数
func executeSSHCommand(sshConn *SshConn, command string) (string, error) {
    session, err := sshConn.sshClient.NewSession()
    if err != nil {
        return "", err
    }
    defer session.Close()
    
    output, err := session.CombinedOutput(command)
    return string(output), err
}
```

### 阶段4：AI 服务集成（第4-5周）

#### 4.1 配置 AI 服务
首先在配置文件中添加 AI 设置。修改 `app/config/config.go`：

```go
// 在 AppConfig 结构体中添加
type AppConfig struct {
    // ... 现有字段
    
    // AI 配置
    AIProvider    string `json:"ai_provider" toml:"ai_provider"`
    AIAPIKey      string `json:"ai_api_key" toml:"ai_api_key"`
    AIModel       string `json:"ai_model" toml:"ai_model"`
    AIMaxTokens   int    `json:"ai_max_tokens" toml:"ai_max_tokens"`
    AITemperature float64 `json:"ai_temperature" toml:"ai_temperature"`
}

// 在 DefaultConfig 中添加默认值
var DefaultConfig = AppConfig{
    // ... 现有字段
    
    // AI 默认配置
    AIProvider:    "openai",
    AIAPIKey:      "",
    AIModel:       "gpt-3.5-turbo",
    AIMaxTokens:   2000,
    AITemperature: 0.7,
}
```

#### 4.2 创建 AI 服务
创建 `app/service/ai_service.go`：

```go
package service

import (
    "bytes"
    "encoding/json"
    "fmt"
    "gossh/app/config"
    "net/http"
    "time"
)

type AIService struct {
    apiKey      string
    model       string
    maxTokens   int
    temperature float64
}

type Command struct {
    Cmd         string `json:"cmd"`
    Description string `json:"description"`
    Critical    bool   `json:"critical"`
}

type AIResponse struct {
    Commands []Command `json:"commands"`
}

// 创建 AI 服务实例
func NewAIService() *AIService {
    return &AIService{
        apiKey:      config.DefaultConfig.AIAPIKey,
        model:       config.DefaultConfig.AIModel,
        maxTokens:   config.DefaultConfig.AIMaxTokens,
        temperature: config.DefaultConfig.AITemperature,
    }
}

// 将自然语言转换为命令
func (ai *AIService) TranslateToCommands(prompt string, osInfo *OSInfo) ([]Command, error) {
    systemPrompt := ai.buildSystemPrompt(osInfo)
    userPrompt := ai.buildUserPrompt(prompt)
    
    response, err := ai.callOpenAI(systemPrompt, userPrompt)
    if err != nil {
        return nil, err
    }
    
    var aiResponse AIResponse
    if err := json.Unmarshal([]byte(response), &aiResponse); err != nil {
        return nil, err
    }
    
    return aiResponse.Commands, nil
}

// 构建系统提示词
func (ai *AIService) buildSystemPrompt(osInfo *OSInfo) string {
    return fmt.Sprintf(`你是一个服务器管理助手。
系统信息：
- 操作系统：%s %s
- 发行版：%s
- 包管理器：%s
- 架构：%s

请将用户的自然语言请求转换为shell命令。

规则：
1. 返回JSON格式，包含commands数组
2. 每个命令包含cmd、description、critical字段
3. critical表示是否是危险操作（删除文件、重启等）
4. 命令应该适合当前操作系统
5. 优先使用安全的命令

示例响应：
{
  "commands": [
    {"cmd": "ls -la", "description": "列出当前目录文件", "critical": false},
    {"cmd": "sudo reboot", "description": "重启系统", "critical": true}
  ]
}`,
        osInfo.Type, osInfo.Version, osInfo.Distribution, 
        osInfo.PackageManager, osInfo.Architecture)
}

// 构建用户提示词
func (ai *AIService) buildUserPrompt(prompt string) string {
    return fmt.Sprintf("用户请求：%s\n\n请提供相应的shell命令。", prompt)
}

// 调用 OpenAI API（简化版本）
func (ai *AIService) callOpenAI(systemPrompt, userPrompt string) (string, error) {
    // 这里是简化的 OpenAI API 调用
    // 实际使用时需要完整的 API 实现
    
    requestBody := map[string]interface{}{
        "model": ai.model,
        "messages": []map[string]string{
            {"role": "system", "content": systemPrompt},
            {"role": "user", "content": userPrompt},
        },
        "max_tokens":  ai.maxTokens,
        "temperature": ai.temperature,
    }
    
    jsonData, _ := json.Marshal(requestBody)
    
    req, err := http.NewRequest("POST", "https://api.openai.com/v1/chat/completions", bytes.NewBuffer(jsonData))
    if err != nil {
        return "", err
    }
    
    req.Header.Set("Content-Type", "application/json")
    req.Header.Set("Authorization", "Bearer "+ai.apiKey)
    
    client := &http.Client{Timeout: 30 * time.Second}
    resp, err := client.Do(req)
    if err != nil {
        return "", err
    }
    defer resp.Body.Close()
    
    var result map[string]interface{}
    json.NewDecoder(resp.Body).Decode(&result)
    
    if choices, ok := result["choices"].([]interface{}); ok && len(choices) > 0 {
        if choice, ok := choices[0].(map[string]interface{}); ok {
            if message, ok := choice["message"].(map[string]interface{}); ok {
                if content, ok := message["content"].(string); ok {
                    return content, nil
                }
            }
        }
    }
    
    return "", fmt.Errorf("unexpected API response format")
}
```

### Cursor 开发技巧

#### 使用 Cursor 的最佳实践：

1. **代码生成**：选中代码后按 `Ctrl+K`，描述你想要的功能
2. **代码解释**：选中代码后按 `Ctrl+L`，询问代码功能
3. **错误修复**：当遇到错误时，直接将错误信息发送给 Cursor AI
4. **代码补全**：使用 Tab 键接受 AI 建议
5. **重构代码**：选中代码后要求 AI 重构或优化

#### 学习建议：

1. **边做边学**：遇到不懂的 Go 语法就问 Cursor AI
2. **参考现有代码**：多看 `app/model/` 和 `app/service/` 中的现有文件
3. **小步测试**：每写一个函数就测试一下
4. **使用日志**：添加 `fmt.Println()` 或 `slog.Info()` 来调试

### 下一步计划

完成上述阶段后，我们将继续：

1. **第6周**：前端 Vue 组件开发（AI 聊天界面）
2. **第7周**：WebSocket 实时通信
3. **第8周**：命令执行和错误恢复
4. **第9周**：安全验证和测试
5. **第10周**：文档和部署优化

### 需要的准备工作

1. 获取 OpenAI API Key（或其他 AI 服务）
2. 准备测试用的 Linux 服务器
3. 熟悉 Cursor 的基本操作

这个计划更适合在 Cursor 中开发，每个步骤都有详细的代码示例，可以直接复制粘贴并根据需要修改。 