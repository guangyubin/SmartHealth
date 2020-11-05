project(main_ecg)
file(GLOB ECGLIB ecglib/*.cpp)
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/ecglib)
add_executable(main_ecg  main.cpp ${ECGLIB})
set(CPACK_PROJECT_NAME ${PROJECT_NAME})
set(CPACK_PROJECT_VERSION ${PROJECT_VERSION})

