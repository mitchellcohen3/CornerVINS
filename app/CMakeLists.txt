add_executable(test_cid test_cid.cpp)
target_link_libraries(test_cid
#        ${PROJECT_NAME}
        ${PROJECT_SOURCE_DIR}/lib/libCornerVINS.so
        ${ThirdParty_Libraries}
)