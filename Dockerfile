# 使用官方的带有Python的Ubuntu镜像
FROM python:3.11-slim

# 设置工作目录
WORKDIR /root/

# 更新包列表并安装必要的系统依赖
RUN apt-get update && apt-get install -y \
    nginx \
    && rm -rf /var/lib/apt/lists/*

# 创建devpi数据目录
RUN mkdir -p /devpi

# 安装devpi相关包
RUN pip install --no-cache-dir \
    devpi-server \
    devpi-web \
    devpi-client\
    devpi-lockdown \
    -i https://pypi.tuna.tsinghua.edu.cn/simple 

# 复制配置文件
COPY ./run.sh /root/run.sh

# 设置脚本执行权限
RUN chmod +x /root/run.sh


# 暴露端口
EXPOSE 3141 80

# 设置启动脚本
ENTRYPOINT ["bash", "/root/run.sh"]
