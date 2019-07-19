################################################################################
# Copyright (C) 2017 Advanced Micro Devices, Inc.
################################################################################

find_program(GIT NAMES git)

# Try to test without git
file(MAKE_DIRECTORY ${TMP_DIR}/repo)
execute_process(COMMAND ${GIT} describe --dirty --long --always WORKING_DIRECTORY ${TMP_DIR}/repo OUTPUT_VARIABLE GIT_TAG RESULT_VARIABLE RESULT)
if(NOT ${RESULT} EQUAL 0)
    set(GIT_TAG 0)
endif()
execute_process(COMMAND ${GIT} rev-list HEAD WORKING_DIRECTORY ${TMP_DIR}/repo OUTPUT_VARIABLE REVS RESULT_VARIABLE RESULT)
separate_arguments(REVS UNIX_COMMAND "${REVS}")
list(GET REVS 10 PARENT)
message("PARENT: ${PARENT}")
write_version_cmake(${TMP_DIR}/repo "1.0 PARENT ${PARENT}" "
    test_expect_eq(\${PROJECT_VERSION} 1.0)
    test_expect_eq(\${PROJECT_VERSION_MAJOR} 1)
    test_expect_eq(\${PROJECT_VERSION_MINOR} 0)
    test_expect_eq(\${PROJECT_VERSION_PATCH} 0)
    test_expect_eq(\${PROJECT_VERSION_TWEAK} 10-${GIT_TAG})
")
install_dir(${TMP_DIR}/repo)
