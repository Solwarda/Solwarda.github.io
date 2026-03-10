#!/bin/bash
# 博客部署脚本
# 用法: ./deploy.sh [GitHub用户名] [GitHub Token]

set -e

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Hexo 博客部署脚本 ===${NC}"

# 检查参数
if [ $# -lt 2 ]; then
    echo -e "${YELLOW}用法: ./deploy.sh <GitHub用户名> <GitHub Token>${NC}"
    echo -e "${YELLOW}示例: ./deploy.sh Solwarda ghp_xxxxxxxxxxxx${NC}"
    echo ""
    echo "如果没有 GitHub Token，请按以下步骤获取:"
    echo "1. 访问 https://github.com/settings/tokens"
    echo "2. 点击 'Generate new token (classic)'"
    echo "3. 勾选 'repo' 权限"
    echo "4. 复制生成的 token"
    exit 1
fi

USERNAME=$1
TOKEN=$2

# 配置 git 凭证存储
echo -e "${YELLOW}[1/4] 配置 Git 凭证存储...${NC}"
git config --global credential.helper store

# 写入凭证
echo "https://${USERNAME}:${TOKEN}@github.com" > ~/.git-credentials
echo -e "${GREEN}✓ Git 凭证已配置${NC}"

# 安装依赖
echo -e "${YELLOW}[2/4] 安装依赖...${NC}"
npm install

# 构建
echo -e "${YELLOW}[3/4] 构建博客...${NC}"
npm run build

# 部署
echo -e "${YELLOW}[4/4] 部署到 GitHub Pages...${NC}"
npm run deploy

echo -e "${GREEN}✓ 部署完成！${NC}"
echo -e "访问地址: https://${USERNAME}.github.io"
