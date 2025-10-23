FROM kasmweb/ubuntu-noble-dind:1.18.0
USER root

# 设置非交互式安装环境变量
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Shanghai

ENV HOME=/home/kasm-default-profile
ENV STARTUPDIR=/dockerstartup
ENV INST_SCRIPTS=$STARTUPDIR/install
WORKDIR $HOME

######### Customize Container Here ###########

# 配置Ubuntu中科大镜像源
RUN echo "# 默认注释了源码仓库，如有需要可自行取消注释" > /etc/apt/sources.list && \
    echo "deb https://mirrors.ustc.edu.cn/ubuntu/ noble main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "# deb-src https://mirrors.ustc.edu.cn/ubuntu/ noble main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "" >> /etc/apt/sources.list && \
    echo "deb https://mirrors.ustc.edu.cn/ubuntu/ noble-security main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "# deb-src https://mirrors.ustc.edu.cn/ubuntu/ noble-security main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "" >> /etc/apt/sources.list && \
    echo "deb https://mirrors.ustc.edu.cn/ubuntu/ noble-updates main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "# deb-src https://mirrors.ustc.edu.cn/ubuntu/ noble-updates main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "" >> /etc/apt/sources.list && \
    echo "deb https://mirrors.ustc.edu.cn/ubuntu/ noble-backports main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "# deb-src https://mirrors.ustc.edu.cn/ubuntu/ noble-backports main restricted universe multiverse" >> /etc/apt/sources.list

# 配置pip中科大镜像源
RUN mkdir -p /root/.pip && \
    echo "[global]" > /root/.pip/pip.conf && \
    echo "index-url = https://pypi.mirrors.ustc.edu.cn/simple/" >> /root/.pip/pip.conf && \
    echo "trusted-host = pypi.mirrors.ustc.edu.cn" >> /root/.pip/pip.conf

# 设置中文语言和地区
RUN apt-get update && apt-get install -y locales language-pack-zh-hans
RUN locale-gen zh_CN.UTF-8
ENV LANG=zh_CN.UTF-8
ENV LANGUAGE=zh_CN:zh
ENV LC_ALL=zh_CN.UTF-8

# Installing python, pip, and libraries
RUN apt install -y wget build-essential libncursesw5-dev libssl-dev \
libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev libffi-dev zlib1g-dev
RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt install -y python3.11 python3-pip python3-tk python3-dev \
gnome-screenshot wmctrl ffmpeg socat xclip

RUN pip install cua-computer-server --break-system-packages

# 安装中文应用程序
# 下载并安装WPS Office
RUN wget -O /tmp/wps-office.deb https://pubwps-wps365-obs.wpscdn.cn/download/Linux/22550/wps-office_12.1.2.22550.AK.preload.sw_amd64.deb && \
    apt install -y /tmp/wps-office.deb && \
    rm /tmp/wps-office.deb

# # 下载并安装微信
# RUN wget -O /tmp/wechat.deb https://dldir1v6.qq.com/weixin/Universal/Linux/WeChatLinux_x86_64.deb && \
#     apt install -y /tmp/wechat.deb && \
#     rm /tmp/wechat.deb

# 下载并安装QQ
RUN wget -O /tmp/qq.deb https://dldir1v6.qq.com/qqfile/qq/QQNT/Linux/QQ_3.2.19_250904_amd64_01.deb && \
    apt install -y /tmp/qq.deb && \
    rm /tmp/qq.deb

# 创建桌面启动器目录
RUN mkdir -p /home/kasm-user/Desktop

# 创建WPS Office桌面启动器
RUN echo "[Desktop Entry]" > /home/kasm-user/Desktop/wps-office.desktop && \
    echo "Version=1.0" >> /home/kasm-user/Desktop/wps-office.desktop && \
    echo "Type=Application" >> /home/kasm-user/Desktop/wps-office.desktop && \
    echo "Name=WPS Office" >> /home/kasm-user/Desktop/wps-office.desktop && \
    echo "Name[zh_CN]=WPS Office" >> /home/kasm-user/Desktop/wps-office.desktop && \
    echo "Comment=WPS Office Suite" >> /home/kasm-user/Desktop/wps-office.desktop && \
    echo "Comment[zh_CN]=WPS办公套件" >> /home/kasm-user/Desktop/wps-office.desktop && \
    echo "Exec=/usr/bin/wps" >> /home/kasm-user/Desktop/wps-office.desktop && \
    echo "Icon=/usr/share/icons/hicolor/64x64/apps/wps-office2023-kprometheus.png" >> /home/kasm-user/Desktop/wps-office.desktop && \
    echo "Terminal=false" >> /home/kasm-user/Desktop/wps-office.desktop && \
    echo "Categories=Office;" >> /home/kasm-user/Desktop/wps-office.desktop && \
    chmod +x /home/kasm-user/Desktop/wps-office.desktop

# # 创建微信桌面启动器
# RUN echo "[Desktop Entry]" > /home/kasm-user/Desktop/wechat.desktop && \
#     echo "Version=1.0" >> /home/kasm-user/Desktop/wechat.desktop && \
#     echo "Type=Application" >> /home/kasm-user/Desktop/wechat.desktop && \
#     echo "Name=WeChat" >> /home/kasm-user/Desktop/wechat.desktop && \
#     echo "Name[zh_CN]=微信" >> /home/kasm-user/Desktop/wechat.desktop && \
#     echo "Comment=WeChat for Linux" >> /home/kasm-user/Desktop/wechat.desktop && \
#     echo "Comment[zh_CN]=微信Linux版" >> /home/kasm-user/Desktop/wechat.desktop && \
#     echo "Exec=wechat" >> /home/kasm-user/Desktop/wechat.desktop && \
#     echo "Icon=/usr/share/icons/hicolor/256x256/apps/wechat.png" >> /home/kasm-user/Desktop/wechat.desktop && \
#     echo "Terminal=false" >> /home/kasm-user/Desktop/wechat.desktop && \
#     echo "Categories=Network;InstantMessaging;" >> /home/kasm-user/Desktop/wechat.desktop && \
#     chmod +x /home/kasm-user/Desktop/wechat.desktop

# 创建QQ桌面启动器
RUN echo "[Desktop Entry]" > /home/kasm-user/Desktop/qq.desktop && \
    echo "Version=1.0" >> /home/kasm-user/Desktop/qq.desktop && \
    echo "Type=Application" >> /home/kasm-user/Desktop/qq.desktop && \
    echo "Name=QQ" >> /home/kasm-user/Desktop/qq.desktop && \
    echo "Name[zh_CN]=QQ" >> /home/kasm-user/Desktop/qq.desktop && \
    echo "Comment=QQ for Linux" >> /home/kasm-user/Desktop/qq.desktop && \
    echo "Comment[zh_CN]=QQ Linux版" >> /home/kasm-user/Desktop/qq.desktop && \
    echo "Exec=/opt/QQ/qq" >> /home/kasm-user/Desktop/qq.desktop && \
    echo "Icon=/usr/share/icons/hicolor/512x512/apps/qq.png" >> /home/kasm-user/Desktop/qq.desktop && \
    echo "Terminal=false" >> /home/kasm-user/Desktop/qq.desktop && \
    echo "Categories=Network;InstantMessaging;" >> /home/kasm-user/Desktop/qq.desktop && \
    chmod +x /home/kasm-user/Desktop/qq.desktop

# Disable SSL requirement
RUN sed -i 's/require_ssl: true/require_ssl: false/g' /usr/share/kasmvnc/kasmvnc_defaults.yaml
RUN sed -i 's/-sslOnly//g' /dockerstartup/vnc_startup.sh

# Running the python script on startup
RUN echo "/usr/bin/python3 -m computer_server" > $STARTUPDIR/custom_startup.sh \
&& chmod +x $STARTUPDIR/custom_startup.sh

# Enable sudo support for kasm-user
RUN echo "kasm-user:password" | chpasswd
RUN usermod -aG sudo kasm-user
RUN echo "kasm-user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# 设置桌面启动器的正确权限
RUN chown -R kasm-user:kasm-user /home/kasm-user/Desktop

######### End Customizations ###########

RUN chown 1000:0 $HOME
RUN $STARTUPDIR/set_user_permission.sh $HOME
ENV HOME=/home/kasm-user
WORKDIR $HOME
RUN mkdir -p $HOME && chown -R 1000:0 $HOME

USER 1000