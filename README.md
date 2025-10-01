# AI Chat Markdown Export


## 项目简介
AI Chat Markdown Export 是一个用户脚本（UserScript），用于一键将 ChatGPT / Gemini / Grok (X AI) 等网页端对话完整导出为结构化、干净的 Markdown 文件，自动处理：
- 全量滚动加载（无需手动翻页 / 展开历史）
- 代码块提取与语言标注
- LaTeX / KaTeX 数学公式转成 `$...$` / `$$...$$`
- 列表、表格、链接、图片、内联代码等 Markdown 化
- 自动时间戳与安全文件名生成
- Q / A 分节排版（`# Q:`、`# A:`）

无需后端，不上传数据，所有处理都在本地浏览器内完成。

## 支持的平台
目前脚本自动识别以下站点：
- ChatGPT: `https://chat.openai.com/` 与 `https://chatgpt.com/`
- Gemini: `https://gemini.google.com/`
- Grok (X AI): `https://x.com/i/grok*`, `https://grok.x.ai/`

（已在桌面 Chrome / Edge + Tampermonkey 测试，其他浏览器/脚本管理器大概率兼容。）

## 特性一览
- 自动向上“激进 + 耐心”滚动，直到消息稳定，尽可能加载完整对话
- 防抖与多轮尝试：避免遗漏早期上下文
- Markdown 结构清晰，适合直接存档、发布或二次整理
- 代码块：保留语言（若检测到）并使用三反引号包裹
- 数学公式：行内与块级分别转换 `$...$` / `$$...$$`
- 表格：转换为标准 Markdown 表格语法
- 列表：保持有序 / 无序格式
- 图片与链接：转为 `![alt](url)` / `[text](url)`
- 文件名格式：`YYYY-MM-DD_HH-MM-SS_标题.md`
- 处理非法文件名字符，避免在 Windows / macOS 上出错
- 深色 / 浅色模式均可使用

## 安装方式
1. 安装脚本管理器（任选其一）：
   - Tampermonkey（推荐）
   - Violentmonkey
   - Greasemonkey（新版本）
2. 打开以下 Raw 链接（若 404，请先将仓库中的脚本重命名为 `.user.js` 再使用）：
   https://raw.githubusercontent.com/YunAsimov/AI-Chat-Md-Export/main/ai-chat-md-export.user.js
3. 或者手动安装：
   - 打开仓库文件 `ai-chat-md-export.js`
   - 全选复制内容
   - 在脚本管理器中新建脚本并粘贴保存

> 注意：仓库当前文件名为 `ai-chat-md-export.js`，而元信息中指向的是 `ai-chat-md-export.user.js`。若需要脚本自动更新，可在仓库中新建或重命名为该后缀。

## 使用步骤
1. 进入任意支持平台的聊天页面，打开你想导出的会话
2. 页面顶部中央会出现一个按钮：`Save Conversation`
3. 点击按钮后脚本会：
   - 自动向上滚动多次尝试加载完整对话
   - 解析消息并转换为 Markdown
   - 触发浏览器下载 `.md` 文件
4. 若内容很多，请耐心等待；按钮文字会显示 `Loading full chat...`

## 导出内容结构示例
```
# Q:
如何用 Python 写一个快速排序？
# A:
下面是一个简单示例：
```python
def quicksort(arr):
    if len(arr) <= 1:
        return arr
    pivot = arr[len(arr)//2]
    left  = [x for x in arr if x < pivot]
    mid   = [x for x in arr if x == pivot]
    right = [x for x in arr if x > pivot]
    return quicksort(left) + mid + quicksort(right)
```


## 命名规则
- 文件名包含时间戳与会话标题：`2025-09-27_16-22-23_XXX.md`
- 若标题不可用或为空，则回退为 `chat_export`
- 非法字符会被替换为下划线 `_`

## 可能的限制 / 已知问题
- 某些平台动态加载策略若调整，可能导致未完全加载历史；可尝试重复点击
- Gemini / Grok 的内部结构若变更，代码块或公式格式可能需要适配
- 特殊嵌套 HTML / 自定义组件可能被简单文本化
- 暂未对引用块、脚注等特殊 Markdown 扩展做额外处理

## Roadmap / TODO（欢迎 PR）
- 支持更多平台（Claude、Poe、通义千问等）
- 增加可视化导出配置（是否包含时间、是否包含角色标签等）
- 支持多格式导出（HTML / PDF / JSON）
- 合并多轮会话批量导出
- 更智能的代码语言识别

## 开发与调试
克隆仓库：
```
Git clone https://github.com/YunAsimov/AI-Chat-Md-Export.git
```
修改脚本后，可直接在浏览器扩展管理器中重新载入。由于这是纯前端脚本，不需要构建工具。


## 反馈
问题 / 建议请提交 Issue：
https://github.com/YunAsimov/AI-Chat-Md-Export/issues

如果这个脚本对你有帮助，欢迎 Star 支持！⭐
