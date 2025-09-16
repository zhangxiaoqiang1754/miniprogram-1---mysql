# 管理员认证问题解决指南

## 🚨 问题描述

后台管理系统出现401 Unauthorized错误，提示"token无效或已过期"。

## 🔍 问题原因

1. **未登录**: 后台管理系统需要管理员登录认证
2. **Token过期**: 登录token已过期
3. **管理员用户不存在**: 数据库中未创建管理员用户
4. **数据库连接问题**: 无法连接到数据库

## 🚀 解决方案

### 方案一：一键修复（推荐）

```batch
# 运行一键修复脚本
fix-admin-auth.bat
```

这个脚本会：
- 检查数据库连接
- 创建管理员用户
- 提供登录信息
- 创建测试脚本

### 方案二：手动修复

#### 1. 检查数据库连接
```batch
# 测试数据库连接
test-db-connection.bat
```

#### 2. 创建管理员用户
```batch
# 进入server目录
cd server

# 设置开发环境变量
set NODE_ENV=development
set DB_PASSWORD=1234

# 运行管理员初始化脚本
node scripts/init-admin.js
```

#### 3. 启动服务
```batch
# 启动API服务
start-server-dev.bat

# 启动后台管理
start-admin.bat
```

### 方案三：使用快速登录

```batch
# 查看管理员登录信息
admin-quick-login.bat
```

## 🔑 管理员登录信息

### 默认管理员账户
- **手机号**: `13800138000`
- **昵称**: `系统管理员`
- **密码**: (无密码，直接登录)

### 登录步骤
1. 访问后台管理: http://localhost:3001
2. 输入手机号: `13800138000`
3. 密码留空或输入任意字符
4. 点击登录

## 🧪 测试认证

### 测试管理员登录
```batch
# 运行登录测试脚本
node test-admin-login.js
```

### 手动测试API
```javascript
// 使用curl测试
curl -X POST http://localhost:3002/api/user/admin-login \
  -H "Content-Type: application/json" \
  -d '{"phoneNumber":"13800138000","password":""}'
```

## 🔧 故障排除

### 1. 数据库连接失败
```batch
# 检查MySQL服务
net start mysql

# 测试连接
mysql -u root -p1234 -e "SELECT 1;"
```

### 2. 管理员用户创建失败
```batch
# 手动创建管理员用户
cd server
node -e "
const { User } = require('./models');
const { sequelize } = require('./config/database');

(async () => {
  try {
    await sequelize.authenticate();
    const admin = await User.create({
      phoneNumber: '13800138000',
      nickName: '系统管理员',
      isAdmin: true
    });
    console.log('管理员创建成功:', admin.id);
  } catch (error) {
    console.error('创建失败:', error.message);
  }
  process.exit(0);
})();
"
```

### 3. Token验证失败
```batch
# 清除浏览器缓存和localStorage
# 重新登录获取新token
```

### 4. API调用失败
```batch
# 检查服务器是否启动
netstat -an | findstr :3002

# 重启服务器
start-server-dev.bat
```

## 📋 常见错误及解决方案

### 错误1: "Access denied for user 'root'@'localhost'"
**解决方案**: 运行 `fix-mysql-connection.bat`

### 错误2: "Cannot find module 'sequelize'"
**解决方案**: 
```batch
cd server
npm install
```

### 错误3: "Token无效或已过期"
**解决方案**: 
1. 清除浏览器缓存
2. 重新登录
3. 检查token格式

### 错误4: "401 Unauthorized"
**解决方案**: 
1. 确保已登录
2. 检查token是否有效
3. 重新获取token

## 💡 最佳实践

1. **定期备份**: 备份管理员用户数据
2. **密码管理**: 为管理员设置强密码
3. **Token管理**: 定期更新token
4. **监控日志**: 监控认证相关日志
5. **权限控制**: 严格控制管理员权限

## 📞 技术支持

如果问题仍然存在：

1. 运行 `fix-admin-auth.bat` 进行完整诊断
2. 检查服务器日志
3. 验证数据库连接
4. 确认管理员用户存在
5. 测试API端点

## 🔄 维护命令

```batch
# 重新创建管理员用户
node server/scripts/init-admin.js

# 测试认证流程
node test-admin-login.js

# 检查服务状态
netstat -an | findstr :3002

# 重启所有服务
start-server-dev.bat
start-admin.bat
```
