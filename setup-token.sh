#!/bin/bash
# GitHub Token 配置脚本
# 解决 "Password authentication is not supported" 错误

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${GREEN}=== GitHub Token 配置工具 ===${NC}"
echo ""

# 检查是否已有 token
if [ -f ~/.git-credentials ]; then
    echo -e "${YELLOW}检测到已存在的凭证配置:${NC}"
    cat ~/.git-credentials
    echo ""
    read -p "是否重新配置? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${GREEN}保持现有配置，退出。${NC}"
        exit 0
    fi
fi

echo -e "${BLUE}=== 如何获取 GitHub Personal Access Token ===${NC}"
echo ""
echo "1. 在浏览器中打开: https://github.com/settings/tokens"
echo "2. 点击 'Generate new token (classic)'"
echo "3. 输入 Token 名称，例如: hexo-deploy"
echo "4. 勾选 'repo' 权限（完整仓库访问）"
echo "5. 点击页面底部的 'Generate token'"
echo "6. ⚠️  立即复制生成的 token（只显示一次！）"
echo ""

# 交互式输入
read -p "请输入你的 GitHub 用户名: " USERNAME
read -s -p "请输入你的 GitHub Personal Access Token: " TOKEN
echo ""

if [ -z "$USERNAME" ] || [ -z "$TOKEN" ]; then
    echo -e "${RED}错误: 用户名和 Token 不能为空${NC}"
    exit 1
fi

# 验证 token 格式
if [[ ! $TOKEN =~ ^ghp_[a-zA-Z0-9]{36}$ ]]; then
    echo -e "${YELLOW}警告: Token 格式看起来不正确${NC}"
    echo "GitHub PAT 应该以 'ghp_' 开头，后跟 36 个字符"
    read -p "是否继续? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# 配置 git
echo -e "${YELLOW}[1/2] 配置 Git 凭证存储...${NC}"
git config --global credential.helper store

# 写入凭证
echo -e "${YELLOW}[2/2] 写入凭证...${NC}"
echo "https://${USERNAME}:${TOKEN}@github.com" > ~/.git-credentials
chmod 600 ~/.git-credentials

echo -e "${GREEN}✓ Token 配置完成！${NC}"
echo ""

# 测试验证
echo -e "${YELLOW}正在测试连接...${NC}"
if curl -s -o /dev/null -w "%{http_code}" -H "Authorization: token ${TOKEN}" https://api.github.com/user | grep -q "200"; then
    echo -e "${GREEN}✓ Token 验证成功！${NC}"
else
    echo -e "${RED}✗ Token 验证失败，请检查 token 是否正确${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}现在可以运行部署命令了:${NC}"
echo "  npm run build"
echo "  npm run deploy"
