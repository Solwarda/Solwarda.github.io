# 博客发布手册

本文档说明如何发布博客到 GitHub Pages。

## 前置条件

1. 拥有 GitHub 账号
2. 博客仓库访问权限
3. 已安装 Node.js 和 npm

## 快速发布

```bash
# 1. 进入博客目录
cd /data/usershare/blog

# 2. 安装依赖（首次或依赖变更后）
npm install

# 3. 构建并部署
npm run build
npm run deploy
```

## 首次配置（解决鉴权失败问题）

如果你遇到 `fatal: could not read Username for 'https://github.com'` 错误，需要配置 GitHub 凭证。

### 方法一：使用 GitHub 个人访问令牌（推荐）

#### 步骤 1：生成 Personal Access Token (PAT)

1. 访问 GitHub 网站：https://github.com
2. 点击右上角头像 → **Settings**
3. 左侧菜单 → **Developer settings** → **Personal access tokens** → **Tokens (classic)**
4. 点击 **Generate new token (classic)**
5. 填写 Token 名称（如 `hexo-blog-deploy`）
6. 勾选权限：
   - `repo`（完整的仓库访问权限）
7. 点击 **Generate token**
8. **立即复制生成的 token**（只显示一次）

#### 步骤 2：配置 Git 凭证

```bash
# 配置凭证存储模式（永久存储）
git config --global credential.helper store

# 手动添加凭证（将 USERNAME 替换为你的 GitHub 用户名，TOKEN 替换为上面复制的 token）
echo "https://USERNAME:TOKEN@github.com" > ~/.git-credentials
```

例如：
```bash
echo "https://Solwarda:ghp_xxxxxxxxxxxx@github.com" > ~/.git-credentials
```

#### 步骤 3：验证配置

```bash
# 测试访问
curl -I https://api.github.com/user -H "Authorization: token ghp_你的TOKEN"

# 应该返回 200 OK
```

### 方法二：使用 SSH 密钥（高级）

如果你更喜欢使用 SSH：

```bash
# 1. 生成 SSH 密钥（如果还没有）
ssh-keygen -t ed25519 -C "your_email@example.com"

# 2. 添加 SSH key 到 SSH agent
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# 3. 复制公钥到 GitHub
cat ~/.ssh/id_ed25519.pub
# 然后在 GitHub Settings → SSH and GPG keys → New SSH key 中添加

# 4. 修改 _config.yml 中的部署配置为 SSH 格式
# repo: git@github.com:Solwarda/Solwarda.github.io.git
```

## 发布新文章流程

### 方式一：手动创建文章

```bash
# 1. 创建新文章文件
touch source/_posts/文章标题.md

# 2. 编辑文件，添加 front matter 和内容
```

文章格式示例：
```markdown
---
title: 文章标题
date: 2026-03-10 17:00:00
categories:
  - 分类名称
tags:
  - 标签1
  - 标签2
---

正文内容...
```

### 方式二：使用 Hexo 命令创建

```bash
# 创建新文章
npx hexo new "文章标题"

# 文件会自动创建在 source/_posts/ 目录下
```

### 发布

```bash
# 构建静态文件
npm run build

# 部署到 GitHub Pages
npm run deploy
```

## 常用命令

| 命令 | 说明 |
|------|------|
| `npm run server` | 启动本地开发服务器（http://localhost:4000） |
| `npm run build` | 生成静态文件到 public 目录 |
| `npm run clean` | 清理生成的文件和缓存 |
| `npm run deploy` | 部署到 GitHub Pages |

## 常见问题

### 1. 部署时提示 "could not read Username"

**原因**：GitHub 需要身份验证

**解决**：按照本文档"首次配置"部分配置 GitHub Token

### 2. 部署成功但页面没有更新

**原因**：GitHub Pages 有缓存延迟

**解决**：等待 2-5 分钟，或检查仓库设置中的 Pages 配置

### 3. 本地预览正常，部署后样式丢失

**原因**：URL 配置不正确

**解决**：检查 `_config.yml` 中的 `url` 配置是否与 GitHub Pages 地址一致

### 4. 文章不显示在首页

**原因**：文章日期设置在未来

**解决**：修改 front matter 中的 `date` 为当前日期，或设置 `future: true`

## 重要文件位置

| 文件/目录 | 说明 |
|-----------|------|
| `source/_posts/` | 博客文章存放目录 |
| `_config.yml` | 主配置文件（站点设置、部署配置） |
| `public/` | 生成的静态文件（自动生成，不要手动修改） |
| `.deploy_git/` | 部署缓存（可删除） |

## 备份建议

定期备份以下内容：
- `source/_posts/` 目录下的所有文章
- `_config.yml` 配置文件
- `themes/` 目录下的自定义主题修改

## 联系方式

如有问题，请联系博客管理员。

---
*最后更新：2026-03-10*
