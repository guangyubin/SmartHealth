include_directories(${CMAKE_CURRENT_SOURCE_DIR})
aux_source_directory(. SRC)  # 将当前目录所有文件添加到变量 PROGRAM_SOURCE 中
add_library(ecglib SHARED  ${SRC})