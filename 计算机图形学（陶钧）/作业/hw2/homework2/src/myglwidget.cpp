#include "myglwidget.h"

const double PI = acos(-1);

/*###################################################
##  函数: MyGLWidget
##  函数描述： MyGLWidget类的构造函数，实例化定时器timer
##  参数描述：
##  parent: MyGLWidget的父对象
#####################################################*/

MyGLWidget::MyGLWidget(QWidget *parent)
	:QOpenGLWidget(parent)
{
	timer = new QTimer(this); // 实例化一个定时器
    timer->start(100); // 时间间隔设置为100ms，可以根据需要调整
	connect(timer, SIGNAL(timeout()), this, SLOT(update())); // 连接update()函数，每16ms触发一次update()函数进行重新绘图  
}


/*###################################################
##  函数: ~MyGLWidget
##  函数描述： ~MyGLWidget类的析构函数，删除timer
##  参数描述： 无
#####################################################*/
MyGLWidget::~MyGLWidget()
{
	delete this->timer;
}


/*###################################################
##  函数: initializeGL
##  函数描述： 初始化绘图参数，如视窗大小、背景色等
##  参数描述： 无
#####################################################*/
void MyGLWidget::initializeGL()
{
	glViewport(0, 0, width(), height());  
    glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
    glEnable(GL_DEPTH_TEST);
    glShadeModel(GL_SMOOTH);

    GLfloat ambient[] = {0.2f, 0.2f, 0.2f, 1.0f};
    GLfloat diffuse[] = {1.0f, 1.0f, 1.0f, 1.0f};
    GLfloat specular[] = {1.0f, 1.0f, 1.0f, 1.0f};
    GLfloat light_pos[] = {1.0f, 1.0f, 1.0f, 0.0f};
    glLightfv(GL_LIGHT0, GL_POSITION, light_pos);
    glLightfv(GL_LIGHT0, GL_AMBIENT, ambient);
    glLightfv(GL_LIGHT0, GL_DIFFUSE, diffuse);
    glLightfv(GL_LIGHT0, GL_SPECULAR, specular);
    glEnable(GL_LIGHTING);
    glEnable(GL_LIGHT0);

    glEnable(GL_COLOR_MATERIAL);
    GLfloat mat_ambient[] = {0.8f, 0.8f, 0.8f, 1.0f};
    GLfloat mat_diffuse[] = {0.8f, 0.8f, 0.8f, 1.0f};
    GLfloat mat_specular[] = {1.0f, 1.0f, 1.0f, 1.0f};
    GLfloat mat_shininess[] = {5.0f};

    glMaterialfv(GL_FRONT, GL_AMBIENT, mat_ambient);
    glMaterialfv(GL_FRONT, GL_DIFFUSE, mat_diffuse);
    glMaterialfv(GL_FRONT, GL_SPECULAR, mat_specular);
    glMaterialfv(GL_FRONT, GL_SHININESS, mat_shininess);
    glDepthFunc(GL_LESS);
}


/*###################################################
##  函数: paintGL
##  函数描述： 绘图函数，实现图形绘制，会被update()函数调用
##  参数描述： 无
#####################################################*/
void MyGLWidget::paintGL()
{
    glClear(GL_COLOR_BUFFER_BIT);
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    gluPerspective(65, width()/height(), 1, 400);

    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    gluLookAt(0, 28, 110, 0, 28, 0, 0, 1, 0);

//    cur_x += x_movement * step;
//    cur_z += z_movement * step;

//    gluLookAt(0, 40, 100, double(cur_x), 28, double(cur_z), 0, 1, 0);

//    glColor3f(0.0f, 0.0f, 0.0f);
//    glBegin(GL_LINE_LOOP);
//    glVertex3f(-100.0f, 0.0f, -50.0f);
//    glVertex3f(-100.0f, 0.0f, 50.0f);
//    glVertex3f(100.0f, 0.0f, 50.0f);
//    glVertex3f(100.0f, 0.0f, -50.0f);
//    glEnd();

//    if (z_movement == 1 && cur_z >= bound_z)
//    {
//        x_movement = 1;
//        z_movement = 0;
//    }
//    if (x_movement == 1 && cur_x >= bound_x)
//    {
//        x_movement = 0;
//        z_movement = -1;
//    }
//    if (z_movement == -1 && cur_z <= -bound_z)
//    {
//        x_movement = -1;
//        z_movement = 0;
//    }
//    if (x_movement == -1 && cur_x <= -bound_x)
//    {
//        x_movement = 0;
//        z_movement = 1;
//    }

//    printf("cur_x: %f\n", cur_x);
//    printf("cur_z: %f\n", cur_z);
//    printf("x_movement: %d\n", x_movement);
//    printf("z_movement: %d\n", z_movement);

//    glTranslatef(cur_x, cur_y, cur_z);
//    if (x_movement == 1 && z_movement == 0)
//        glRotatef(90.0f, 0.0f, 1.0f, 0.0f);
//    else if (x_movement == 0 && z_movement == -1)
//        glRotatef(180.0f, 0.0f, 1.0f, 0.0f);
//    else if (x_movement == -1 && z_movement == 0)
//        glRotatef(270.0f, 0.0f, 1.0f, 0.0f);

    // 更新当前运动轨迹的参数即角度theta
    cur_angle = (cur_angle + step)>359?0:(cur_angle + step);
    // 计算坐标
    double theta = 2 * PI * cur_angle / 360;
    cur_x = 4 * 16 * pow(sin(theta), 3);
    cur_z = 4 * (-13*cos(theta) + 5*cos(2*theta) + 2*cos(3*theta) + cos(4*theta));

    // 画路径
    draw_path();

    // 将机器人移动当前运动到坐标
    glTranslated(cur_x, cur_y, cur_z);

    // 调整朝向
    double dx = 4 * 16 * 3 * pow(sin(theta), 2) * cos(theta) * PI / 180;
    double dy = 4 * (13*sin(theta) - 10*sin(2*theta) - 6*sin(3*theta) - 4*sin(4*theta)) * PI / 180;
    // 爱心中轴两点
    if (fabs(dx) < 1e-3 && fabs(dy) < 1e-3)
    {
        if (int(cur_angle) == 0)
            glRotatef(90, 0, 1, 0);
        else
            glRotatef(-90, 0, 1, 0);
    }
    // 爱心两个z轴坐标最小的两个点
    else if (fabs(dy) < 1e-3)
        glRotated(90, 0, 1, 0);
    // 爱心最两边的两个点
    else if (fabs(dx) < 1e-3)
    {
        if (int(cur_angle) == 270)
            glRotated(180, 0, 1, 0);
    }
    else
    {
        if ((int(cur_angle) > 0 && int(cur_angle) < 90) ||
                ((int(cur_angle) > 270 && int(cur_angle) < 360)))
        {
            if (dx * dy < 0)
                glRotated(atan(dx/dy) * 180 / PI + 180, 0, 1, 0);
            else
                glRotated(atan(dx/dy) * 180 / PI, 0, 1, 0);
        }
        else if ((int(cur_angle) > 90 && int(cur_angle) < 180))
            glRotated(atan(dx/dy) * 180 / PI, 0, 1, 0);
        else
            glRotated(atan(dx/dy) * 180 / PI - 180, 0, 1, 0);
    }

    // 画头
    glPushMatrix();
    glTranslatef(0.0f, 26.0f, 0.0f);
    draw_head();
    glPopMatrix();

    // 画躯干
    glPushMatrix();
    glTranslatef(0.0f, 19.0f, 0.0f);
    draw_body();
    glPopMatrix();

    // 画左手
    glPushMatrix();
    glTranslatef(4.0f, 18.0f, 0.0f);
    // 往前摆臂到最大角度，开始往后
    if (left_arm_state == 1 && left_arm_angle >= max_arm_angle)
        left_arm_state = -1;
    // 往后摆臂到最大角度，开始往前
    if (left_arm_state == -1 && left_arm_angle <= -max_arm_angle)
        left_arm_state = 1;
    // 更新摆的角度
    left_arm_angle += left_arm_state * per_arm_angle;
    // 旋转
    glTranslatef(0.0f, 6.0f, 0.0f);
    glRotatef(left_arm_angle, 1.0f, 0.0f, 0.0f);
    glTranslatef(0.0f, -6.0f, 0.0f);
    glColor3f(1.0f, 0.0f, 0.0f);
    draw_arm();
    glPopMatrix();

    // 画右手
    glPushMatrix();
    glTranslatef(-4.0f, 18.0f, 0.0f);
    // 往前摆臂到最大角度，开始往后
    if (right_arm_state == 1 && right_arm_angle >= max_arm_angle)
        right_arm_state = -1;
    // 往后摆臂到最大角度，开始往前
    if (right_arm_state == -1 && right_arm_angle <= -max_arm_angle)
        right_arm_state = 1;
    // 更新摆的角度
    right_arm_angle += right_arm_state * per_arm_angle;
    // 旋转
    glTranslatef(0.0f, 6.0f, 0.0f);
    glRotatef(right_arm_angle, 1.0f, 0.0f, 0.0f);
    glTranslatef(0.0f, -6.0f, 0.0f);
    glColor3f(0.0f, 0.0f, 1.0f);
    draw_arm();
    glPopMatrix();

    // 画左腿
    glPushMatrix();
    glTranslatef(2.0f, 7.0f, 0.0f);
    // 往前抬腿到最大角度，开始往后
    if (left_leg_state == 1 && left_leg_angle >= max_leg_angle)
        left_leg_state = -1;
    // 往后抬腿到最大角度，开始往前
    if (left_leg_state == -1 && left_leg_angle <= -max_leg_angle)
        left_leg_state = 1;
    // 更新抬的角度
    left_leg_angle += left_leg_state * per_leg_angle;
    // 旋转
    glTranslatef(0.0f, 7.0f, 0.0f);
    glRotatef(left_leg_angle, 1.0f, 0.0f, 0.0f);
    glTranslatef(0.0f, -7.0f, 0.0f);
    glColor3f(0.0f, 0.0f, 1.0f);
    draw_leg();
    glPopMatrix();

    // 画右腿
    glPushMatrix();
    glTranslatef(-2.0f, 7.0f, 0.0f);
    // 往前抬腿到最大角度，开始往后
    if (right_leg_state == 1 && right_leg_angle >= max_leg_angle)
        right_leg_state = -1;
    // 往后抬腿到最大角度，开始往前
    if (right_leg_state == -1 && right_leg_angle <= -max_leg_angle)
        right_leg_state = 1;
    // 更新抬的角度
    right_leg_angle += right_leg_state * per_leg_angle;
    // 旋转
    glTranslatef(0.0f, 7.0f, 0.0f);
    glRotatef(right_leg_angle, 1.0f, 0.0f, 0.0f);
    glTranslatef(0.0f, -7.0f, 0.0f);
    glColor3f(1.0f, 0.0f, 0.0f);
    draw_leg();
    glPopMatrix();

    //    printf("dx: %f\n", dx);
    //    printf("dy: %f\n", dy);
    //    printf("cur_angle: %f\n", cur_angle);
    //    printf("%f\n\n", atan(dy/(dx+0.001)));
}


/*###################################################
##  函数: resizeGL
##  函数描述： 当窗口大小改变时调整视窗尺寸
##  参数描述： 无
#####################################################*/
void MyGLWidget::resizeGL(int width, int height)
{
	glViewport(0, 0, width, height);
	update();
}

/*###################################################
##  函数: draw_cube
##  函数描述： 绘制中心在原点，边长为2的正方体
##  参数描述： 无
#####################################################*/
void draw_cube()
{
    glPushMatrix();
    glBegin(GL_POLYGON);
    // 正面
    glVertex3f(1.0f, 1.0f, 1.0f);
    glVertex3f(-1.0f, 1.0f, 1.0f);
    glVertex3f(-1.0f, -1.0f, 1.0f);
    glVertex3f(1.0f, -1.0f, 1.0f);
    // 后面
    glVertex3f(1.0f, 1.0f, -1.0f);
    glVertex3f(-1.0f, 1.0f, -1.0f);
    glVertex3f(-1.0f, -1.0f, -1.0f);
    glVertex3f(1.0f, -1.0f, -1.0f);
    // 上面
    glVertex3f(1.0f, 1.0f, 1.0f);
    glVertex3f(1.0f, 1.0f, -1.0f);
    glVertex3f(-1.0f, 1.0f, -1.0f);
    glVertex3f(-1.0f, 1.0f, 1.0f);
    // 下面
    glVertex3f(1.0f, -1.0f, 1.0f);
    glVertex3f(1.0f, -1.0f, -1.0f);
    glVertex3f(-1.0f, -1.0f, -1.0f);
    glVertex3f(-1.0f, -1.0f, 1.0f);
    // 右面
    glVertex3f(1.0f, 1.0f, 1.0f);
    glVertex3f(1.0f, 1.0f, -1.0f);
    glVertex3f(1.0f, -1.0f, -1.0f);
    glVertex3f(1.0f, -1.0f, 1.0f);
    // 左面
    glVertex3f(-1.0f, 1.0f, 1.0f);
    glVertex3f(-1.0f, 1.0f, -1.0f);
    glVertex3f(-1.0f, -1.0f, -1.0f);
    glVertex3f(-1.0f, -1.0f, 1.0f);
    glEnd();
    glPopMatrix();
}

/*###################################################
##  函数: draw_head
##  函数描述： 绘制头部正方体
##  参数描述： 无
#####################################################*/
void draw_head()
{
    glPushMatrix();
    // 颜色
    glColor3f(0.0f, 1.0f, 0.0f);
    // 放大比例
    glScalef(2.0f, 2.0f, 2.0f);
    draw_cube();
    glPopMatrix();
}

/*###################################################
##  函数: draw_body
##  函数描述： 绘制躯干部正方体
##  参数描述： 无
#####################################################*/
void draw_body()
{
    glPushMatrix();
    // 颜色
    glColor3f(1.0f, 1.0f, 1.0f);
    // 放大比例
    glScalef(3.0f, 5.0f, 2.0f);
    draw_cube();
    glPopMatrix();
}

/*###################################################
##  函数: draw_arm
##  函数描述： 绘制手臂正方体
##  参数描述： 无
#####################################################*/
void draw_arm()
{
    glPushMatrix();
    //glColor3f(1.0f, 0.84f, 0.0f);
    // 放大比例
    glScalef(1.0f, 6.0f, 1.0f);
    draw_cube();
    glPopMatrix();
}

/*###################################################
##  函数: draw_leg
##  函数描述： 绘制腿部正方体
##  参数描述： 无
#####################################################*/
void draw_leg()
{
    glPushMatrix();
    //glColor3f(0.0f, 0.0f, 1.0f);
    // 放大比例
    glScalef(1.0f, 7.0f, 1.0f);
    draw_cube();
    glPopMatrix();
}

/*###################################################
##  函数: draw_path
##  函数描述： 画心形路径
##  参数描述： 无
#####################################################*/
void draw_path()
{
    glColor3f(1.0f, 0.0f, 0.0f);
    glBegin(GL_POLYGON);
    for (int i=0; i<360; ++i)
    {
        double theta = 2 * PI * i / 360;
        glVertex3d(4 * 16 * pow(sin(theta), 3), 0, 4 * (-13*cos(theta) + 5*cos(2*theta)
                                                           + 2*cos(3*theta) + cos(4*theta)));
    }
    glEnd();
}
