#!/bin/bash

# 启动脚本 - 用于Docker容器启动devpi服务

echo "=== DevPI 服务启动脚本 ==="
echo "启动时间: $(date)"

# 创建日志目录
mkdir -p /log

# 初始化devpi
echo "初始化DevPI..."
devpi-init --serverdir /devpi

# 生成devpi配置
echo "生成devpi配置..."
devpi-gen-config --serverdir /devpi --host 0.0.0.0 --port 3141

# 复制nginx配置
cp /root/gen-config/nginx-devpi.conf /etc/nginx/sites-available/default

# 启动devpi服务器（后台运行）
echo "启动DevPI服务..."
nohup devpi-server --serverdir /devpi --host 0.0.0.0 --port 3141 > /log/devpi-server.log 2>&1 &

# 等待devpi服务启动
echo "等待DevPI服务启动..."
sleep 5

# 配置devpi索引
echo "配置DevPI索引..."
devpi use http://localhost:3141


devpi login root --password ''

# 创建清华源索引
echo "创建清华源索引..."
devpi index -c tsinghua type=mirror bases=root/pypi mirror_url=https://pypi.tuna.tsinghua.edu.cn/simple/

# 创建阿里云源索引（备用）
echo "创建阿里云源索引..."
devpi index -c aliyun type=mirror bases=root/pypi mirror_url=https://mirrors.aliyun.com/pypi/simple/

# 创建豆瓣源索引（备用）
echo "创建豆瓣源索引..."
devpi index -c douban type=mirror bases=root/pypi mirror_url=https://pypi.douban.com/simple/

# 设置默认索引为清华源
devpi use root/tsinghua

echo "索引配置完成！"

# 启动nginx（前台运行，保持容器运行）
echo "启动Nginx..."
nohup nginx -g "daemon off;" > /log/nginx.log 2>&1 &

# 保持容器运行
echo "所有服务已启动，容器保持运行..."
tail -f /log/devpi-server.log