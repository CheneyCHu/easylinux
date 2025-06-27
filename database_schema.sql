-- EasyLinux 数据库表结构
-- 基于 GORM 模型生成的表结构
-- 支持 MySQL, PostgreSQL, SQLite

-- =====================================
-- 用户管理表 (ssh_users)
-- =====================================
CREATE TABLE `ssh_users` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `name` varchar(64) NOT NULL COMMENT '用户名',
  `pwd` varchar(64) DEFAULT NULL COMMENT '密码(AES加密)',
  `desc_info` varchar(64) DEFAULT NULL COMMENT '用户描述',
  `is_admin` varchar(64) NOT NULL DEFAULT 'N' COMMENT '是否管理员(Y/N)',
  `is_enable` varchar(64) NOT NULL DEFAULT 'Y' COMMENT '是否启用(Y/N)',
  `is_root` varchar(64) NOT NULL DEFAULT 'N' COMMENT '是否超级管理员(Y/N)', 
  `expiry_at` datetime NOT NULL COMMENT '账号过期时间',
  `created_at` datetime DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_ssh_users_name` (`name`)
) ENGINE=InnoDB DEFAULT CharSET=utf8mb4 COMMENT='用户管理表';

-- =====================================
-- SSH连接配置表 (ssh_confs)
-- =====================================
CREATE TABLE `ssh_confs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '配置ID',
  `uid` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '用户ID',
  `name` varchar(64) NOT NULL COMMENT '连接名称',
  `address` varchar(128) DEFAULT NULL COMMENT '服务器地址',
  `user` varchar(128) DEFAULT NULL COMMENT 'SSH用户名',
  `pwd` varchar(4096) NOT NULL DEFAULT '' COMMENT 'SSH密码(AES加密)',
  `auth_type` varchar(32) NOT NULL DEFAULT 'pwd' COMMENT '认证类型(pwd/cert)',
  `net_type` varchar(32) NOT NULL DEFAULT 'tcp4' COMMENT '网络类型(tcp4/tcp6)',
  `cert_data` text COMMENT '证书数据(AES加密)',
  `cert_pwd` varchar(128) NOT NULL DEFAULT '' COMMENT '证书密码(AES加密)',
  `port` smallint(5) unsigned NOT NULL DEFAULT '22' COMMENT 'SSH端口',
  `font_size` smallint(5) unsigned NOT NULL DEFAULT '14' COMMENT '终端字体大小',
  `background` varchar(128) NOT NULL DEFAULT '#000000' COMMENT '终端背景色',
  `foreground` varchar(128) NOT NULL DEFAULT '#FFFFFF' COMMENT '终端前景色',
  `cursor_color` varchar(128) NOT NULL DEFAULT '#FFFFFF' COMMENT '光标颜色',
  `font_family` varchar(128) NOT NULL DEFAULT 'Courier' COMMENT '字体家族',
  `cursor_style` varchar(128) NOT NULL DEFAULT 'block' COMMENT '光标样式',
  `shell` varchar(64) NOT NULL DEFAULT 'sh' COMMENT '默认Shell',
  `pty_type` varchar(64) NOT NULL DEFAULT 'xterm-256color' COMMENT 'PTY类型',
  `init_cmd` text COMMENT '初始化命令',
  `init_banner` text COMMENT '初始化横幅',
  `created_at` datetime DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_ssh_confs_uid` (`uid`)
) ENGINE=InnoDB DEFAULT CharSET=utf8mb4 COMMENT='SSH连接配置表';

-- =====================================
-- AI对话会话表 (ai_sessions)
-- =====================================
CREATE TABLE `ai_sessions` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '会话ID',
  `user_id` bigint(20) unsigned NOT NULL COMMENT '用户ID',
  `session_id` varchar(128) NOT NULL COMMENT '会话标识',
  `title` varchar(255) DEFAULT NULL COMMENT '会话标题',
  `provider` varchar(64) NOT NULL COMMENT 'AI提供商',
  `model` varchar(128) NOT NULL COMMENT 'AI模型',
  `system_prompt` text COMMENT '系统提示词',
  `context` longtext COMMENT '对话上下文(JSON)',
  `message_count` int(11) NOT NULL DEFAULT '0' COMMENT '消息数量',
  `total_tokens` int(11) NOT NULL DEFAULT '0' COMMENT '总Token数',
  `status` varchar(32) NOT NULL DEFAULT 'active' COMMENT '会话状态',
  `expires_at` datetime DEFAULT NULL COMMENT '过期时间',
  `created_at` datetime DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_ai_sessions_session_id` (`session_id`),
  KEY `idx_ai_sessions_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CharSET=utf8mb4 COMMENT='AI对话会话表';

-- =====================================
-- AI命令记录表 (ai_commands)
-- =====================================
CREATE TABLE `ai_commands` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '记录ID',
  `user_id` bigint(20) unsigned NOT NULL COMMENT '用户ID',
  `session_id` varchar(128) DEFAULT NULL COMMENT '会话ID',
  `query` text NOT NULL COMMENT '用户查询',
  `command` text DEFAULT NULL COMMENT '生成的命令',
  `explanation` text DEFAULT NULL COMMENT '命令解释',
  `provider` varchar(64) NOT NULL COMMENT 'AI提供商',
  `model` varchar(128) NOT NULL COMMENT 'AI模型',
  `tokens_used` int(11) NOT NULL DEFAULT '0' COMMENT '使用的Token数',
  `response_time` int(11) NOT NULL DEFAULT '0' COMMENT '响应时间(毫秒)',
  `status` varchar(32) NOT NULL DEFAULT 'success' COMMENT '执行状态',
  `error_message` text COMMENT '错误信息',
  `executed` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否已执行',
  `execution_result` text COMMENT '执行结果',
  `created_at` datetime DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_ai_commands_user_id` (`user_id`),
  KEY `idx_ai_commands_session_id` (`session_id`),
  KEY `idx_ai_commands_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CharSET=utf8mb4 COMMENT='AI命令记录表';

-- =====================================
-- 命令收藏表 (cmd_notes)
-- =====================================
CREATE TABLE `cmd_notes` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '收藏ID',
  `uid` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '用户ID',
  `title` varchar(255) NOT NULL COMMENT '命令标题',
  `note` text NOT NULL COMMENT '命令内容',
  `created_at` datetime DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_cmd_notes_uid` (`uid`)
) ENGINE=InnoDB DEFAULT CharSET=utf8mb4 COMMENT='命令收藏表';

-- =====================================
-- 登录审计表 (login_audits)
-- =====================================
CREATE TABLE `login_audits` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '审计ID',
  `uid` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT '用户ID',
  `username` varchar(128) NOT NULL COMMENT '用户名',
  `client_ip` varchar(128) NOT NULL COMMENT '客户端IP',
  `user_agent` text COMMENT '用户代理',
  `login_time` datetime NOT NULL COMMENT '登录时间',
  `status` varchar(32) NOT NULL COMMENT '登录状态',
  `created_at` datetime DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_login_audits_uid` (`uid`),
  KEY `idx_login_audits_login_time` (`login_time`)
) ENGINE=InnoDB DEFAULT CharSET=utf8mb4 COMMENT='登录审计表';

-- =====================================
-- 网络过滤表 (net_filters)
-- =====================================
CREATE TABLE `net_filters` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '过滤器ID',
  `name` varchar(128) NOT NULL COMMENT '规则名称',
  `ip_range` varchar(128) NOT NULL COMMENT 'IP范围',
  `action` varchar(32) NOT NULL COMMENT '动作(allow/deny)',
  `description` text COMMENT '规则描述',
  `is_enable` varchar(8) NOT NULL DEFAULT 'Y' COMMENT '是否启用(Y/N)',
  `created_at` datetime DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CharSET=utf8mb4 COMMENT='网络过滤表';

-- =====================================
-- 策略配置表 (policy_confs)
-- =====================================
CREATE TABLE `policy_confs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT '策略ID',
  `name` varchar(128) NOT NULL COMMENT '策略名称',
  `config` text NOT NULL COMMENT '策略配置(JSON)',
  `is_enable` varchar(8) NOT NULL DEFAULT 'Y' COMMENT '是否启用(Y/N)',
  `created_at` datetime DEFAULT NULL COMMENT '创建时间',
  `updated_at` datetime DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CharSET=utf8mb4 COMMENT='策略配置表';

-- =====================================
-- 初始化数据
-- =====================================

-- 创建默认管理员用户 (密码: admin123, 已AES加密，请在实际部署时修改)
INSERT INTO `ssh_users` (`name`, `pwd`, `desc_info`, `is_admin`, `is_enable`, `is_root`, `expiry_at`, `created_at`, `updated_at`) 
VALUES ('admin', 'encrypted_password_here', '系统管理员', 'Y', 'Y', 'Y', '2030-12-31 23:59:59', NOW(), NOW());

-- 创建默认网络过滤规则
INSERT INTO `net_filters` (`name`, `ip_range`, `action`, `description`, `is_enable`, `created_at`, `updated_at`) 
VALUES ('允许本地访问', '127.0.0.1/32', 'allow', '允许本地回环地址访问', 'Y', NOW(), NOW());

INSERT INTO `net_filters` (`name`, `ip_range`, `action`, `description`, `is_enable`, `created_at`, `updated_at`) 
VALUES ('允许内网访问', '192.168.0.0/16', 'allow', '允许内网地址访问', 'Y', NOW(), NOW());

-- =====================================
-- 索引优化建议
-- =====================================

-- 为经常查询的字段添加索引
CREATE INDEX `idx_ssh_confs_name` ON `ssh_confs` (`name`);
CREATE INDEX `idx_ai_commands_provider` ON `ai_commands` (`provider`);
CREATE INDEX `idx_ai_sessions_status` ON `ai_sessions` (`status`);
CREATE INDEX `idx_login_audits_client_ip` ON `login_audits` (`client_ip`);

-- =====================================
-- 视图定义（可选）
-- =====================================

-- 用户连接统计视图
CREATE VIEW `user_connection_stats` AS
SELECT 
    u.id,
    u.name,
    COUNT(c.id) as connection_count,
    MAX(c.updated_at) as last_connection_time
FROM ssh_users u
LEFT JOIN ssh_confs c ON u.id = c.uid
WHERE u.is_enable = 'Y'
GROUP BY u.id, u.name;

-- AI使用统计视图  
CREATE VIEW `ai_usage_stats` AS
SELECT 
    user_id,
    provider,
    COUNT(*) as command_count,
    SUM(tokens_used) as total_tokens,
    AVG(response_time) as avg_response_time,
    DATE(created_at) as usage_date
FROM ai_commands
GROUP BY user_id, provider, DATE(created_at);

-- =====================================
-- 数据库配置建议
-- =====================================

-- MySQL 配置建议:
-- innodb_buffer_pool_size = 1G  # 根据内存调整
-- max_connections = 200
-- innodb_log_file_size = 256M
-- character_set_server = utf8mb4
-- collation_server = utf8mb4_unicode_ci

-- PostgreSQL 配置建议:
-- shared_buffers = 256MB  # 根据内存调整
-- max_connections = 200
-- work_mem = 4MB
-- maintenance_work_mem = 64MB 