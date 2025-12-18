# STM32F103 标准外设库 (SPL) 项目模板

基于 VS Code + CMake + Ninja + GCC 的 STM32F103C8T6 开发模板，开箱即用。

## 特性

- 使用 STM32 标准外设库 (Standard Peripheral Library)
- CMake 构建系统 + Ninja 快速编译
- VS Code 一键编译、调试
- 包含项目创建脚本，快速生成新项目

## 目录结构

```
├── Start/          # 启动文件和 CMSIS 核心文件
│   ├── startup_stm32f10x_md_gcc.s  # GCC 启动文件 (中容量)
│   ├── system_stm32f10x.c/h        # 系统初始化
│   ├── stm32f10x.h                 # 寄存器定义
│   └── core_cm3.c/h                # Cortex-M3 核心
├── Library/        # STM32 标准外设库
├── User/           # 用户代码
│   ├── main.c
│   ├── stm32f10x_conf.h            # 外设库配置
│   └── stm32f10x_it.c/h            # 中断处理
├── .vscode/        # VS Code 配置
├── CMakeLists.txt  # CMake 构建配置
├── stm32f103c8t6.ld                # 链接脚本
└── create_new_project.bat          # 项目创建脚本
```

## 环境要求

- [ARM GCC 工具链](https://developer.arm.com/downloads/-/gnu-rm) (arm-none-eabi-gcc)
- [CMake](https://cmake.org/download/) >= 3.20
- [Ninja](https://ninja-build.org/)
- [VS Code](https://code.visualstudio.com/)
- VS Code 扩展:
  - C/C++ (Microsoft)
  - Cortex-Debug
- [OpenOCD](https://openocd.org/) (调试用)
- ST-Link 调试器

## 快速开始

### 方法一：使用创建脚本 (推荐)

1. 修改 `create_new_project.bat` 中的模板路径：
   ```batch
   set TEMPLATE_DIR=你的模板路径
   ```

2. 运行脚本创建新项目：
   ```batch
   create_new_project.bat MyProject
   ```

3. 用 VS Code 打开生成的项目文件夹

### 方法二：手动复制

1. 复制整个模板文件夹并重命名
2. 创建 build 目录并配置：
   ```bash
   mkdir build && cd build
   cmake .. -G Ninja
   ```

## 使用方法

### 编译

- **VS Code**: 按 `Ctrl+Shift+B`
- **命令行**: 在 build 目录执行 `ninja`

### 调试

- **VS Code**: 按 `F5` 启动调试
- 需要连接 ST-Link 调试器

### 清理

- **VS Code**: 运行任务 "Clean"
- **命令行**: 在 build 目录执行 `ninja clean`

## 适配其他型号

### 修改芯片型号

1. **CMakeLists.txt** - 修改宏定义：
   ```cmake
   add_definitions(
       -DSTM32F10X_MD    # LD=小容量, MD=中容量, HD=大容量, XL=超大容量, CL=互联型
       -DUSE_STDPERIPH_DRIVER
   )
   ```

2. **Start/** - 选择对应的启动文件：
   - `startup_stm32f10x_ld_gcc.s` - 小容量 (16-32KB Flash)
   - `startup_stm32f10x_md_gcc.s` - 中容量 (64-128KB Flash)
   - `startup_stm32f10x_hd_gcc.s` - 大容量 (256-512KB Flash)
   - `startup_stm32f10x_xl_gcc.s` - 超大容量 (512KB-1MB Flash)
   - `startup_stm32f10x_cl_gcc.s` - 互联型

3. **stm32f103c8t6.ld** - 修改 Flash 和 RAM 大小：
   ```ld
   FLASH (rx) : ORIGIN = 0x08000000, LENGTH = 64K
   RAM (xrw)  : ORIGIN = 0x20000000, LENGTH = 20K
   ```

4. **.vscode/launch.json** - 修改设备名称

## 常见问题

### 编译报错找不到 arm-none-eabi-gcc

确保 ARM GCC 工具链已安装并添加到系统 PATH。

### 调试连接失败

1. 检查 ST-Link 驱动是否安装
2. 检查 OpenOCD 是否正确安装
3. 确认 ST-Link 与开发板连接正常

### 中文路径问题

建议项目路径不要包含中文或空格。

## License

MIT License
