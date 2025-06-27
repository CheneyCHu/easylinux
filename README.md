# EasyLinux - 基于自然语言的Linux服务器管理平台

EasyLinux是一个基于WebSSH和AI技术的现代化Linux服务器管理平台，支持通过自然语言对Linux服务器进行操作和管理。

## 🚀 核心特性

### 🌐 Web终端
- 基于WebSocket的实时SSH连接
- 支持多标签页同时管理多个服务器
- 现代化的Web终端界面（基于Xterm.js）
- 支持终端大小自适应

### 🤖 AI智能助手
- **多AI提供商支持**：OpenAI、Claude、Gemini、千问、ChatGLM、DeepSeek等
- **自然语言命令**：用中文描述需求，AI自动生成Linux命令
- **智能对话**：与AI助手进行技术交流和问题解答
- **命令解释**：AI解释复杂命令的作用和参数

### 📁 文件管理
- SFTP文件传输功能
- 文件上传下载
- 目录浏览和文件管理
- 支持批量操作

### 👥 用户管理
- 多用户权限管理
- 用户组和角色控制
- 登录审计和操作日志
- 安全访问控制

### 🔒 安全特性
- JWT身份认证
- 敏感数据AES加密存储
- IP访问控制
- 完整的审计日志

## 🏗️ 技术架构

### 后端技术栈
- **Golang 1.22+** - 主要开发语言
- **Gin** - Web框架
- **GORM** - ORM数据库操作
- **WebSocket** - 实时通信
- **SSH/SFTP** - 远程连接协议
- **JWT** - 身份认证
- **AES** - 数据加密

### 前端技术栈
- **Vue 3.4** - 前端框架
- **TypeScript** - 类型安全
- **Vite 5** - 构建工具
- **Element Plus** - UI组件库
- **Xterm.js** - 终端模拟器
- **Pinia** - 状态管理

### 数据库支持
- MySQL 8+
- PostgreSQL 12.2+
- SQLite

## 📊 数据库表结构

### 核心表
- `ssh_confs` - SSH连接配置
- `ssh_users` - 用户管理
- `ai_sessions` - AI对话会话
- `ai_commands` - AI命令记录
- `cmd_notes` - 命令收藏
- `login_audits` - 登录审计
- `net_filters` - 网络过滤规则
- `policy_confs` - 策略配置

## 🚀 快速开始

### 环境要求
- Golang 1.22+
- Node.js 20+
- MySQL 8+ 或 PostgreSQL 12.2+

### 安装步骤

1. **克隆项目**
```bash
git clone https://github.com/CheneyCHu/easylinux.git
cd easylinux/WebSSH
```

2. **后端启动**
```bash
cd gossh
go build -o easylinux main.go
./easylinux
```

3. **前端开发**
```bash
cd webssh
npm install
npm run build
cp -r dist/* ../gossh/webroot/
```

4. **访问应用**
- 默认端口：http://localhost:8899
- 首次访问会进入系统初始化流程

### Docker部署

```bash
docker build -t easylinux:latest .
docker run -d --name easylinux -p 8899:8899 -v easylinux-data:/var/lib/easylinux easylinux:latest
```

## 📖 使用指南

### 基本操作
1. **添加SSH服务器**：在连接管理页面添加服务器信息
2. **连接服务器**：点击连接按钮建立SSH会话
3. **AI助手**：使用AI助手功能进行智能对话
4. **文件管理**：通过SFTP进行文件传输

### AI助手功能
- **自然语言命令**：输入"查看系统内存使用情况"，AI会生成对应的Linux命令
- **命令解释**：粘贴复杂命令，AI会详细解释其作用
- **技术咨询**：向AI询问Linux相关的技术问题

### 配置文件
- 配置文件位置：`~/.EasyLinux/EasyLinux.toml`
- 支持数据库连接、AI API配置、端口设置等

## 🛠️ 开发指南

### 前端开发
```bash
cd webssh
npm run dev  # 开发模式
npm run build  # 构建生产版本
```

### 后端开发
```bash
cd gossh
go run main.go  # 开发模式
go build -o easylinux main.go  # 构建生产版本
```

### 重要提醒
- 修改前端代码后，需要重新构建并复制到 `webroot` 目录
- 更新嵌入的静态文件需要重新编译Go程序

## 📁 项目结构

```
easylinux/
├── WebSSH/
│   ├── gossh/           # Go后端项目
│   │   ├── main.go      # 主程序入口
│   │   ├── app/         # 应用核心代码
│   │   │   ├── config/  # 配置管理
│   │   │   ├── model/   # 数据模型
│   │   │   ├── service/ # 业务逻辑
│   │   │   └── middleware/ # 中间件
│   │   └── webroot/     # 前端构建产物
│   ├── webssh/          # Vue前端项目
│   │   ├── src/         # 源代码
│   │   │   ├── components/ # Vue组件
│   │   │   ├── views/      # 页面视图
│   │   │   └── stores/     # 状态管理
│   │   └── dist/        # 构建输出
│   └── docs/            # 项目文档
├── docs/                # 开发文档
└── scripts/             # 构建脚本
```

## 🤝 贡献指南

1. Fork 本项目
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 打开Pull Request

## 📄 许可证

本项目基于 MIT 许可证开源。详见 [LICENSE](LICENSE) 文件。

## 🙏 致谢

- [Gin](https://github.com/gin-gonic/gin) - Go Web框架
- [Vue.js](https://vuejs.org/) - 前端框架
- [Element Plus](https://element-plus.org/) - Vue组件库
- [Xterm.js](https://xtermjs.org/) - Web终端模拟器
- [GORM](https://gorm.io/) - Go ORM库

## 📧 联系方式

- 项目地址：https://github.com/CheneyCHu/easylinux
- 问题反馈：https://github.com/CheneyCHu/easylinux/issues

---

**EasyLinux** - 让Linux服务器管理变得简单自然 🐧✨ 