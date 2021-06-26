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
#include <math.h>
#include <stdio.h>
#include <vector>

using namespace std;

class MyGLWidget : public QOpenGLWidget{
    Q_OBJECT

public:
    MyGLWidget(QWidget *parent = nullptr);
    ~MyGLWidget();

protected:
    void initializeGL();
    void paintGL();
    void resizeGL(int width, int height);
	void keyPressEvent(QKeyEvent *e);

private:
	int scene_id;
	void scene_0();
	void scene_1();
};

void myswap(int& a, int& b);
void drawline(int x1, int y1, int x2, int y2, vector<float> color);
void rasterize(int x1, int y1, int x2, int y2, int mode, vector<int>& line_x, 
               vector<int>& line_y);
void matrix_mul(vector<vector<float>>& points, float matrix[3][4]);
void translate(vector<vector<float>>& points, float mx, float my, float mz);
void rotate(vector<vector<float>>& points, float angle, float a, float b, float c);
void rotate_2(vector<vector<float>>& points, float angle, float a, float b, float c);
void anti_alias(vector<int> line_x, vector<int> line_y, vector<float> color, int mode);

#endif // MYGLWIDGET_H
