@echo off
chcp 65001 >nul
title 管理员快速登录

echo 🔑 管理员快速登录指南
echo.

echo 📋 默认管理员账户信息：
echo.
echo ┌─────────────────────────────────────────┐
echo │           管理员登录信息                  │
echo ├─────────────────────────────────────────┤
echo │  手机号: 13800138000                    │
echo │  昵称: 系统管理员                        │
echo │  密码: (无密码，直接登录)                 │
echo └─────────────────────────────────────────┘
echo.

echo 💡 登录步骤：
echo 1. 确保后台管理系统已启动
echo 2. 访问: http://localhost:3001
echo 3. 在登录页面输入手机号: 13800138000
echo 4. 密码留空或输入任意字符
echo 5. 点击登录按钮
echo.

echo 🔧 如果登录失败，请尝试：
echo 1. 运行数据库初始化: node server/scripts/init-admin.js
echo 2. 检查数据库连接: test-db-connection.bat
echo 3. 重启服务器: start-server-dev.bat
echo.

echo 🚀 快速启动命令：
echo   启动后台管理: start-admin.bat
echo   启动API服务: start-server-dev.bat
echo   测试数据库: test-db-connection.bat
echo.

echo 按任意键退出...
pause >nul
