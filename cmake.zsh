function create_cmake_project {
    local project_path=""
    local project_name="myProject"
    local project_type=0
    local create_parents="n"
    vared -p 'Path to new cmake projet?: ' project_path
    read -s -q "pathok?Path: ${project_path}, Is this ok? [y/N] "

    if [[ ! "${pathok}" == "y" ]]; then
        echo "Aborting."
        return 1
    fi

    echo ""

    if [[ -a "${project_path}" ]]; then
        echo "File already exists. Aborting."
        return 1
    fi

    read -s -q "create_parents?Create parents directories if needed? [y/N] "

    echo ""
    echo ""

    read  "project_name?Please enter project name: "

    echo ""
    echo "Please specify project type:"
    echo "1 - Single binary"
    echo "2 - Single static library"
    echo "3 - Single dynamic library"
    echo "4 - Binary with static libraries"

    read -k 1 "project_type?Your choice: "

    echo ""
    echo ""
    echo -n "Selected "
    case "${project_type}" in
        "1")
            echo "single binary project: ${project_name}."
            __create_cmake_project_single_binary
            ;;
        "2")
            echo "single static library project: ${project_name}."
            __create_cmake_project_single_static_library
            ;;
        "3")
            echo "single dynamic library project: ${project_name}."
            __create_cmake_project_single_dynamic_library
            ;;
        "4")
            echo "binary with static libraries project: ${project_name}."
            __create_cmake_project_binary_with_libraries
            ;;
        *)
            echo "unknown project type (${project_type}). Aborting."
            return 1
            ;;
    esac
}

function __create_cmake_project_mkdir {
    if [[ "${create_parents}" == "y" ]]; then
        mkdir -p $1
    else
        mkdir $1
    fi
}

function __cmake_project_create_dir_tree {
    __create_cmake_project_mkdir "${project_path}" 2>/dev/null

    if [[ ! -d "${project_path}" ]]; then
        echo "Could not create directory: ${project_path}."
        return 1
    fi

    __create_cmake_project_mkdir "${project_path}/cmake" 2>/dev/null
    __create_cmake_project_mkdir "${project_path}/cmake/modules" 2>/dev/null
    __create_cmake_project_mkdir "${project_path}/${project_name}" 2>/dev/null
    __create_cmake_project_mkdir "${project_path}/${project_name}/src" 2>/dev/null
    __create_cmake_project_mkdir "${project_path}/${project_name}/include" 2>/dev/null
}

function __cmake_project_single_binary_create_cmakelists {
    cat <<EOF > "${project_path}/CMakeLists.txt"
cmake_minimum_required(VERSION 2.8)
project(${project_name} C CXX)

# set(CMAKE_VERBOSE_MAKEFILE ON)
set(CMAKE_COLOR_MAKEFILE ON)
set(CMAKE_MODULE_PATH \${CMAKE_SOURCE_DIR}/cmake/modules)

set(CMAKE_CXX_FLAGS "-std=c++11 -pedantic -Wall -Weffc++ -Wcast-align ")
set(CMAKE_CXX_FLAGS_DEBUG "-g")

set(EXECUTABLE_OUTPUT_PATH "\${CMAKE_SOURCE_DIR}/bin/")

subdirs(${project_name})
EOF

    cat <<EOF > "${project_path}/${project_name}/CMakeLists.txt"
subdirs(src)
EOF

    cat <<EOF > "${project_path}/${project_name}/src/CMakeLists.txt"
include_directories(\${\${PROJECT_NAME}_SOURCE_DIR}/${project_name}/include)

file(GLOB ${project_name}_SRCS *.cpp *.c)

add_executable(\${PROJECT_NAME} \${${project_name}_SRCS})

EOF

cat <<EOF > "${project_path}/${project_name}/src/${project_name}.c"
#include <stdio.h>

int main() {
    printf("Hello world!\n");
    return 0;
}
EOF
}

function __cmake_project_prepare_build {
    __create_cmake_project_mkdir "${project_path}/build" 2>/dev/null
    cd "${project_path}/build"
    cmake ..
    cd -
}

function __cmake_open_project {
    read -s -q "open_project?Would you like to open this project? [y/N] "

    if [[ "${open_project}" == "y" ]]; then
        emacs -nw "${project_path}/${project_name}/src/${project_name}.c"
    fi
}

function __create_cmake_project_single_binary {
    if [[ -n "${project_path}" ]]; then
        echo "Creating this project in ${project_path}"
        __cmake_project_create_dir_tree
        if [[ ! $? == 0 ]]; then
            echo "Aborting."
            return 1
        fi
        __cmake_project_single_binary_create_cmakelists
        __cmake_project_prepare_build
        __cmake_open_project
    fi
}

function __create_cmake_project_single_static_library {
    echo "Not implemented yet!"
}

function __create_cmake_project_single_dynamic_library {
    echo "Not implemented yet!"
}

function __create_cmake_project_binary_with_libraries {
    echo "Not implemented yet!"
}

