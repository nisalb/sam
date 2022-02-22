#!/usr/bin/sh

__help() {
    cat <<EOF
 COURSE: An automated script for trying out examples in programming books

 Usage: course COMMAND [ARGUMENTS]...

 Commands:

  init    initialize a new project, Create files and directories and initialize git
          This will create a main Makefile and the directory structure as follows:
              build/
              include/
              notes/
              src/
              .last_make
              Makefile
              Makefile.targets
              Makefile.info
              .projectile
              .gitignore

  add     Add a new example. A make target would be added to create an executable
          from one or more source files. Each example has a module. Source files
          are created in this module directory.
          This command has three (or more arguments):

              course add <NAME> <MODULE> <SOURCE-1>,<SOURCE-2>...

          NAME
              is the name of the example and executable file
          MODULE
              is the directory name in which the source files are created
          SOURCE-n
              names of the source files. If not exists they will be created.

  run     Build the specified example and run.
              course run <NAME>

          NAME
              is the name of the example.

  reset   Clean the build files
EOF
}

__report_status() {
    if [ "$1" -ne "0" ]; then
        echo -e "\t\e[91mFAILED\e[0m"
    fi
}

course_init() {
    echo -e "\tBuilding directory set... "
    mkdir -v include notes src build
    __report_status $?

    echo -e "\tAdding Makefile..."
    cat > Makefile <<EOF
##<! (files/Makefile)
EOF
    __report_status $?

    echo -e "\tAdding Makefile.info..."
    cat > Makefile.info <<EOF
##<! (files/Makefile.info)
EOF

    echo -e "\tInitializing git repository..."
    git init
    __report_status $?

    echo -e "\tAdding .gitignore..."
    cat > .gitignore <<EOF
##<! (files/gitignore)
EOF

    echo -e "\tAdding other files..."
    touch .last_make .projectile Makefile.targets
    __report_status $?
}

course_add_example() {
    name=$1
    module=$2
    sources=$3

    echo -e "\tAdding '$1' to module '$2' with source files [ $(echo $3 | sed 's/,/, /') ] ..."
    NAME=$name MODULE=$module SOURCES=$sources make add
    __report_status $?
}

course_run_example() {
    name=$1

    if [[ $name == --* ]]; then
       echo "Expected a target name, given $name";
       exit
    fi

    bear=0
    if [ $2 = "--bear" ]; then
       bear=1
    fi

    echo -e "\tAttempting to build '$name'..."
    BEAR=$bear make $name
    __report_status $?

    echo -e "\tRunning '$name'"
    echo -e '\t-- [ START ] --'
    ./build/$name
    echo -e '\t---[  END  ] --'
}

course_reset() {
    echo -e "\tCleaning build directory..."
    make clean
    __report_status $?
}

case $1 in
    init  ) course_init ;;
    add   ) course_add_example $2 $3 $4 ;;
    run   ) course_run_example $2 $3;;
    reset ) course_reset ;;
    *     ) __help ;;
esac
