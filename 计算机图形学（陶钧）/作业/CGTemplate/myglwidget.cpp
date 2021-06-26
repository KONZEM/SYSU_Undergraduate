#include "myglwidget.h"

MyGLWidget::MyGLWidget(QWidget *parent)
	:QOpenGLWidget(parent),
	scene_id(0)
{
}

MyGLWidget::~MyGLWidget()
{

}

void MyGLWidget::initializeGL()
{
	glViewport(0, 0, width(), height());
	glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
	glDisable(GL_DEPTH_TEST);
}

void MyGLWidget::paintGL()
{
	if (scene_id==0) {
		scene_0();
	}
	else {
		scene_1();
	}
}

void MyGLWidget::resizeGL(int width, int height)
{
	glViewport(0, 0, width, height);
	update();
}

void MyGLWidget::keyPressEvent(QKeyEvent *e) {
	if (e->key() == Qt::Key_0) {
		scene_id = 0;
		update();
	}
	else if (e->key() == Qt::Key_1) {
		scene_id = 1;
		update();
	}
}

void MyGLWidget::scene_0()
{
	glClear(GL_COLOR_BUFFER_BIT);
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	glOrtho(0.0f, 100.0f, 0.0f, 100.0f, -1000.0f, 1000.0f);

	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
	glTranslatef(50.0f, 50.0f, 0.0f);
	
    glPushMatrix();
    glutSolidSphere (10.0, 40, 50);
    glPopMatrix();

	//draw a triangle
	glPushMatrix();
	glColor3f(0.839f, 0.153f, 0.157f);
	glTranslatef(-20.0f, -10.0f, 0.0f);
	glRotatef(45.0f, 1.0f, 0.0f, 1.0f);
	glTranslatef(-50.0f, -30.0f, 0.0f);
	glBegin(GL_LINE_LOOP);
	glVertex2f(10.0f, 10.0f);
	glVertex2f(50.0f, 50.0f);
	glVertex2f(80.0f, 10.0f);
	glEnd();
	glPopMatrix();	

	//draw a quad
	glPushMatrix();
	glColor3f(0.122f, 0.467f, 0.706f);
	glTranslatef(20.0f, 20.0f, 0.0f);
	glRotatef(30.0f, 1.0f, 1.0f, 1.0f);
	glBegin(GL_LINE_LOOP);
	glVertex2f(-20.0f, -20.0f);
	glVertex2f(20.0f, -20.0f);
	glVertex2f(20.0f, 20.0f);
	glVertex2f(-20.0f, 20.0f);
	glEnd();
	glPopMatrix();
}

void MyGLWidget::scene_1()
{
	glClear(GL_COLOR_BUFFER_BIT);
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	glOrtho(0.0f, width(), 0.0f, height(), -1000.0f, 1000.0f);

	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();

	glBegin(GL_POINTS);
	//your implementation
	//glVertex2i()
	glEnd();
}
