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

## 特性

- 🔄 幂等性：已安装的包和已存在的配置会被跳过
- ✅ 安全检查：自动检查已安装的包，避免重复安装
- 📝 详细日志：清晰的执行日志输出

## 模块说明

- `modules/00_base.sh`: 基础系统包安装
- `modules/05_git_ssh.sh`: Git和SSH配置
- `modules/10_shell.sh`: Shell工具安装
- `modules/15_fishros.sh`: FishROS安装（ROS开发环境）

## 注意事项

- 需要sudo权限
- 首次运行会提示输入sudo密码
- SSH密钥生成后，公钥会显示在终端，需要手动添加到GitHub/GitLab
