cmake_minimum_required(VERSION 3.16)

project(qt-casino VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Core Quick QuickControls2 WebSockets)

qt_standard_project_setup()

qt_add_executable(qt-casino
    src/main.cpp
    src/gamelogic.h
    src/gamelogic.cpp
)

# Set application icon
if(WIN32)
    set_target_properties(qt-casino PROPERTIES
        WIN32_EXECUTABLE TRUE
    )
    # Windows icon resource
    configure_file(${CMAKE_CURRENT_SOURCE_DIR}/icon.ico ${CMAKE_CURRENT_BINARY_DIR}/icon.ico COPYONLY)
endif()

qt_add_resources(qt-casino "qml"
    PREFIX "/"
    FILES
        qml/Main.qml
        qml/CrapsTable.qml
        qml/Die.qml
        qml/Chip.qml
        qml/ChipStack.qml
)

qt_add_resources(qt-casino "icons"
    PREFIX "/"
    FILES
        icon.ico
)

target_link_libraries(qt-casino PRIVATE
    Qt6::Core
    Qt6::Quick
    Qt6::QuickControls2
    Qt6::WebSockets
)

# Android specific settings
if(ANDROID)
    set_property(TARGET qt-casino PROPERTY QT_ANDROID_PACKAGE_SOURCE_DIR
                 ${CMAKE_CURRENT_SOURCE_DIR}/android)
endif()