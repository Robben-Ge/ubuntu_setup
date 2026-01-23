# V2Ray Docker 配置

## 文件说明

- `docker-compose.yml`: Docker Compose 配置文件
- `config.json`: V2Ray 配置文件
- `v2fly-core-latest.tar`: 导出的 Docker 镜像文件（22MB）

## 使用方法

### 方式1：使用本地镜像文件（推荐，无需网络）

如果已经有导出的镜像文件 `v2fly-core-latest.tar`：

```bash
# 加载镜像
docker load -i v2fly-core-latest.tar

# 启动服务
docker-compose up -d
```

### 方式2：从 Docker Hub 拉取（需要网络）

如果没有本地镜像文件，Docker Compose 会自动从 Docker Hub 拉取：

```bash
docker-compose up -d
```

## 导出镜像

如果需要重新导出镜像：

```bash
docker save v2fly/v2fly-core:latest -o v2fly-core-latest.tar
```

## 停止服务

```bash
docker-compose down
```

## 查看日志

```bash
docker-compose logs -f
```
