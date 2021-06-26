# import operator
import copy
import matplotlib.pyplot as plt
import numpy as np
import time

MAZE_PATH = 'MazeData.txt'


class Point:
    def __init__(self, pos, front_p, g, f):
        self.pos = pos                      # 节点的坐标
        self.front_p = front_p              # 父节点的坐标
        self.g = g                          # 到达该节点的实际代价
        self.f = f                          # 到达目标节点的估计代价

    def get_pos(self):                      # 返回节点的坐标
        return self.pos

    def get_front(self):                    # 返回父节点的坐标
        return self.front_p

    def get_g(self):                        # 返回到达该节点的实际代价
        return self.g

    def get_f(self):                        # 返回到达目标节点的估计代价
        return self.f


def read_maze(path):
    maze = []
    with open(path, 'r') as f:
        lines = f.readlines()
        for i in range(len(lines)):
            row = []
            line = lines[i].split()[0]
            for j in range(len(line)):
                if line[j] == 'S':           # 如果是起点，记录下来，并将该位置的标签置为'0'
                    start = (i, j)
                    row.append('0')
                elif line[j] == 'E':         # 如果是终点，记录下来，并将该位置的标签置为'0'
                    end = (i, j)
                    row.append('0')
                else:
                    row.append(line[j])
            maze.append(row)
    return start, end, maze


def DFS(point, end, maze, record_mat, bound, best_path):
    '''
    :param point: current node, object of class Point
    :param end: position of object node (x, y)
    :param maze: m x n matrix, 0 denotes no obstacle, 1 denotes obstacle
    :param record_mat: m x n matrix, record_mat[x][y] = (-1, -1) represents (x, y) hasn't been explored, otherwise
                       represents the position of father node of node (x, y)
    :param bound: limitation of depth-first search
    :param best_path: best_path[0] is the length of shortest path, best_path[1] is the record_mat of shortest path
    :return:
    '''
    if point.get_f() > bound:               # 当前节点的h值超过限制的h值，返回0
        return 0, point.get_f()-bound

    x, y = point.get_pos()                  # 获得当前节点的坐标
    record_mat[x][y] = point.get_front()    # 记录当前节点的父节点的坐标
    if (x, y) == end:                       # 找到目标节点
        if point.get_g() < best_path[0]:    # 如果代价小于之前找到的
            best_path[0] = point.get_g()    # 更新最优路径的代价
            best_path[1] = copy.deepcopy(record_mat)    # 更新最优路径的record_mat
        return 1, None

    m = len(maze)                           # 迷宫的行数
    n = len(maze[0])                        # 迷宫的列数
    next_point = []                         # 符合限制的四邻域的节点
    if x > 0 and maze[x-1][y] == '0' and record_mat[x-1][y] == (-1, -1):
        f = point.get_g() + 1 + abs(x-1-end[0]) + abs(y-end[1])
        next_point.append(Point((x-1, y), (x, y), point.get_g()+1, f))
    if y > 0 and maze[x][y-1] == '0' and record_mat[x][y-1] == (-1, -1):
        f = point.get_g() + 1 + abs(x-end[0]) + abs(y-1-end[1])
        next_point.append(Point((x, y-1), (x, y), point.get_g() + 1, f))
    if x < m-1 and maze[x+1][y] == '0' and record_mat[x+1][y] == (-1, -1):
        f = point.get_g() + 1 + abs(x+1-end[0]) + abs(y-end[1])
        next_point.append(Point((x+1, y), (x, y), point.get_g() + 1, f))
    if y < n-1 and maze[x][y+1] == '0' and record_mat[x][y+1] == (-1, -1):
        f = point.get_g() + 1 + abs(x-end[0]) + abs(y+1-end[1])
        next_point.append(Point((x, y+1), (x, y), point.get_g() + 1, f))

    if len(next_point) == 0:            # 没有可扩展的节点，说明这条路径不行
        return -1, None
    # cmpfun = operator.attrgetter('h')
    # next_point.sort(key=cmpfun)
    res = -1
    value = 100
    for i in range(len(next_point)):    # 遍历所有四周可能的节点
        r, v = DFS(next_point[i], end, maze, record_mat, bound, best_path)
        res = max(res, r)
        if res == 0 and r == 0:         # 更新下次应当增加的Δbound
            value = min(value, v)
        x, y = next_point[i].get_pos()
        record_mat[x][y] = (-1, -1)     # 恢复
    return res, value


def IDA(start, end, maze):
    '''
    :param start: (x, y) represents the start point
    :param end: (x, y) represents the end point
    :param maze: m x n matrix, 0 denotes no obstacle, 1 denotes obstacle
    :return: whether have a path from start point to end point
    '''
    m = len(maze)               # 迷宫的行数
    n = len(maze[0])            # 迷宫的列数

    bound = 10                  # 深搜的阈值
    while True:
        # record_mat[x][y]记录(x, y)的父节点，如果为(-1, -1)，说明(x, y)还没有被扩展
        record_mat = [[(-1, -1) for j in range(n)] for i in range(m)]
        point = Point(start, start, 0, 0)       # 创建包含起点信息的点对象
        best_path = [1000, []]                  # best_path[0]表示最短距离，best_path[1]储存最短路径下的record_mat
        res = DFS(point, end, maze, record_mat, bound, best_path)   # 给定一定的阈值深搜
        if res[0] == 1:                            # 找到最优路径
            break
        elif res[0] == -1:                         # 无法到达终点
            return 0
        else:                                   # 可能阈值太小，无法到达终点
            # print(res[1])
            bound += res[1]

    # 通过best_path中的record_mat倒着找路径
    x, y = end
    while True:
        f_x, f_y = best_path[1][x][y]
        if (f_x, f_y) == start:
            break
        maze[f_x][f_y] = '2'                    # 标记路径
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

    # # 写文件
    # with open('answer_2.txt', 'w') as f:
    #     for row in maze:
    #         f.write(''.join(row) + '\n')

    return True


if __name__ == '__main__':
    # begin_time = time.time()
    start, end, maze = read_maze(MAZE_PATH)
    if IDA(start, end, maze):
        print('FIND A PATH SUCCESSFULLY!')
    else:
        print('UNABLE TO FIND A PATH!')
    # end_time = time.time()
    # print('花费时间', end_time-begin_time)