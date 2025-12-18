cmake_minimum_required(VERSION 3.20)

# ============================================================================
# 项目配置 - 自动使用文件夹名称作为项目名
# ============================================================================
get_filename_component(PROJECT_NAME ${CMAKE_SOURCE_DIR} NAME)

# ============================================================================
# 交叉编译工具链配置
# ============================================================================
set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR arm)

set(CMAKE_C_COMPILER arm-none-eabi-gcc)
set(CMAKE_CXX_COMPILER arm-none-eabi-g++)
set(CMAKE_ASM_COMPILER arm-none-eabi-gcc)
set(CMAKE_OBJCOPY arm-none-eabi-objcopy)
set(CMAKE_SIZE arm-none-eabi-size)

set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

project(${PROJECT_NAME} C ASM)

# ============================================================================
# MCU 配置 (STM32F103C8T6)
# ============================================================================
set(MCU_FLAGS "-mcpu=cortex-m3 -mthumb")

# 编译选项
set(CMAKE_C_FLAGS "${MCU_FLAGS} -Wall -fdata-sections -ffunction-sections")
set(CMAKE_C_FLAGS_DEBUG "-g -O0")
set(CMAKE_C_FLAGS_RELEASE "-O2")

set(CMAKE_ASM_FLAGS "${MCU_FLAGS} -x assembler-with-cpp")

# 链接选项
set(LINKER_SCRIPT ${CMAKE_SOURCE_DIR}/stm32f103c8t6.ld)
set(CMAKE_EXE_LINKER_FLAGS "${MCU_FLAGS} -T${LINKER_SCRIPT} -Wl,--gc-sections -specs=nosys.specs -specs=nano.specs -lc -lm -lnosys")

# ============================================================================
# 宏定义
# ============================================================================
add_definitions(
    -DSTM32F10X_MD          # 中容量设备 (64-128KB Flash)
    -DUSE_STDPERIPH_DRIVER  # 使用标准外设库
)

# ============================================================================
# 头文件路径
# ============================================================================
include_directories(
    ${CMAKE_SOURCE_DIR}/Start
    ${CMAKE_SOURCE_DIR}/Library
    ${CMAKE_SOURCE_DIR}/User
)

# ============================================================================
# 源文件
# ============================================================================
file(GLOB_RECURSE SOURCES
    "Start/startup_stm32f10x_md_gcc.s"
    "Start/system_stm32f10x.c"
    "Library/*.c"
    "User/*.c"
)

# ============================================================================
# 生成目标
# ============================================================================
add_executable(${PROJECT_NAME}.elf ${SOURCES})

# 生成 hex 和 bin 文件
add_custom_command(TARGET ${PROJECT_NAME}.elf POST_BUILD
    COMMAND ${CMAKE_OBJCOPY} -O ihex $<TARGET_FILE:${PROJECT_NAME}.elf> ${PROJECT_NAME}.hex
    COMMAND ${CMAKE_OBJCOPY} -O binary $<TARGET_FILE:${PROJECT_NAME}.elf> ${PROJECT_NAME}.bin
    COMMAND ${CMAKE_SIZE} $<TARGET_FILE:${PROJECT_NAME}.elf>
    COMMENT "Building ${PROJECT_NAME}.hex and ${PROJECT_NAME}.bin"
)
