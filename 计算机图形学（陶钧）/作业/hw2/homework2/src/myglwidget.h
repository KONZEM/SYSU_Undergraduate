#ifndef MYGLWIDGET_H
#define MYGLWIDGET_H

#ifdef MAC_OS
#include <QtOpenGL/QtOpenGL>
#else
#include <GL/glew.h>
#endif
#include <QtGui>
#include <QOpenGLWidget>
#include <QOpenGLFunctions>
#include <stdio.h>
#include <math.h>

class MyGLWidget : public QOpenGLWidget{
    Q_OBJECT

public:
    MyGLWidget(QWidget *parent = nullptr);
    ~MyGLWidget();

protected:
    void initializeGL();
    void paintGL();
    void resizeGL(int width, int height);

private:
    QTimer *timer;

    // 左手臂摆的方向
    int left_arm_state = 1;
    // 左手臂摆的角度
    int left_arm_angle = 0;
    // 右手臂摆的方向
    int right_arm_state = -1;
    // 右手臂摆的角度
    int right_arm_angle = 0;
    // 每次增加的角度
    int per_arm_angle = 5;
    // 最大的摆臂角度
    int max_arm_angle = 15;

    // 左腿抬的方向
    int left_leg_state = -1;
    // 左腿抬的角度
    int left_leg_angle = 0;
    // 右腿抬的方向
    int right_leg_state = 1;
    // 右腿抬的角度
    int right_leg_angle = 0;
    // 每次增加的角度
    int per_leg_angle = 10;
    // 最大的抬腿角度
    int max_leg_angle = 30;

    // 运动轨迹的参数的增量
    double step = 1;
    // 运动轨迹的参数
    double cur_angle = 0;
    // 机器人的位置
    double cur_x = 0.0;
    double cur_y = 0.0;
    double cur_z = 0.0;
//    float cur_x = -100.0f;
//    float cur_y = 0.0f;
//    float cur_z = -50.0f;

//    int x_movement = 0;
//    int z_movement = 1;
//    float step = 5;
//    float bound_x = 100.0f;
//    float bound_z = 50.0f;
};

void draw_cube();
void draw_head();
void draw_body();
void draw_arm();
void draw_leg();
void draw_path();
#endif // MYGLWIDGET_H
