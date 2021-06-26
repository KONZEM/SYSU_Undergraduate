#include "myglwidget.h"
//void print(float mat[16])
//{
//    for (int i=0; i<4; ++i)
//    {
//        for (int j=i; j<=i+12; j+=4)
//            printf("%.2f ", mat[j]);
//        printf("\n");
//    }
//    printf("\n");
//}

void myswap(int& a, int& b)
{
    int t = a;
    a = b;
    b = t;
}

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
    glEnable(GL_BLEND);
	glDisable(GL_DEPTH_TEST);
    //glBlendFunc(GL_SRC_ALPHA,GL_ONE);
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
    glOrtho(0.0, 100.0, 0.0, 100.0, -1000.0, 1000.0);

	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
    glTranslatef(50.0f, 50.0f, 0.0f);
	
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
    glOrtho(0.0, width(), 0.0, height(), -1000.0, 1000.0);

    glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();

    // 定义点
    vector<vector<float>> triangle = {{10.0, 10.0, 0.0, 1.0},
                                      {50.0, 50.0, 0.0, 1.0},
                                      {80.0, 10.0, 0.0, 1.0}};
    // 定义颜色
    vector<float> color1 = {0.839f, 0.153f, 0.157f};
    // 平移
    translate(triangle, -50.0f, -30.0f, 0.0f);
    // 旋转
    //rotate(triangle, 45.0f, 1.0f, 0.0f, 1.0f);
    rotate_2(triangle, 45.0f, 1.0f, 0.0f, 1.0f);
    // 平移
    translate(triangle, -20.0f, -10.0f, 0.0f);
    translate(triangle, 50.0f, 50.0f, 0.0f);
    // 为了使点更密集，看的窗口为(width, height)，则将点坐标乘上相应倍数，等同于增加分辨率
    for (unsigned i=0; i<3; ++i)
    {
        triangle[i][0] *= width()/100.0f;
        triangle[i][1] *= height()/100.0f;
    }
    // 画线
    glBegin(GL_POINTS);
    //glColor3f(0.839f, 0.153f, 0.157f);
    drawline(int(round(triangle[0][0])), int(round(triangle[0][1])),
             int(round(triangle[1][0])), int(round(triangle[1][1])), color1);
    drawline(int(round(triangle[0][0])), int(round(triangle[0][1])),
             int(round(triangle[2][0])), int(round(triangle[2][1])), color1);
    drawline(int(round(triangle[1][0])), int(round(triangle[1][1])),
             int(round(triangle[2][0])), int(round(triangle[2][1])), color1);
    glEnd();

    vector<vector<float>> quad = {{-20.0, -20.0, 0.0, 1.0},
                                  {20.0, -20.0, 0.0, 1.0},
                                  {20.0, 20.0, 0.0, 1.0},
                                  {-20.0, 20.0, 0.0, 1.0}};
    vector<float> color2 = {0.122f, 0.467f, 0.706f};
    //rotate(quad, 30.0f, 1.0f, 1.0f, 1.0f);
    rotate_2(quad, 30.0f, 1.0f, 1.0f, 1.0f);
    translate(quad, 20.0f, 20.0f, 0.0f);
    translate(quad, 50.0f, 50.0f, 0.0f);
    //translate(quad, 20.0f, 20.0f, 0.0f);
    //rotate_2(quad, 30.0f, 1.0f, 1.0f, 1.0f);
    for (unsigned i=0; i<4; ++i)
    {
        quad[i][0] *= width()/100.0f;
        quad[i][1] *= height()/100.0f;
    }
    glBegin(GL_POINTS);
    //glColor3f(0.122f, 0.467f, 0.706f);
    drawline(int(round(quad[0][0])), int(round(quad[0][1])),
             int(round(quad[1][0])), int(round(quad[1][1])), color2);
    drawline(int(round(quad[1][0])), int(round(quad[1][1])),
             int(round(quad[2][0])), int(round(quad[2][1])), color2);
    drawline(int(round(quad[2][0])), int(round(quad[2][1])),
             int(round(quad[3][0])), int(round(quad[3][1])), color2);
    drawline(int(round(quad[3][0])), int(round(quad[3][1])),
             int(round(quad[0][0])), int(round(quad[0][1])), color2);
    glEnd();
}
//    float mat1[16];
//    float mat2[16];
//    glColor3f(0.0f, 0.0f, 1.0f);
//    glPushMatrix();
//    glGetFloatv(GL_MODELVIEW_MATRIX, mat1);
//    glGetFloatv(GL_MODELVIEW_MATRIX, mat2);
//    print(mat2);
//    glRotatef(45.0f, 1.0f, 0.0f, 1.0f);
//    glGetFloatv(GL_MODELVIEW_MATRIX, mat1);
//    print(mat1);
//    glBegin(GL_LINE_LOOP);
//    glVertex2f(10.0f, 10.0f);
//    glVertex2f(50.0f, 10.0f);
//    glEnd();
//    glPopMatrix();


/*
###############################################################
##  函数：anti_alias
##  函数描述：利用重采样的方法抗锯齿
##  ###########################################################
##  参数描述：
##  line_x ———— 光栅化后直线上的点的x轴坐标
##  line_y ———— 光栅化后直线上的点的y轴坐标
##  color ———— 画线的颜色
##  mode ———— mode为0表示以x轴自增，为1表示以y轴自增
###############################################################
*/
void anti_alias(vector<int> line_x, vector<int> line_y, vector<float> color, int mode)
{
    // 调出一种较color更浅的颜色
    vector<float> n_color(color);
    unsigned long long max_pos = 0;
    for (unsigned long long i=1; i<3; ++i)
    {
        if (color[i] > color[max_pos])
        {
            max_pos = i;
            n_color[max_pos] *= 1.1f;
        }
        else
            n_color[i] *= 1.1f;
    }
    // 抗锯齿
    unsigned long long l = line_x.size();
    if (mode == 0)
    {
        for (unsigned long long i=0; i<l;)
        {
            // 当前的点位于奇数x轴坐标，不会与下个点在同个像素块
            if ((line_x[i] % 2 == 1) || (i == l-1))
            {
                glColor3f(n_color[0], n_color[1], n_color[2]);
                glVertex2i(line_x[i]/2, line_y[i]/2);
                ++i;
            }
            else
            {
                // 下个点与当前点在同个像素块
                if ((line_y[i]==line_y[i+1]) || ((line_y[i]-line_y[i+1]==1)&&(line_y[i]%2==1))
                        || ((line_y[i+1]-line_y[i]==1)&&(line_y[i]%2==0)))
                {
                    glColor3f(color[0], color[1], color[2]);
                    glVertex2i(line_x[i]/2, line_y[i]/2);
                    i += 2;
                }
                // 因为y轴坐标，下个点与当前点不在同个像素块
                else
                {
                    glColor3f(n_color[0], n_color[1], n_color[2]);
                    glVertex2i(line_x[i]/2, line_y[i]/2);
                    ++i;
                }
            }
        }
    }
    else
    {
        for (unsigned long long i=0; i<l;)
        {
            if ((line_y[i] % 2 == 1) || (i == l-1))
            {
                glColor3f(n_color[0], n_color[1], n_color[2]);
                glVertex2i(line_x[i]/2, line_y[i]/2);
                ++i;
            }
            else
            {
                if ((line_x[i]==line_x[i+1]) || ((line_x[i]-line_x[i+1]==1)&&(line_x[i]%2==1))
                        || ((line_x[i+1]-line_x[i]==1)&&(line_x[i]%2==0)))
                {
                    glColor3f(n_color[0], n_color[1], n_color[2]);
                    glVertex2i(line_x[i]/2, line_y[i]/2);
                    i += 2;
                }
                else
                {
                    glColor3f(n_color[0], n_color[1], n_color[2]);
                    glVertex2i(line_x[i]/2, line_y[i]/2);
                    ++i;
                }
            }
        }
    }
}

/*
###############################################################
##  函数：rasterize
##  函数描述：使用光栅化算法算出最靠近线的整数坐标
##  ###########################################################
##  参数描述：
##  (x1, y1) ———— 第一个点的坐标
##  (x2, y2) ———— 第二个点的坐标
##  mode ———— 0代表斜率在0到1之间，1代表斜率在-1到0之间，2代表斜率大于1，3代表斜率小于-1
##  line_x ———— 记录整数坐标的x坐标
##  line_y ———— 记录整数坐标的y坐标
###############################################################
*/
void rasterize(int x1, int y1, int x2, int y2, int mode, vector<int>& line_x,
               vector<int>& line_y)
{
    int dx = x2 - x1;
    int dy = y2 - y1;
    int y = y1;
    int p;
    // 斜率在0到1之间
    if (mode == 0 || mode == 2)
        p = 2 * dy - dx;
    // 斜率在-1到0之间
    else
        p = 2 * dy + dx;
    for (int i=x1+1; i<x2; ++i)
    {
        // 取lower点
        if (p < 0)
        {
            if (mode == 0 || mode == 2)
            {
                p += 2 * dy;
                if (mode == 0)
                {
                    //glVertex2i(i, y);
                    line_x.push_back(i);
                    line_y.push_back(y);
                }
                // x轴与y轴交换回来
                else
                {
                    //glVertex2i(y, i);
                    line_x.push_back(y);
                    line_y.push_back(i);
                }
            }
            else
            {
                p += 2 * dy + 2 * dx;
                y = y - 1;
                if (mode == 1)
                {
                    //glVertex2i(i, y);
                    line_x.push_back(i);
                    line_y.push_back(y);
                }
                // x轴与y轴交换回来
                else
                {
                    //glVertex2i(y, i);
                    line_x.push_back(y);
                    line_y.push_back(i);
                }
            }
        }
        // 取upper点
        else
        {
            if (mode == 0 || mode == 2)
            {
                p += 2 * dy - 2 * dx;
                y = y + 1;
                if (mode == 0)
                {
                    //glVertex2i(i, y);
                    line_x.push_back(i);
                    line_y.push_back(y);
                }
                // x轴与y轴交换回来
                else
                {
                    //glVertex2i(y, i);
                    line_x.push_back(y);
                    line_y.push_back(i);
                }
            }
            else
            {
                p += 2 * dy;
                if (mode == 1)
                {
                    //lVertex2i(i, y);
                    line_x.push_back(i);
                    line_y.push_back(y);
                }
                // x轴与y轴交换回来
                else
                {
                    //glVertex2i(y ,i);
                    line_x.push_back(y);
                    line_y.push_back(i);
                }
            }
        }
    }
}

/*
###############################################################
##  函数：draw_line
##  函数描述：使用光栅化算法画一条直线
##  ###########################################################
##  参数描述：
##  (x1, y1) ———— 第一个点的坐标
##  (x2, y2) ———— 第二个点的坐标
##  color ———— 画线的颜色
###############################################################
*/
void drawline(int x1, int y1, int x2, int y2, vector<float> color)
{
    // 平行于y轴
    if (x1 == x2)
    {
        if (y1 > y2)
            myswap(y1, y2);
        for (int i=y1; i<=y2; ++i)
            glVertex2i(x1, i);
    }
    // 平行于x轴
    else if (y1 == y2)
    {
        if (x1 > x2)
            myswap(x1, x2);
        for (int i=x1; i<=x2; ++i)
            glVertex2i(i, y1);
    }
    else
    {
        // 坐标x2相当于在分辨率x2的图上，方便之后抗锯齿的超采样
        int n_x1 = x1*2;
        int n_y1 = y1*2;
        int n_x2 = x2*2;
        int n_y2 = y2*2;
        // 记录在分辨率x2的图上采用光栅化算法后的坐标
        vector<int> line_x;
        vector<int> line_y;

        int dx = n_x2 - n_x1;
        int dy = n_y2 - n_y1;
        //double k = double(dy) / double(dx);
        // 斜率绝对值在0到1之间
        if (abs(dy) <= abs(dx))
        {
            // 使x1 < x2,统一从x1增加到x2
            if (dx < 0)
            {
                myswap(n_x1, n_x2);
                myswap(n_y1, n_y2);
            }
            line_x.push_back(n_x1);
            line_y.push_back(n_y1);
            // 斜率在0到1之间
            if (dy * dx > 0)
                rasterize(n_x1, n_y1, n_x2, n_y2, 0, line_x, line_y);
            // 斜率在-1到0之间
            else
                rasterize(n_x1, n_y1, n_x2, n_y2, 1, line_x, line_y);
            line_x.push_back(n_x2);
            line_y.push_back(n_y2);
            // 调用抗锯齿，以x方向自增
            anti_alias(line_x, line_y, color, 0);
        }
        // 斜率绝对值大于1
        else
        {
            // 交换坐标轴
            myswap(n_x1, n_y1);
            myswap(n_x2, n_y2);
            // 使y1 < y2,统一从y1增加到y2
            if (dy < 0)
            {
                myswap(n_x1, n_x2);
                myswap(n_y1, n_y2);
            }
            line_x.push_back(n_y1);
            line_y.push_back(n_x1);
            // 斜率大于1
            if (dy * dx > 0)
                rasterize(n_x1, n_y1, n_x2, n_y2, 2, line_x, line_y);
            // 斜率小于-1
            else
                rasterize(n_x1, n_y1, n_x2, n_y2, 3, line_x, line_y);
            line_x.push_back(n_y2);
            line_y.push_back(n_x2);
            // 调用抗锯齿，以y方向自增
            anti_alias(line_x, line_y, color, 1);
        }
    }
}

/*
###############################################################
##  函数：matrix_mul
##  函数描述：将3x4的矩阵乘上points中每个4维的点，并更新每个点的xyz坐标
##  ###########################################################
##  参数描述：
##  points ———— 包含n个4维的点
##  matrix ———— 一个3x4的变换矩阵
###############################################################
*/
void matrix_mul(vector<vector<float>>& points, float matrix[3][4])
{
    unsigned long long l = (points.size());
    for (unsigned long long i=0; i<l; ++i)
    {
        float xyz[3] = {0.0};
        for (unsigned long long j=0; j<3; ++j)
        {
            for (unsigned long long k=0; k<4; ++k)
                xyz[j] += matrix[j][k] * points[i][k];
        }
        for (unsigned long long j=0; j<3; ++j)
            points[i][j] = xyz[j];
    }
}

/*
###############################################################
##  函数：translate
##  函数描述：定义平移变换矩阵，并调用矩阵乘法函数更新点坐标
##  ###########################################################
##  参数描述：
##  points ———— 包含n个4维的点
##  mx ———— x方向平移的单位
##  my ———— y方向平移的单位
##  mz ———— z方向平移的单位
###############################################################
*/
void translate(vector<vector<float>>& points, float mx, float my, float mz)
{
    float matrix[3][4] = {{1, 0, 0, mx}, {0, 1, 0, my}, {0, 0, 1, mz}};
    matrix_mul(points, matrix);
}

/*
###############################################################
##  函数：rotate
##  函数描述：定义旋转变换矩阵，并调用矩阵乘法函数更新点坐标
##  ###########################################################
##  参数描述：
##  points ———— 包含n个4维的点
##  angle ———— 旋转角度
##  (a, b, c) ———— 旋转轴的向量
###############################################################
*/
void rotate(vector<vector<float>>& points, float angle, float a, float b, float c)
{
    // 单位向量！！！
    float length = float(sqrt(a*a+b*b+c*c));
    a /= length;
    b /= length;
    c /= length;
    float change = float(acos(-1)) / 180.0f;
    float sin_val = float(sin(angle * change));
    float cos_val = float(cos(angle * change));
    float matrix[3][4] = {{a*a*(1-cos_val)+cos_val, a*b*(1-cos_val)-c*sin_val, a*c*(1-cos_val)+b*sin_val, 0},
                          {a*b*(1-cos_val)+c*sin_val, b*b*(1-cos_val)+cos_val, b*c*(1-cos_val)-a*sin_val, 0},
                          {a*c*(1-cos_val)-b*sin_val, b*c*(1-cos_val)+a*sin_val, c*c*(1-cos_val)+cos_val, 0}};
    matrix_mul(points, matrix);
}

/*
###############################################################
##  函数：rotate_2
##  函数描述：定义旋转变换矩阵，并调用矩阵乘法函数更新点坐标
##  ###########################################################
##  参数描述：
##  points ———— 包含n个4维的点
##  angle ———— 旋转角度
##  (a, b, c) ———— 旋转轴的向量
###############################################################
*/
void rotate_2(vector<vector<float>>& points, float angle, float a, float b, float c)
{
    // 单位向量
    float length = float(sqrt(a*a+b*b+c*c));
    a /= length;
    b /= length;
    c /= length;
    float change = float(acos(-1)) / 180.0f;
    float sin_val = float(sin(angle / 2.0f * change));
    float cos_val = float(cos(angle / 2.0f * change));
    // 定义Q和Q的逆
    vector<float> Q = {a*sin_val, b*sin_val, c*sin_val, cos_val};
    vector<float> inv_Q = {-a*sin_val, -b*sin_val, -c*sin_val, cos_val};
    unsigned long long l = points.size();
    for (unsigned long long i=0; i<l; ++i)
    {
        // 将点表示为四元数
        vector<float> point(points[i]);
        point[3] = 0;
        // Qv
        vector<float> res = {0.0f, 0.0f, 0.0f, 0.0f};
        res[0] = Q[1]*point[2]-Q[2]*point[1]+Q[3]*point[0]+Q[0]*point[3];
        res[1] = Q[2]*point[0]-Q[0]*point[2]+Q[3]*point[1]+Q[1]*point[3];
        res[2] = Q[0]*point[1]-Q[1]*point[0]+Q[3]*point[2]+Q[2]*point[3];
        res[3] = Q[3]*point[3] - (Q[0]*point[0] + Q[1]*point[1] + Q[2]*point[2]);
        // Qvinv(Q)
        points[i][0] = res[1]*inv_Q[2]-res[2]*inv_Q[1]+res[3]*inv_Q[0]+res[0]*inv_Q[3];
        points[i][1] = res[2]*inv_Q[0]-res[0]*inv_Q[2]+res[3]*inv_Q[1]+res[1]*inv_Q[3];
        points[i][2] = res[0]*inv_Q[1]-res[1]*inv_Q[0]+res[3]*inv_Q[2]+res[2]*inv_Q[3];
    }
}
