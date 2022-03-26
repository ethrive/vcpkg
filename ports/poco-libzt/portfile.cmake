vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO ethrive/poco-libzt
    REF 7dd036cd1df66180258c23c395c3be168936dfb1
    SHA512 9ef4afcbe8f89f52147165f2b2f1514ac34aaf976e969d6e5ad954971483e8dad4dba9137403883c8437ec4ca37eaa162896bc56a5e56a6b94e2e81304df55ed
)

# define Poco linkage type
string(COMPARE EQUAL "${VCPKG_LIBRARY_LINKAGE}" "static" POCO_STATIC)

vcpkg_check_features(OUT_FEATURE_OPTIONS FEATURE_OPTIONS
    FEATURES
        pdf         ENABLE_PDF
        netssl      ENABLE_NETSSL
        netssl      ENABLE_NETSSL_WIN
        netssl      ENABLE_CRYPTO
        sqlite3     ENABLE_DATA_SQLITE
        postgresql  ENABLE_DATA_POSTGRESQL
)

if ("mysql" IN_LIST FEATURES OR "mariadb" IN_LIST FEATURES)
    set(POCO_USE_MYSQL ON)
else()
    set(POCO_USE_MYSQL OFF)
endif()

vcpkg_cmake_configure(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS ${FEATURE_OPTIONS}
        # force to use dependencies as external
        -DPOCO_UNBUNDLED=OFF
        # Define linking feature
        -DPOCO_STATIC=${POCO_STATIC}
        -DENABLE_ACTIVERECORD=OFF
        -DENABLE_ACTIVERECORD_COMPILER=OFF
        -DENABLE_APACHECONNECTOR=OFF
        -DENABLE_CPPPARSER=OFF
        -DENABLE_CRYPTO=OFF
        -DENABLE_DATA=OFF
        -DENABLE_DATA_MYSQL=OFF
        -DENABLE_DATA_ODBC=OFF
        -DENABLE_DATA_POSTGRESQL=OFF
        -DENABLE_DATA_SQLITE=OFF
        -DENABLE_ENCODINGS=OFF
        -DENABLE_ENCODINGS_COMPILER=OFF
        -DENABLE_FOUNDATION=ON
        -DENABLE_JSON=ON
        -DENABLE_JWT=OFF
        -DENABLE_LIBZT=ON
        -DENABLE_MONGODB=OFF
        -DENABLE_NET=ON
        -DENABLE_NETSSL=OFF
        -DENABLE_NETSSL_WIN=OFF
        -DENABLE_PAGECOMPILER=OFF
        -DENABLE_PAGECOMPILER_FILE2PAGE=OFF
        -DENABLE_PDF=OFF
        -DENABLE_POCODOC=OFF
        -DENABLE_REDIS=OFF
        -DENABLE_SEVENZIP=OFF
        -DENABLE_TESTS=OFF
        -DENABLE_UTIL=ON
        -DENABLE_XML=ON
        -DENABLE_ZIP=OFF
)

vcpkg_cmake_install()

vcpkg_copy_pdbs()

# Copy additional include files not part of any libraries
if(EXISTS "${CURRENT_PACKAGES_DIR}/include/Poco/SQL")
    file(COPY "${SOURCE_PATH}/Data/include" DESTINATION "${CURRENT_PACKAGES_DIR}")
endif()
if(EXISTS "${CURRENT_PACKAGES_DIR}/include/Poco/SQL/MySQL")
    file(COPY "${SOURCE_PATH}/Data/MySQL/include" DESTINATION "${CURRENT_PACKAGES_DIR}")
endif()
if(EXISTS "${CURRENT_PACKAGES_DIR}/include/Poco/SQL/ODBC")
    file(COPY "${SOURCE_PATH}/Data/ODBC/include" DESTINATION "${CURRENT_PACKAGES_DIR}")
endif()
if(EXISTS "${CURRENT_PACKAGES_DIR}/include/Poco/SQL/PostgreSQL")
    file(COPY "${SOURCE_PATH}/Data/PostgreSQL/include" DESTINATION "${CURRENT_PACKAGES_DIR}")
    file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/include/libpq")
endif()
if(EXISTS "${CURRENT_PACKAGES_DIR}/include/Poco/SQL/SQLite")
    file(COPY "${SOURCE_PATH}/Data/SQLite/include" DESTINATION "${CURRENT_PACKAGES_DIR}")
endif()

if(VCPKG_TARGET_IS_WINDOWS)
  vcpkg_cmake_config_fixup(CONFIG_PATH cmake)
else()
  vcpkg_cmake_config_fixup(CONFIG_PATH lib/cmake/Poco)
endif()

file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/include")
file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/share")

file(INSTALL "${SOURCE_PATH}/LICENSE" DESTINATION "${CURRENT_PACKAGES_DIR}/share/${PORT}" RENAME copyright)
