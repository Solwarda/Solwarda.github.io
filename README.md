# 个人博客系统

一个使用 Hexo + GitHub Pages 搭建的简洁美观的个人博客。

## 功能特点

- ✨ 简洁美观的界面设计
- 📱 响应式布局，支持移动设备
- 🚀 快速加载和良好的性能
- 🔍 内置搜索功能
- 📊 分类、标签、归档功能
- 💬 评论系统支持
- 📈 访问统计功能

## 快速开始

### 环境要求

- Node.js 14+
- npm 或 yarn

### 安装依赖

```bash
npm install
```

### 本地开发

```bash
npm run server
```

博客将在 http://localhost:4000 启动

### 部署到 GitHub Pages

```bash
npm run deploy
```

## 项目结构

```
blog/
├── source/             # 源文件目录
│   ├── _posts/         # 博客文章
│   └── about/          # 关于页面
├── themes/             # 主题目录
│   └── icarus/         # Icarus 主题
├── _config.yml         # Hexo 配置文件
├── _config.icarus.yml  # Icarus 主题配置文件
├── package.json        # 项目依赖配置
└── README.md          # 项目说明文档
```

## 自定义配置

### 站点信息

在 `_config.yml` 中修改：

```yaml
# Site
title: 我的博客
subtitle: '个人博客'
description: '记录学习与生活'
keywords:
author: Solwarda
language: zh-CN
timezone: 'Asia/Shanghai'
```

### 主题配置

在 `_config.icarus.yml` 中修改主题相关配置。

### 写作文章

在 `source/_posts/` 目录下创建新的 Markdown 文件：

```bash
hexo new "文章标题"
```

## 主题

使用 [Icarus](https://github.com/ppoffice/hexo-theme-icarus) 主题，这是一个现代化、响应式的 Hexo 主题。

## License

MIT
