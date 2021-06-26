import matplotlib.pyplot as plt
import numpy as np
import time

MAZE_PATH = 'MazeData.txt'


class Point:
    def __init__(self, pos, front_p, cost=1):
        self.pos = pos                          # 节点坐标
        self.front_p = front_p                  # 父节点坐标
        self.cost = cost                        # 到达的代价

    def get_pos(self):                          # 返回节点坐标
        return self.pos

    def get_front(self):                        # 返回父节点坐标
        return self.front_p

    def get_cost(self):                         # 返回到达的代价
        return self.cost


class Priority_Queue:
    def __init__(self):
        self.queue = []                         # 储存队列
        self.len = 0                            # 队列长度

    def empty(self):
        return self.len == 0                    # 返回队列是否为空，空返回True，非空返回False

    def top(self):                              # 如果队列不空，返回队头的节点
        if not self.empty():
            return self.queue[0]
        return None

    def insert(self, point):                    # 将节点插入队列
        index = 0                               # 插入的位置
        for i in range(self.len):
            if self.queue[i].get_cost() > point.get_cost():
                index = i
                break
            else:
                index = i + 1
        self.queue.insert(index, point)
        self.len += 1

    def pop(self):                              # 删除队头的节点
        if not self.empty():
            del(self.queue[0])
            self.len -= 1


def read_maze(path):
    '''
    :param path: the path of file which records the information of maze
    :return: the start point (x, y), the end point (x, y), the maze m x n matrix
    '''
    maze = []
    with open(path, 'r') as f:
        lines = f.readlines()
        for i in range(len(lines)):
            row = []
            line = lines[i].split()[0]
            for j in range(len(line)):
                if line[j] == 'S':              # 如果是起点，记录下来，并将该位置的标签置为'0'
                    start = (i, j)
                    row.append('0')
                elif line[j] == 'E':            # 如果是终点，记录下来，并将该位置的标签置为'0'
                    end = (i, j)
                    row.append('0')
                else:
                    row.append(line[j])
            maze.append(row)
    return start, end, maze


def UCS(start, end, maze):
    '''
    :param start: (x, y) represents the start point
    :param end: (x, y) represents the end point
    :param maze: m x n matrix, 0 denotes no obstacle, 1 denotes obstacle
    :return: whether have a path from start point to end point
    '''
    m = len(maze)           # 迷宫的行数
    n = len(maze[0])        # 迷宫的列数

    # record_mat[x][y]记录(x, y)的父节点，如果为(-1, -1)，说明(x, y)还没有被扩展
    record_mat = [[(-1, -1) for j in range(n)] for i in range(m)]
    q = Priority_Queue()                # 创建一个优先队列的对象
    p = Point(start, start, 0)          # 创建一个点的对象，该对象记录了起点的信息
    q.insert(p)

    while True:
        if q.empty():
            # 队列中没有可以扩展的节点，则找不到一条从起点到终点的路径，通过文件写，画出走过的点
            with open('fail.txt', 'w') as f:
                for i in range(m):
                    for j in range(n):
                        if record_mat[i][j] != (-1, -1):
                            f.write('2')
                        else:
                            f.write(str(maze[i][j]))
                    f.write('\n')
            return False

        t = q.top()         # 取出队列中代价最小的节点
        q.pop()             # 删除该节点

        x, y = t.get_pos()  # 得到该节点的坐标
        if record_mat[x][y] != (-1, -1):    # 该节点已被扩展
            continue
        record_mat[x][y] = t.get_front()    # 记录该节点的父节点坐标

        if (x, y) == end:                   # 到达终点
            break

        # 将该节点的四邻域的符合条件的节点加入队列，条件为：
        # 1. 没有越界
        # 2. 没有障碍
        # 3. 没有被扩展过
        if x > 0 and maze[x-1][y] != '1' and record_mat[x-1][y] == (-1, -1):
            q.insert(Point((x-1, y), (x, y), t.get_cost()+1))
        if y > 0 and maze[x][y-1] != '1' and record_mat[x][y-1] == (-1, -1):
            q.insert(Point((x, y-1), (x, y), t.get_cost()+1))
        if x < m-1 and maze[x+1][y] != '1' and record_mat[x+1][y] == (-1, -1):
            q.insert(Point((x+1, y), (x, y), t.get_cost()+1))
        if y < n-1 and maze[x][y+1] != '1' and record_mat[x][y+1] == (-1, -1):
            q.insert(Point((x, y+1), (x, y), t.get_cost()+1))

    # 通过record_mat倒着找路径
    x, y = end
    while True:
        f_x, f_y = record_mat[x][y]
        if (f_x, f_y) == start:
            break
        maze[f_x][f_y] = '2'            # 标记
        x, y = f_x, f_y
    maze[start[0]][start[1]] = '2'
    maze[end[0]][end[1]] = '2'
    # maze[start[0]][start[1]] = 'S'
    # maze[end[0]][end[1]] = 'E'

    data1 = []
    data2 = []
    data3 = []
    for i in range(m):
        for j in range(n):
            if maze[i][j] == '1':
                data1.append([m-1-i, j])
            elif maze[i][j] == '0':
                data2.append([m-1-i, j])
            else:
                data3.append([m-1-i, j])
    data1 = np.array(data1)
    data2 = np.array(data2)
    data3 = np.array(data3)
    plt.scatter(data1[:, 1], data1[:, 0], s=50, marker='s', c='k')
    plt.scatter(data2[:, 1], data2[:, 0], s=50, marker='s', c='w')
    plt.scatter(data3[:, 1], data3[:, 0], s=50, marker='s', c='r')
    plt.xticks([])
    plt.yticks([])
    plt.show()

    # 写文件
    # with open('answer_1.txt', 'w') as f:
    #     for row in maze:
    #         f.write(''.join(row) + '\n')

    return True


if __name__ == '__main__':
    # begin_time = time.time()
    start, end, maze = read_maze(MAZE_PATH)
    if UCS(start, end, maze):
        print('FIND A PATH SUCCESSFULLY!')
    else:
        print('UNABLE TO FIND A PATH!')
    # end_time = time.time()
    # print('花费时间: ', end_time - begin_time)