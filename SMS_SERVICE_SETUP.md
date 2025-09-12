# 短信服务配置指南

## 问题说明
当前验证码只在控制台输出，未真正发送到手机，需要配置短信服务。

## 解决方案

### 方案1: 微信云开发短信服务（推荐）

#### 1. 开通微信云开发短信服务
1. 登录微信云开发控制台
2. 进入"扩展能力" → "短信服务"
3. 点击"开通服务"
4. 完成实名认证和资质审核

#### 2. 配置短信模板
1. 在短信服务页面创建模板
2. 模板内容示例：
   ```
   您的验证码是：{{code}}，5分钟内有效。请勿泄露给他人。
   ```
3. 等待模板审核通过

#### 3. 代码配置
```javascript
// 云函数中发送短信
const smsResult = await cloud.openapi.cloudbase.sendSms({
  env: cloud.DYNAMIC_CURRENT_ENV,
  content: `您的验证码是：${verificationCode}，5分钟内有效。`,
  path: '/pages/login/index',
  phoneNumberList: [phoneNumber]
})
```

### 方案2: 第三方短信服务

#### 1. 阿里云短信服务
```javascript
// 安装依赖
npm install @alicloud/sms20170525

// 配置发送
const smsClient = new SMSClient({
  accessKeyId: 'your-access-key-id',
  accessKeySecret: 'your-access-key-secret'
})

const result = await smsClient.sendSms({
  PhoneNumbers: phoneNumber,
  SignName: '您的签名',
  TemplateCode: 'SMS_123456789',
  TemplateParam: JSON.stringify({ code: verificationCode })
})
```

#### 2. 腾讯云短信服务
```javascript
// 安装依赖
npm install tencentcloud-sdk-nodejs

// 配置发送
const tencentcloud = require("tencentcloud-sdk-nodejs")
const SmsClient = tencentcloud.sms.v20210111.Client

const client = new SmsClient({
  credential: {
    secretId: 'your-secret-id',
    secretKey: 'your-secret-key'
  },
  region: 'ap-guangzhou'
})

const result = await client.SendSms({
  PhoneNumberSet: [`+86${phoneNumber}`],
  SmsSdkAppId: 'your-sms-sdk-app-id',
  SignName: '您的签名',
  TemplateId: 'your-template-id',
  TemplateParamSet: [verificationCode]
})
```

### 方案3: 开发环境解决方案

#### 1. 控制台输出验证码
```javascript
// 开发环境下在控制台显示验证码
console.log('📱 验证码已发送到手机:', phoneNumber)
console.log('🔑 验证码:', verificationCode)
```

#### 2. 前端显示验证码
```javascript
// 在登录弹窗中显示验证码（仅开发环境）
if (process.env.NODE_ENV === 'development') {
  wx.showModal({
    title: '开发模式',
    content: `验证码：${verificationCode}`,
    showCancel: false
  })
}
```

## 配置步骤

### 1. 微信云开发短信服务配置
1. **开通服务**
   - 登录微信云开发控制台
   - 进入"扩展能力" → "短信服务"
   - 点击"开通服务"

2. **创建短信模板**
   - 模板名称：验证码通知
   - 模板内容：您的验证码是：{{code}}，5分钟内有效。请勿泄露给他人。
   - 模板类型：验证码类

3. **获取模板ID**
   - 模板审核通过后，记录模板ID
   - 在代码中使用模板ID

### 2. 环境变量配置
```javascript
// 在云函数中配置
const SMS_CONFIG = {
  templateId: 'your-template-id',
  signName: '您的签名',
  env: cloud.DYNAMIC_CURRENT_ENV
}
```

### 3. 错误处理
```javascript
// 短信发送失败时的处理
if (smsResult.errCode !== 0) {
  console.error('短信发送失败:', smsResult.errMsg)
  // 开发环境下返回验证码
  if (process.env.NODE_ENV === 'development') {
    return {
      code: 200,
      message: '验证码发送成功（开发模式）',
      data: { code: verificationCode }
    }
  }
}
```

## 费用说明

### 微信云开发短信服务
- 免费额度：每月1000条
- 超出费用：0.05元/条
- 支持按量计费

### 第三方短信服务
- 阿里云：约0.045元/条
- 腾讯云：约0.05元/条
- 具体价格以官方为准

## 测试建议

### 1. 开发环境测试
- 使用控制台输出验证码
- 测试验证码验证逻辑
- 确认登录流程正常

### 2. 生产环境测试
- 配置真实短信服务
- 测试短信发送功能
- 验证用户体验

## 注意事项

1. **短信模板审核**
   - 模板内容需要符合规范
   - 审核时间通常1-3个工作日
   - 建议提前申请模板

2. **费用控制**
   - 设置短信发送频率限制
   - 监控短信发送量
   - 避免恶意刷验证码

3. **用户体验**
   - 发送失败时提供友好提示
   - 支持重新发送验证码
   - 验证码有效期合理设置

## 总结

推荐使用微信云开发短信服务，因为：
- 与小程序生态深度集成
- 配置简单，维护成本低
- 有免费额度，成本可控
- 支持模板管理，安全性高
