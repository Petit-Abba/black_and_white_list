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
           ├── log.md          <--- 日志文件: 每次重启设备重新记录
           ├── 白名单.prop      <--- 防止输入错误后保存: 如/data
           └── 黑名单.prop       <--- 输入需要定时删除的(文件\文件夹)完整路径
```
![](https://github.com/Petit-Abba/black_and_white_list/blob/d1c84b93da671f5c14ad8e3c09d6bf7e78536704/A/Picture/3.jpg)
- Magisk20.4+

## 说明
- 模块刷入重启后，只在用户`解锁设备才开始生效`，所以你要是说你刷了模块开不了机，那就是其他问题，雨我无瓜。
- 使用`crond`定时命令，**不会浪费或占用系统资源**。
- 只要你手机开机，只要使用任何软件，设备本身就**已经开始进行各种频繁读写**，该模块`锁屏时不执行`，`解锁设备`并且设备存在黑名单内的路径`文件/文件夹`时，才会进行删除操作。太注重于闪存性能，干脆使用[小灵通](https://baike.baidu.com/item/%E5%B0%8F%E7%81%B5%E9%80%9A/94341?ivk_sa=1024630g)。

## 关于模块
- 支持用户自定义定时时间: 可以在`/sdcard/Android/clear_the_blacklist/定时任务`文件夹中编辑`定时设置.ini`文件，编辑完成后保存，以`root方式执行`在同一目录下的`Run_cron.sh`脚本即可完成自定义定时。
- 支持在需要删除的文件夹中添加`black`文件，脚本运行时会自动将该路径添加至黑名单.prop内的`#black标识符`下方，`#black标识符可以更改至任意行`，但`不能删除或重复输入多个#black标识符`。
- 支持使用通配符`*`，如果重要文件或文件夹在通配符范围内，记得先写入白名单。
- 支持空格文件或者文件夹，比如:`/sdcard/12 3456`文件夹，或`/sdcard/123 456`文件。
- 模块尽可能以`最小的资源`和`最快的速度`完成读取和清理黑名单列表的任务。

## 黑白名单示意图
![](https://github.com/Petit-Abba/black_and_white_list/blob/663b05b4ffba84ee633a6fda6e0ed5040def2ddd/A/Picture/1.jpg)
![](https://github.com/Petit-Abba/black_and_white_list/blob/663b05b4ffba84ee633a6fda6e0ed5040def2ddd/A/Picture/2.jpg)
