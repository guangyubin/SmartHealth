
include_directories(${PROJECT_SOURCE_DIR})
aux_source_directory(. SRC)  # 将当前目录所有文件添加到变量 PROGRAM_SOURCE 中
LINK_DIRECTORIES(${LIBRARY_OUTPUT_PATH})
add_executable(main ${SRC}) # 指定目标可执行文件 hello 的源代码文件为 PROGRAM_SOURCE
target_link_libraries(main ecglib )