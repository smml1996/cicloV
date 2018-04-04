cmake_minimum_required(VERSION 3.8)
project(bdII)

set(CMAKE_CXX_STANDARD 11)

set(SOURCE_FILES main.cpp Comando.cpp Comando.h Create.cpp Create.h Update.cpp Update.h Delete.cpp Delete.h Insert.cpp Insert.h Select.cpp Select.h Interface.cpp Interface.h Helpers.cpp Helpers.h)
add_executable(bdII ${SOURCE_FILES})