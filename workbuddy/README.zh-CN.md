# WorkBuddy 一键配置 Crazyrouter 自定义模型

这个脚本用于把 WorkBuddy 桌面版切换到 Crazyrouter 自定义供应商。默认接口为 `https://cn.crazyrouter.com`，会写入 WorkBuddy 实际读取的配置文件：

```text
%USERPROFILE%\.workbuddy\models.json
```

默认配置 5 个模型：

- `claude-opus-4-8`
- `claude-opus-4-7`
- `claude-sonnet-4-6`
- `gpt-5.5`
- `gpt-5.4`

## 一键使用

打开 PowerShell，执行：

```powershell
iwr https://raw.githubusercontent.com/xujfcn/crazyrouter-codex-cli/main/workbuddy/setup-workbuddy-crazyrouter.ps1 -UseB | iex
```

脚本会提示输入 Crazyrouter API Key。API Key 只会写入本机 WorkBuddy 配置文件，不会上传到其它地方。

也可以先设置环境变量，避免交互输入：

```powershell
$env:CRAZYROUTER_API_KEY="sk-你的CrazyrouterKey"
iwr https://raw.githubusercontent.com/xujfcn/crazyrouter-codex-cli/main/workbuddy/setup-workbuddy-crazyrouter.ps1 -UseB | iex
```

执行完成后，完全退出并重新打开 WorkBuddy，在模型列表里选择 `Custom` / 自定义模型即可。

## 做了什么

- 自动创建 `~\.workbuddy\models.json`
- 已存在配置时先生成 `.bak.yyyyMMdd-HHmmss` 备份
- 默认保留原有其它自定义模型
- 对同名模型执行更新，避免重复写入
- 将接口规范成 `https://cn.crazyrouter.com/v1`

## 可选参数

下载后本地执行时可以传参：

```powershell
.\workbuddy\setup-workbuddy-crazyrouter.ps1 -BaseUrl "https://cn.crazyrouter.com" -ReplaceCrazyrouter
```

常用参数：

- `-BaseUrl`：自定义 Crazyrouter 接口地址，默认 `https://cn.crazyrouter.com`
- `-Models`：覆盖默认模型列表
- `-ReplaceCrazyrouter`：删除旧的 Crazyrouter 自定义模型，只保留本次配置的模型
- `-NoBackup`：不生成备份

## 恢复旧配置

如果需要恢复，找到同目录下的备份文件，例如：

```text
%USERPROFILE%\.workbuddy\models.json.bak.20260605-140000
```

把备份文件改名回 `models.json`，然后重启 WorkBuddy。
