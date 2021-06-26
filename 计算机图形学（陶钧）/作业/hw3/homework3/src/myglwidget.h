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
#include <iostream>
using namespace std;

class MyGLWidget : public QOpenGLWidget, protected QOpenGLFunctions {
    Q_OBJECT

public:
    MyGLWidget(QWidget *parent = nullptr);
    ~MyGLWidget();

protected:
    void initializeGL();
    void paintGL();
    void resizeGL(int width, int height);
    void UseMyShader();

private:
    QTimer *timer;
    double theta = 0;
    double R = 0.6;
    double PI = acos(-1);

    const char* VertexCode = R"(
#version 120
uniform int radius;
varying vec4 vertex_in_modelview_space;
void main()
{
    gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
    gl_PointSize = radius * (1 + gl_Position.z);
    gl_FrontColor = gl_Color;

    vertex_in_modelview_space = gl_ModelViewMatrix * gl_Vertex;
}
)";

    const char* FragmentCode = R"(
#version 120
uniform vec3 camera_pos;
varying vec4 vertex_in_modelview_space;
void main()
{
    float dist = distance(gl_PointCoord, vec2(0.5, 0.5));
    if (dist > 0.5)
         discard;

    vec2 n_xy = gl_PointCoord - vec2(0.5, 0.5);
    vec3 n = normalize(vec3(n_xy, sqrt(0.5 * 0.5 - dot(n_xy, n_xy))));   // 法向量
    vec3 l = normalize(vec3(gl_LightSource[0].position - vertex_in_modelview_space));   // 入射方向

    vec3 r = reflect(-l, n);  // 反射方向
    vec3 v = camera_pos - vertex_in_modelview_space.xyz;     // 观察方向
    vec3 h = normalize(v + l);

    vec4 ambient = gl_LightSource[0].ambient;
    vec4 diffuse = gl_LightSource[0].diffuse;
    vec4 specular = gl_LightSource[0].specular;

    float diffuse_term = clamp(dot(n, l), 0.0, 1.0);
    float specular_term = max(pow(dot(n, h), 500), 0);

    if (dot(n, r) < 0)
        gl_FragColor = (ambient + 0.7 * diffuse * diffuse_term) * gl_Color;
    else
        gl_FragColor = (ambient + 0.7 * diffuse * diffuse_term + specular * specular_term) * gl_Color;
}
)";
};

#endif // MYGLWIDGET_H
