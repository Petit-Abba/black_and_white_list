# black_and_white_list

[![Stars](https://img.shields.io/github/stars/Petit-Abba/black_and_white_list?label=stars)](https://github.com/Petit-Abba)
[![Download](https://img.shields.io/github/downloads/Petit-Abba/black_and_white_list/total)](https://github.com/Petit-Abba/black_and_white_list/releases)
[![Release](https://img.shields.io/github/v/release/Petit-Abba/black_and_white_list?label=release)](https://github.com/Petit-Abba/black_and_white_list/releases/latest)
[![License](https://img.shields.io/github/license/Petit-Abba/black_and_white_list?label=License)](https://choosealicense.com/licenses/gpl-3.0)

`模块刷入重启后查看`

```
管理器
  └── /sdcard
     └── /Android
        └── /clear_the_blacklist  <--- 模块生成的目录
           │
           ├── /定时任务          <--- 文件夹
           │  ├── 定时设置.ini     <--- 在里面自定义参数
           │  └── Run_cron.sh     <--- ini文件定义好之后以root执行
           │
           ├── log.md          <--- 日志文件: 每次重启设备或次日重新记录
           ├── 黑名单.prop      <--- 输入需要定时删除的(文件\文件夹)完整路径
           └── 白名单.prop      <--- 防止在黑名单.prop输入错误后保存: 如/data
```

![](https://github.com/Petit-Abba/black_and_white_list/blob/d1c84b93da671f5c14ad8e3c09d6bf7e78536704/A/Picture/3.jpg)

- Magisk 20.4+
- 支持Ksu
- 支持任何安卓设备

## 为什么会有这个模块

> 由于某些应用程序喜欢在/sdcard目录乱一些没用的屎，即使删除之后还会再拉，即使使用了[存储空间隔离app]
> 依然逃不过侧漏，为了/sdcard根目录简洁，故而有了黑白名单列表(
> 黑名单删除指定路径文件或文件夹；白名单保护指定路径文件或文件夹不被黑名单误删)。

> 其实模块并不局限于/sdcard根目录，你还可以用它做更多的事，比如: 定时清理应用缓存，或者某些app的广告。

## 模块特性

- **支持自定义定时时间**: 可以在`/sdcard/Android/clear_the_blacklist/定时任务`文件夹中编辑`定时设置.ini`
  文件，编辑完成后保存，以`root方式执行`在同一目录下的`Run_cron.sh`脚本即可完成自定义定时。
- **支持`空格`文件或者文件夹**: `/sdcard/12 3456`文件 | `/sdcard/123 456`文件夹
- **支持使用通配符`*`**: `/sdcard/12 3456/*`，如果重要文件或文件夹在通配符范围内，记得先写入白名单。
- **使用更安全通配符判断方式，例如`/data/media/0/*`这种危险通配符不会执行，必须填写成`/data/media/0/&*`才会执行清理操作。**
- **模块支持大文件跳过功能。开启后在黑名单中会自动跳过超过设定体积大小的文件，防止设置黑名单路径时删除可能的个人文件。**
- **模块支持自定义更长的时间运行一次，可以以天为单位进行运行。**
- **支持使用Magisk和Ksu的设备安装使用**

[//]: # (- **支持在需要删除的文件夹中添加`black`文件**: 懒人必备，脚本运行时会自动将该路径添加至黑名单.prop内的`#black标识符`下方，注意 `#black标识符可以更改至任意行`，但`不能删除或重复输入多个#black标识符`。)

- **模块尽可能以`最小的资源`和`最快的速度`完成读取和清理黑名单列表的任务(1s/次)。**

## 未雨绸缪者须知

- 模块刷入重启后，只在用户`解锁设备才开始生效`！
- 模块黑名单**不会内置任何规则**，用户需自行输入定义。
- 使用`crond`定时命令，**不会浪费或占用系统资源**。
- 只要你手机开机，只要使用任何软件，设备本身就**已经开始进行各种频繁读写**，该模块`锁屏时不执行`，`解锁设备`
  并且设备存在黑名单内的路径`文件/文件夹`
  时，才会进行删除操作。太注重于闪存性能，干脆使用[小灵通](https://baike.baidu.com/item/%E5%B0%8F%E7%81%B5%E9%80%9A/94341?ivk_sa=1024630g)。

## 黑名单列表(仅供参考)

> 模块没有内置任何规则，但这里可以给一些参考，或许会有人需要。

> 如果你有好用的规则，也可以提交~

`可点击右上角复制`

```
# dropbox文件夹内有不断生成的日志文件(dropbox规则)
/data/system/dropbox/*

# app应用的所有缓存文件夹内的所有文件(缓存规则)
/data/data/*/*cache*/*
# 如果你使用了缓存规则后有app出现加载问题
# 可以在白名单中添加相应路径进行跳过
# 比如跳过清理酷安的缓存(其他同理 正常来说清理缓存并不影响应用任何东西): 
# /data/data/com.coolapk.market/*cache*/*
```

## 黑白名单示意图

![](https://github.com/Petit-Abba/black_and_white_list/blob/663b05b4ffba84ee633a6fda6e0ed5040def2ddd/A/Picture/1.jpg)
![](https://github.com/Petit-Abba/black_and_white_list/blob/663b05b4ffba84ee633a6fda6e0ed5040def2ddd/A/Picture/2.jpg)
![](https://github.com/Petit-Abba/black_and_white_list/blob/663b05b4ffba84ee633a6fda6e0ed5040def2ddd/A/Picture/4.jpg)
