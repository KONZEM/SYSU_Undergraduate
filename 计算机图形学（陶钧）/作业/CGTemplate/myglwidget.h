#ifndef MYGLWIDGET_H
#define MYGLWIDGET_H

//#ifdef MAC_OS
//#include <QtOpenGL/QtOpenGL>
//#else
#include <GL/glew.h>
//#endif
#include <QtGui>
#include <QOpenGLWidget>
#include <QOpenGLFunctions>
#include <glut.h>

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
#endif // MYGLWIDGET_H
