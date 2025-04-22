FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# 安装构建工具 + sudo
RUN apt-get update && apt-get install -y \
    sudo build-essential cmake ninja-build \
    gcc-10 g++-10 \
    libncurses5-dev bison libssl-dev libaio-dev \
    git wget pkg-config software-properties-common \
    && add-apt-repository ppa:ubuntu-toolchain-r/test -y \
    && apt-get update \
    && update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-10 100 \
    && update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-10 100

# 添加 mysql 用户，并设置可登录 shell
RUN useradd -ms /bin/bash mysql \
    && usermod -aG sudo mysql \
    && echo "mysql ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# 设置工作目录并复制源码
WORKDIR /mysql
COPY . .

# 修改权限以确保 mysql 用户可操作源码目录
RUN mkdir -p /mysql/build /usr/local/mysql \
    && chown -R mysql:mysql /mysql /usr/local/mysql

# 切换到 mysql 用户（现在它拥有 sudo 权限）
USER mysql
WORKDIR /mysql/build

# 默认进入 bash，手动 cmake / ninja
CMD ["/bin/bash"]

