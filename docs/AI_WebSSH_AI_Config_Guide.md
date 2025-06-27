# AI WebSSH 大语言模型配置指南

## 🎯 功能概述

你的 GoWebSSH 项目现在已经支持多种大语言模型提供商，可以手动配置不同的AI API来进行自然语言到系统命令的翻译。

## 🔧 当前支持的AI提供商

### 1. OpenAI GPT
- **提供商代码**: `openai`
- **支持模型**: GPT-4, GPT-4-turbo, GPT-3.5-turbo, GPT-3.5-turbo-16k
- **API Key获取**: https://platform.openai.com/api-keys
- **特点**: 最成熟的商业AI模型，英文支持优秀

### 2. Anthropic Claude
- **提供商代码**: `claude`
- **支持模型**: Claude-3-opus, Claude-3-sonnet, Claude-3-haiku
- **API Key获取**: https://console.anthropic.com/
- **特点**: 擅长长文本处理和安全对话

### 3. Google Gemini
- **提供商代码**: `gemini`
- **支持模型**: Gemini-1.5-pro, Gemini-1.5-flash, Gemini-pro
- **API Key获取**: https://makersuite.google.com/app/apikey
- **特点**: 支持多模态输入，Google出品

### 4. 阿里千问
- **提供商代码**: `qianwen`
- **支持模型**: qwen-turbo, qwen-plus, qwen-max, qwen-max-longcontext
- **API Key获取**: https://dashscope.console.aliyun.com/
- **特点**: 中文支持优秀，阿里云出品

### 5. 智谱ChatGLM
- **提供商代码**: `chatglm`
- **支持模型**: glm-4, glm-4v, glm-3-turbo
- **API Key获取**: https://open.bigmodel.cn/
- **特点**: 中文大模型，智谱AI出品

### 6. DeepSeek
- **提供商代码**: `deepseek`
- **支持模型**: deepseek-chat, deepseek-coder
- **API Key获取**: https://platform.deepseek.com/api_keys
- **特点**: 高性价比，代码能力强，支持中英文

### 7. 自定义API
- **提供商代码**: `custom`
- **支持格式**: OpenAI兼容API
- **特点**: 支持本地部署的模型或其他兼容API

## 📋 配置方法

### 方法1：通过前端界面配置（推荐）

1. 启动 GoWebSSH 服务
2. 登录系统后，访问AI配置页面
3. 选择AI提供商
4. 输入API Key
5. 选择或输入模型名称
6. 调整参数（可选）
7. 点击"测试配置"验证
8. 保存配置

### 方法2：通过API配置

#### 获取当前配置
```bash
curl -X GET "http://localhost:8899/api/ai/config" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

#### 更新配置
```bash
curl -X PUT "http://localhost:8899/api/ai/config" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -d '{
    "provider": "openai",
    "api_key": "sk-your-api-key-here",
    "model": "gpt-3.5-turbo",
    "max_tokens": 2000,
    "temperature": 0.7,
    "timeout": 30,
    "base_url": "https://api.openai.com",
    "api_version": "v1"
  }'
```

#### 测试配置
```bash
curl -X POST "http://localhost:8899/api/ai/config/test" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

### 方法3：通过配置文件

配置文件位置：`~/.GoWebSSH/GoWebSSH.toml`

```toml
# AI 配置
ai_provider = "openai"
ai_api_key = "sk-your-api-key-here"
ai_model = "gpt-3.5-turbo"
ai_max_tokens = 2000
ai_temperature = 0.7
ai_timeout = 30
ai_base_url = "https://api.openai.com"
ai_api_version = "v1"
ai_organization = ""
```

## 🎛️ 配置参数说明

| 参数 | 类型 | 说明 | 默认值 |
|------|------|------|--------|
| `provider` | string | AI提供商 | "openai" |
| `api_key` | string | API密钥 | "" |
| `model` | string | 模型名称 | "gpt-3.5-turbo" |
| `max_tokens` | int | 最大Token数 | 2000 |
| `temperature` | float | 温度参数(0-2) | 0.7 |
| `timeout` | int | 超时时间(秒) | 30 |
| `base_url` | string | API基础URL | "https://api.openai.com" |
| `api_version` | string | API版本 | "v1" |
| `organization` | string | 组织ID(OpenAI) | "" |

## 🔍 使用示例

### 配置OpenAI
```json
{
  "provider": "openai",
  "api_key": "sk-your-openai-key",
  "model": "gpt-4",
  "base_url": "https://api.openai.com"
}
```

### 配置Claude
```json
{
  "provider": "claude",
  "api_key": "sk-ant-your-claude-key",
  "model": "claude-3-sonnet-20240229",
  "base_url": "https://api.anthropic.com"
}
```

### 配置千问
```json
{
  "provider": "qianwen",
  "api_key": "sk-your-qianwen-key",
  "model": "qwen-plus",
  "base_url": "https://dashscope.aliyuncs.com"
}
```

### 配置DeepSeek
```json
{
  "provider": "deepseek",
  "api_key": "sk-your-deepseek-key",
  "model": "deepseek-chat",
  "base_url": "https://api.deepseek.com"
}
```

### 配置自定义API（如本地Ollama）
```json
{
  "provider": "custom",
  "api_key": "not-required-for-local",
  "model": "llama2",
  "base_url": "http://localhost:11434",
  "api_version": "v1"
}
```

## 🚀 功能特点

1. **多提供商支持**: 支持7种主流AI提供商
2. **统一接口**: 不同提供商使用相同的调用方式
3. **配置验证**: 自动验证配置参数的有效性
4. **实时测试**: 支持配置后立即测试
5. **安全存储**: API Key安全存储，不在前端显示
6. **热更新**: 配置更新后立即生效，无需重启

## 🛠️ 故障排除

### 常见问题

1. **API Key无效**
   - 检查API Key是否正确
   - 确认API Key有足够的配额
   - 验证API Key的权限

2. **网络连接失败**
   - 检查网络连接
   - 确认防火墙设置
   - 尝试使用代理

3. **模型不存在**
   - 确认模型名称正确
   - 检查API Key是否有该模型的访问权限

4. **超时错误**
   - 增加timeout参数
   - 检查网络延迟

### 调试方法

1. 使用测试接口验证配置
2. 查看服务器日志
3. 使用curl命令直接测试API

## 📝 开发说明

### 新增AI提供商

如需添加新的AI提供商，需要：

1. 在 `ai_providers.go` 中添加提供商配置
2. 实现对应的API调用方法
3. 在 `callAIProvider` 中添加分支
4. 更新前端的提供商列表

### API调用流程

```
用户输入 -> AI服务 -> 提供商API -> 解析响应 -> 返回命令
```

## 🔐 安全注意事项

1. **API Key保护**: 不要在代码中硬编码API Key
2. **权限控制**: 确保只有授权用户能修改AI配置
3. **网络安全**: 使用HTTPS传输敏感信息
4. **日志安全**: 不要在日志中记录API Key

---

现在你的 GoWebSSH 项目已经具备了完整的AI大语言模型配置功能，可以灵活切换不同的AI提供商来满足不同的需求！ 