QT += core gui opengl

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

CONFIG += console qt c++11

DEFINES += QT_DEPRECATED_WARNINGS

LIBS += \
    OpenGL32.lib \
    Glu32.lib


SOURCES += \
    main.cpp \
    myglwidget.cpp

HEADERS += \
    myglwidget.h


