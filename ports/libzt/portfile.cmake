vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO ethrive/libzt
    REF fe6454cbf8ac5c012385c2634d181aed434589b7
    SHA512 789369e850aa724cacdae8fe9ac3be2f649334cf85e7e430fcbe89f84b81d36bf57b6fd9204872d2628aece4a26ddec78b460b1d402a4d961b87875c10d64926
    HEAD_REF ethrive
)

vcpkg_from_github(
        OUT_SOURCE_PATH ZEROTIERONE_SOURCE_PATH
        REPO ethrive/ZeroTierOne
        REF a14ed3858b5170081a77017c727e1bcc7c28c8a5
        SHA512 9486fe2bb0dd83867d641e2467b6ebf263579c93edf31f84a3b4977840d94648de591f384a18c57309d392a734fab92f8715fa0083dae9c5f5bb2c8fc11a06d4
        HEAD_REF ethrive
)

vcpkg_from_github(
        OUT_SOURCE_PATH LWIP_SOURCE_PATH
        REPO joseph-henry/lwip
        REF 32708c0a8b140efb545cc35101ee5fdeca6d6489
        SHA512 6562288a734a8ef08cc0db17a4c0766526a0111996f23ea5d417c7973a051b7d4cea6cbd65afef034af3fbc9c9edf143b371cec92c3eff14f46d085125aae43b
        HEAD_REF master
)

vcpkg_from_github(
        OUT_SOURCE_PATH LWIP_CONTRIB_SOURCE_PATH
        REPO joseph-henry/lwip-contrib
        REF 4fd612c9c72dfcd1db6618bd59c1a17d9f5b55f8
        SHA512 50ac84581557a0a07a1ac9bcdcb10ae023cccc70c54a6dbe698836e6e6c58d694c84ac07106771c93d903c3240a2c7b6da11c24a0da6e4918aeeedb177df611e
        HEAD_REF master
)

file(COPY ${ZEROTIERONE_SOURCE_PATH}/ DESTINATION ${SOURCE_PATH}/ext/ZeroTierOne)
file(COPY ${LWIP_SOURCE_PATH}/ DESTINATION ${SOURCE_PATH}/ext/lwip)
file(COPY ${LWIP_CONTRIB_SOURCE_PATH}/ DESTINATION ${SOURCE_PATH}/ext/lwip-contrib)

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS ${FEATURE_OPTIONS}
    -DBUILD_HOST_SELFTEST=OFF
    PREFER_NINJA
)

vcpkg_cmake_install()
vcpkg_copy_pdbs()

configure_file("${CMAKE_CURRENT_LIST_DIR}/unofficial-libzt-config.cmake" "${CURRENT_PACKAGES_DIR}/share/unofficial-libzt/unofficial-libzt-config.cmake" @ONLY)

file(INSTALL "${CURRENT_PORT_DIR}/usage" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME usage)
file(INSTALL "${SOURCE_PATH}/LICENSE.txt" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
