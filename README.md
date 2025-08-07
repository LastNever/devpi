# DevPI Docker 封装

这是一个完整的DevPI私有PyPI服务器的Docker封装，包含了DevPI服务器、Web界面和Nginx反向代理。

## 功能特性

- 🐍 DevPI私有PyPI服务器
- 🌐 DevPI Web管理界面
- 🚀 Nginx反向代理
- 📦 Docker Compose一键部署

## 快速开始

### 1. 构建并启动服务

```bash
# 启动服务
docker-compose up -d

# 查看日志
docker-compose logs -f

# 停止服务
docker-compose down
```

### 2. 访问服务

- **DevPI服务器**: http://localhost:3141
- **Web界面**: http://localhost:8080
- **健康检查**: http://localhost:8080/health

### 3. 配置客户端

```bash
# 安装devpi客户端
pip install devpi-client

# 配置devpi客户端
devpi use http://localhost:3141

# 登录（默认用户名/密码: root/空）
devpi login root

# 创建索引
devpi index -c myindex

# 使用索引
devpi use root/myindex

# 上传包
devpi upload
```

## 目录结构

```
devpi/
├── Dockerfile              # Docker镜像构建文件
├── docker-compose.yml      # Docker Compose配置
├── run.sh                  # 容器启动脚本
└── README.md              # 说明文档
```

## 配置说明

### 端口配置

- `3141`: DevPI服务器直接访问端口
- `8080`: Nginx反向代理端口（推荐使用）

### 数据持久化

数据存储在`data`文件夹 中，包括：
- 包文件
- 用户配置
- 索引信息


## 高级配置


### 备份和恢复

```bash
# 备份数据
docker-compose exec devpi tar -czf /tmp/devpi-backup.tar.gz /devpi

# 复制备份文件
docker cp devpi-server:/tmp/devpi-backup.tar.gz ./

# 恢复数据
docker cp ./devpi-backup.tar.gz devpi-server:/tmp/
docker-compose exec devpi tar -xzf /tmp/devpi-backup.tar.gz -C /
```

## 故障排除

### 查看日志

```bash
# 查看所有日志
docker-compose logs

# 查看特定服务日志
docker-compose logs devpi

# 实时查看日志
docker-compose logs -f
```

### 重置数据

```bash
# 停止服务
docker-compose down

# 重新启动
docker-compose up -d
```

### 容器内调试

```bash
# 进入容器
docker-compose exec devpi bash

# 检查服务状态
supervisorctl status

# 重启单个服务
supervisorctl restart devpi-server
```
