# Ubuntu Setup Script

自动化Ubuntu系统初始化脚本，用于新机器快速配置开发环境。

## 功能

- ✅ 基础工具安装（git, vim, net-tools, openssh-server等）
- ✅ Git全局配置
- ✅ SSH密钥生成和管理
- ✅ Shell工具安装（zsh, tmux, fzf）
- ✅ FishROS安装（ROS开发环境一键安装）

## 使用方法

1. 克隆仓库：
```bash
git clone https://github.com/Robben-Ge/ubuntu_setup.git
cd ubuntu_setup
```

2. 编辑配置（可选）：
```bash
vim config.env
```

3. 运行安装脚本：
```bash
bash install.sh
```

## 配置说明

编辑 `config.env` 文件可以自定义：
- `GIT_NAME`: Git用户名
- `GIT_EMAIL`: Git邮箱
- `SSH_KEY_TYPE`: SSH密钥类型（默认ed25519）
- `SSH_KEY_PATH`: SSH密钥路径
- `DOCKER_PROXY_HOST` / `DOCKER_PROXY_PORT`: 可选，让 Docker 守护进程经 HTTP/HTTPS 代理拉镜像；设置后运行 `bash install.sh` 会执行 `modules/20_docker_proxy.sh`，也可单独运行 `./configure_docker_proxy.sh`

若本机梯子使用 [v2rayN](https://github.com/2dust/v2rayN)，在 v2rayN 里开启「允许来自局域网的连接」并记下 **本地代理端口**（常见为 `127.0.0.1` 与软件里显示的端口；若为 **混合端口**，HTTP 与 SOCKS 常是同一端口，以实际设置为准）。把 `DOCKER_PROXY_HOST` / `DOCKER_PROXY_PORT` 填成该地址与端口即可让 `docker pull` 等走 HTTP 代理。SSH 走代理时可用 `ncat` 的 `--proxy-type http` 或同端口的 `--proxy-type socks5`，与入站协议一致即可。

## 特性

- 🔄 幂等性：已安装的包和已存在的配置会被跳过
- ✅ 安全检查：自动检查已安装的包，避免重复安装
- 📝 详细日志：清晰的执行日志输出

## 模块说明

- `modules/00_base.sh`: 基础系统包安装
- `modules/05_git_ssh.sh`: Git和SSH配置
- `modules/02_shell.sh`: Shell 工具安装（尽早写 .zshrc，后续模块在其上追加）
- `modules/15_fishros.sh`: FishROS安装（ROS开发环境）
- `modules/17_conda.sh`: Conda/Miniconda 安装
- `modules/20_docker_proxy.sh`: Docker代理配置（需要先配置代理服务）

## 模板文件

`templates/` 目录包含可复用的配置文件模板：

- `templates/zshrc`: zsh 配置文件模板
- `templates/devcontainer.json`: VS Code DevContainer 配置模板（ROS 开发环境）

使用模板时，复制到对应位置并根据项目需求修改标记为 `TODO` 的部分。

## 注意事项

- 需要sudo权限
- 首次运行会提示输入sudo密码
- SSH密钥生成后，公钥会显示在终端，需要手动添加到GitHub/GitLab
- **Docker APT 源**：若系统里已添加过 Docker 官方 apt 源且 GPG 密钥过期（`apt update` 报密钥过期/EXPKEYSIG），`install.sh` 会在首次 `apt update` 前自动检测并刷新 Docker 的密钥与源配置，无需手动处理
