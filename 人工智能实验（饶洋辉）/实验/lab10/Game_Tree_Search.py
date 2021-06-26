import pygame

N = 11                                          # 棋盘大小
Cell_Size = 60                                  # 每个方格的大小
Space = 80                                      # 空白处大小
Grid_Size = (N - 1) * Cell_Size + 2 * Space     # 整张图的大小
BLACK = (0, 0, 0)                               # 黑色RGB 先手的颜色
White = (255, 255, 255)                         # 白色RGB 后手的颜色


class UndefeatedAI:
    def __init__(self, man_first):
        '''
        :param man_first: True -> 人先手, False -> 人后手
        '''
        self.size = N                                   # 棋盘大小
        self.man_first = man_first                      # 是否人先手
        self.max_depth = 2                              # 搜索深度为 self.max_depth + 1
        self.all_chess = set()                          # 棋盘上所有位置
        self.chess_list = [[0] * N for _ in range(N)]   # 记录棋盘上下的子的情况
        self.shape2score = [((0, 1, 1, 0, 0), 50),      # 各个形状及其得分
                            ((0, 0, 1, 1, 0), 50),
                            ((1, 1, 0, 1, 0), 200),
                            ((0, 0, 1, 1, 1), 500),
                            ((1, 1, 1, 0, 0), 500),
                            ((0, 1, 1, 1, 0), 5000),
                            ((0, 1, 0, 1, 1, 0), 5000),
                            ((0, 1, 1, 0, 1, 0), 5000),
                            ((1, 1, 1, 0, 1), 5000),
                            ((1, 1, 0, 1, 1), 5000),
                            ((1, 0, 1, 1, 1), 5000),
                            ((1, 1, 1, 1, 0), 5000),
                            ((0, 1, 1, 1, 1), 5000),
                            ((0, 1, 1, 1, 1, 0), 50000),
                            ((1, 1, 1, 1, 1), 99999999)]

        # 初始化棋局
        if not man_first:                               # AI先手
            self.ai_chess = {(5, 5), (5, 6)}
            self.man_chess = {(5, 4), (6, 5)}
        else:
            self.ai_chess = {(5, 4), (6, 5)}
            self.man_chess = {(5, 5), (5, 6)}

        for i in range(self.size):
            for j in range(self.size):
                self.all_chess.add((i, j))

        # 1 代表先手即黑色子，2 代表后手即白子
        for each in self.ai_chess:
            if man_first:
                self.chess_list[each[0]][each[1]] = 2
            else:
                self.chess_list[each[0]][each[1]] = 1

        for each in self.man_chess:
            if man_first:
                self.chess_list[each[0]][each[1]] = 1
            else:
                self.chess_list[each[0]][each[1]] = 2

    def print_board(self):
        '''
        ###弃用###
        输出当前棋局情况
        '''
        board = [[' ' for j in range(self.size)] for i in range(self.size)]

        if self.man_first:
            for pos in self.man_chess:
                board[pos[0]][pos[1]] = 'x'
            for pos in self.ai_chess:
                board[pos[0]][pos[1]] = 'o'
        else:
            for pos in self.man_chess:
                board[pos[0]][pos[1]] = 'o'
            for pos in self.ai_chess:
                board[pos[0]][pos[1]] = 'x'

        for i in range(self.size):
            for j in range(self.size):
                print('----', end='')
            print('-')
            for j in range(self.size):
                print('| {} '.format(board[i][j]), end='')
            print('|', i)
        for j in range(self.size):
            print('----', end='')
        print('-')
        for j in range(self.size):
            print('  {} '.format(j), end='')
        print()
        print()

    def check(self, is_man, pos):
        '''
        :param is_man: True -> 人, False -> AI
        :param pos: 人或AI下的子的位置
        :return: True -> 获得胜利, False -> 没获得胜利
        '''
        # 获取该方的下的子
        if is_man:
            chess_list = self.man_chess
        else:
            chess_list = self.ai_chess

        # 检查四条直线的方向
        dirs = ((1, 0), (0, 1), (1, 1), (1, -1))
        for dir in dirs:
            chess_num1 = 0
            chess_num2 = 0
            # 一条直线的一个方向
            _pos = pos
            while ((_pos[0] - dir[0]), (_pos[1] - dir[1])) in chess_list:
                chess_num1 += 1
                _pos = (_pos[0] - dir[0]), (_pos[1] - dir[1])
            # 一条直线的另一个方向
            _pos = pos
            while ((_pos[0] + dir[0]), (_pos[1] + dir[1])) in chess_list:
                chess_num2 += 1
                _pos = (_pos[0] + dir[0]), (_pos[1] + dir[1])
            # 一条直线上有连续的4个子（除了当前下的）即为胜利
            if chess_num1 + chess_num2 >= 4:
                return True
        return False

    def get_empty_pos(self):
        '''
        获取当前的空位置
        '''
        return self.all_chess - self.ai_chess - self.man_chess

    def solitary(self, pos):
        '''
        :param pos: 在棋盘上的位置
        :return: True -> 孤立（直线距离2以内没子）, False -> 不孤立
        '''
        # 16个邻居
        dirs = ((-1, -1), (-1, 0), (0, -1), (1, 1), (1, 0), (0, 1), (1, -1), (-1, 1),
                (-2, -2), (-2, 0), (0, -2), (2, 2), (2, 0), (0, 2), (2, -2), (-2, 2))
        for dir in dirs:
            neighbor = (pos[0] + dir[0], pos[1] + dir[1])
            if (0 <= neighbor[0] < self.size and 0 <= neighbor[1] < self.size and
                (neighbor in self.ai_chess or neighbor in self.man_chess)):
                return False
        return True

    def cal_one_pos(self, is_man, pos, dir, chess_dir_score):
        '''
        :param is_man: True -> 人, False -> AI
        :param pos: 人或AI下的子的位置
        :param dir: 要算该方向上的得分
        :param chess_dir_score: 形式为(mpos, dir, score)
        :return: 人或AI在pos下子并在dir方向的得分
        '''
        # 获得我方下的子和对方下的子
        if is_man:
            my_chess = self.man_chess
            opponent_chess = self.ai_chess
        else:
            my_chess = self.ai_chess
            opponent_chess = self.man_chess

        # 该位置以及该方向是否已经计算过分数，若是直接返回0，避免重复加分
        for mpos, _dir, _ in chess_dir_score:
            for _pos in mpos:
                if _pos == pos and _dir == dir:
                    return 0

        pos_dir_max_score = [None, None, 0]     # 定义该位置以及该方向的最大得分情况(mpos, dir, score)
        plus = 0                                # 得分形状重合可以加分

        # 起始点为(pos[0] + i * dir[0], pos[1] + i * dir[1])
        for i in range(-5, 1):
            shape = []
            # 每次取6个子
            for j in range(6):
                px = pos[0] + (i + j) * dir[0]
                py = pos[1] + (i + j) * dir[1]
                if 0 <= px < self.size and 0 <= py < self.size:
                    if (px, py) in my_chess:
                        shape.append(1)
                    elif (px, py) in opponent_chess:
                        shape.append(2)
                    else:
                        shape.append(0)
                else:
                    continue

            if len(shape) < 5:          # 不足以凑够5个子
                continue
            elif len(shape) == 5:       # 不足以凑够6个子
                shape1 = tuple(shape)
                shape2 = None
            else:                       # 能凑够6个子
                shape1 = tuple(shape[:5])
                shape2 = tuple(shape)

            for _shape, _score in self.shape2score:
                if _shape == shape1 or _shape == shape2:        # 形状是否可以得分
                    if _score > pos_dir_max_score[2]:           # 更新该方向的最大得分情况
                        mpos = []                               # 能够得分的形状中包括的子的位置
                        for j in range(5):
                            mpos.append((pos[0] + (i + j) * dir[0], pos[1] + (i + j) * dir[1]))
                        pos_dir_max_score = [tuple(mpos), dir, _score]

        if pos_dir_max_score[2] != 0:
            # 得分形状相交可以加分
            for mpos1, _, score in chess_dir_score:
                mpos1 = set(mpos1)
                mpos2 = set(pos_dir_max_score[0])
                if mpos1.intersection(mpos2) != set() and pos_dir_max_score[2] > 10 and score > 10:
                    plus += (score + pos_dir_max_score[2]) // 2
            # 记录在该位置下子在该方向上能获取的最大得分
            chess_dir_score.append(pos_dir_max_score)

        # 返回得分情况
        return pos_dir_max_score[2] + plus

    def estimate(self):
        '''
        :return: 当前棋局得分为 人的得分 - Ai的得分 * ratio (0<ratio<1), ratio的意义在于让AI更注重防守
        '''
        # 每个子在每个方向上最大得分和
        ai_score = 0
        man_score = 0
        # 记录每个子在每个方向上的最大得分
        ai_chess_dir_score = []
        man_chess_dir_score = []
        # 四个方向
        dirs = ((1, 1), (1, 0), (0, 1), (1, -1))
        for pos in self.ai_chess:
            for dir in dirs:
                ai_score += self.cal_one_pos(False, pos, dir, ai_chess_dir_score)
        for pos in self.man_chess:
            for dir in dirs:
                man_score += self.cal_one_pos(True, pos, dir, man_chess_dir_score)

        return man_score - ai_score * 0.3

    def dfs_minimax(self, is_man, opponent_act, cur_depth, alpha, beta):
        '''
        :param is_man: True -> 人 极大节点, False -> AI 极小节点
        :param opponent_act: 对方上一步下的子的位置
        :param cur_depth: 当前搜索的深度：self.max_depth - cur_depth + 1
        :param alpha: 极大祖先节点的alpha
        :param beta: 极小祖先接地那的beta
        :return: 对于极大节点，返回最大得分以及最佳的下子位置，对于极小节点，返回最小得分以及最佳的下子位置
        '''
        # 如果当前棋局已经分出胜负或者深度已到，则停止深搜
        if self.check(not is_man, opponent_act) or cur_depth == 0:
            return self.estimate(), None

        # 获得空位置
        possible_pos = self.get_empty_pos()
        # 最佳的下子位置
        best_act = None
        # 当前极大节点的alpha或者当前极小节点的beta
        cur_alpha = float('-inf')
        cur_beta = float('inf')

        for each_pos in possible_pos:
            if self.solitary(each_pos):         # 无邻居，不考虑
                continue

            if is_man:
                self.man_chess.add(each_pos)
            else:
                self.ai_chess.add(each_pos)

            value, _ = self.dfs_minimax(not is_man, each_pos, cur_depth-1, alpha, beta)     # 下这一步获得的最有利的分数

            if is_man:
                self.man_chess.remove(each_pos)
            else:
                self.ai_chess.remove(each_pos)

            # 极大节点
            if is_man:
                # 更新当前alpha
                if cur_alpha < value:
                    cur_alpha = value
                    best_act = each_pos
                if cur_alpha > alpha:
                    alpha = cur_alpha
                # 剪枝
                if alpha >= beta:
                    return alpha, best_act
            # 极小节点
            else:
                # 更新当前beta
                if cur_beta > value:
                    cur_beta = value
                    best_act = each_pos
                if cur_beta < beta:
                    beta = cur_beta
                # 剪枝
                if alpha >= beta:
                    return beta, best_act

        if is_man:
            return cur_alpha, best_act
        else:
            return cur_beta, best_act

    def get_input(self):
        '''
        ###弃用####
        :return: 返回人输入要下子的坐标，需要检查
        '''
        while True:
            # 要求输入的格式为 'x y'
            try:
                x, y = input('输入要下的位置，格式为：行 列（从0开始算）\n').split()
            except ValueError:
                print('输入错误，请重新输入\n')
            else:
                # 要求输入是数字
                try:
                    x = int(x)
                    y = int(y)
                except ValueError:
                    print('输入非数字，请重新输入\n')
                else:
                    # 要求输入的坐标合法
                    if (0 <= x < self.size and 0 <= y < self.size and (x, y) not in self.man_chess
                            and (x, y) not in self.ai_chess):
                        return x, y
                    else:
                        print('越界或该位置上已有子')

    def play(self):
        '''
        ###弃用####
        '''
        # 画出初始棋局
        self.print_board()

        # 人先手则获取要下的位置
        if self.man_first:
            (x, y) = self.get_input()
            self.man_chess.add((x, y))
            self.print_board()
        # AI先手则将初始棋局的后手的一个子作为人下的子
        else:
            (x, y) = (5, 4)

        while True:
            # AI获取最有利的下子位置
            _, pos = self.dfs_minimax(False, (x, y), self.max_depth, float('-inf'), float('inf'))
            print('ai下的位置：', pos)
            self.ai_chess.add(pos)
            self.print_board()
            # 检查是否胜负分明
            if self.check(False, pos):
                print('你输了')
                return

            x, y = self.get_input()
            self.man_chess.add((x, y))
            self.print_board()
            # 检查是否胜负分明
            if self.check(True, (x, y)):
                print('你赢了')
                return

    def get_ai_action(self, man_act):
        '''
        :param man_act: 人下子的位置
        :return: AI下子的位置
        '''
        # 通过搜索获得最有利的下子位置
        value, pos = self.dfs_minimax(False, man_act, self.max_depth, float('-inf'), float('inf'))
        print('AI下的位置为：', pos)
        print('AI得分为：', value)
        print()
        # 更新
        self.ai_chess.add(pos)
        if self.man_first:
            self.chess_list[pos[0]][pos[1]] = 2
        else:
            self.chess_list[pos[0]][pos[1]] = 1
        return pos

    def input_man_act(self, pos):
        '''
        :param pos: 人下子的位置
        '''
        print('人下的位置：', pos)
        print('人得分为：', self.estimate())
        print()
        # 更新
        self.man_chess.add(pos)
        if self.man_first:
            self.chess_list[pos[0]][pos[1]] = 1
        else:
            self.chess_list[pos[0]][pos[1]] = 2

    def get_chess_list(self):
        '''
        :return: 当前棋局的下子情况
        '''
        return self.chess_list


def show_board(screen,  bg_img, chess_list, last_step=(None, None)):
    '''
    :param screen: pygame.surface
    :param bg_img: 背景图
    :param chess_list: 当前棋局的下子情况
    :param last_step: (a, b) denotes (is man or not, last action)
    '''
    # 贴背景
    screen.blit(bg_img, (0, 0))
    # 画线
    for i in range(N):
        pygame.draw.line(screen, BLACK, (Space, Space + i * Cell_Size), (Grid_Size - Space, Space + i * Cell_Size))
        pygame.draw.line(screen, BLACK, (Space + i * Cell_Size, Space), (Space + i * Cell_Size, Grid_Size - Space))
    # 画棋
    for i in range(N):
        for j in range(N):
            if chess_list[i][j] == 0 or (i, j) == last_step:
                continue
            pos = (Space + Cell_Size * j, Space + Cell_Size * i)
            if chess_list[i][j] == 1:
                pygame.draw.circle(screen, BLACK, pos, Cell_Size // 2)
            else:
                pygame.draw.circle(screen, White, pos, Cell_Size // 2)
    # AI上一步棋特别标志 灰色标志
    if last_step[0] is not None and last_step[1] is not None:
        pos = (Space + Cell_Size * last_step[1][1], Space + Cell_Size * last_step[1][0])
        if not last_step[0]:
            # if chess_list[last_step[1][0]][last_step[1][1]] == 1:
            #     pygame.draw.circle(screen, (100, 100, 100), pos, Cell_Size // 2)
            # else:
            pygame.draw.circle(screen, (200, 200, 200), pos, Cell_Size // 2)
        else:
            if chess_list[last_step[1][0]][last_step[1][1]] == 1:
                pygame.draw.circle(screen, BLACK, pos, Cell_Size // 2)
            else:
                pygame.draw.circle(screen, White, pos, Cell_Size // 2)


def display_text(screen, text, pos, size, color, font_name):
    '''
    :param screen: pygame.surface
    :param text: 要显示的文字
    :param pos: 显示文字的中心位置
    :param size: 文字大小
    :param color: 文字颜色
    :param font_name: 文字字体
    '''
    font = pygame.font.Font(font_name, size)
    tx_surf = font.render(text, True, color)
    tx_rect = tx_surf.get_rect()
    tx_rect.midtop = pos
    screen.blit(tx_surf, tx_rect)


if __name__ == '__main__':
    # 初始化pygame
    pygame.init()
    pygame.display.set_caption('五子棋')
    screen = pygame.display.set_mode((Grid_Size, Grid_Size))
    bg_img = pygame.image.load('background.jpg').convert()
    font_name = pygame.font.get_default_font()

    # 显示提示信息
    show_board(screen, bg_img, [[0] * 11 for _ in range(11)])
    display_text(screen, 'Press \'F\' to be on the offensive...',
                 (Grid_Size // 2, Grid_Size // 2), 30, (0, 0, 255), font_name)
    display_text(screen, 'Press others to be on the defensive...',
                 (Grid_Size // 2, Grid_Size // 2 + 30), 30, (0, 0, 255), font_name)
    pygame.display.flip()

    # 按Y表示人先手，否则人后手
    man_first = False
    have_chosen = False
    while not have_chosen:
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                pygame.QUIT
            elif event.type == pygame.KEYUP:
                if event.key == pygame.K_f:
                    man_first = 1
                have_chosen = True

    game = UndefeatedAI(man_first)          # 实例化一个AI

    # AI先手则将初始棋局的后手的一个子作为人下的子
    action = None
    if not man_first:
        action = game.get_ai_action((5, 4))
    chess_list = game.get_chess_list()
    show_board(screen, bg_img, chess_list, (False, action))
    pygame.display.flip()

    # 交互开始
    end = False
    win_or_lose = None
    while not end:
        # 通过UI交互获取人要下子的位置
        have_chosen = False
        pos = None
        while not have_chosen:
            for event in pygame.event.get():
                if event.type == pygame.QUIT:
                    pygame.QUIT
                elif event.type == pygame.MOUSEBUTTONDOWN:
                    pos = (round((event.pos[1] - Space) / Cell_Size), round((event.pos[0] - Space) / Cell_Size))
                    # print(pos)
                    # 检查合法性
                    if not (0 <= pos[0] < N) or not (0 <= pos[1] < N) or not (pos in game.get_empty_pos()):
                        break
                    # 更新棋局
                    game.input_man_act(pos)
                    show_board(screen, bg_img, chess_list, (True, pos))
                    pygame.display.flip()
                    have_chosen = True
                    # 检查是否胜负分明
                    if game.check(True, pos):
                        win_or_lose = True
                        end = True

        if not end:
            # AI下子并更新棋局
            action = game.get_ai_action(pos)
            show_board(screen, bg_img, chess_list, (False, action))
            pygame.display.flip()
            # 检查是否胜负分明
            if game.check(False, action):
                win_or_lose = False
                end = True

    # 显示谁赢了
    if win_or_lose:
        display_text(screen, 'You win!', (Grid_Size // 2, Grid_Size // 2), 80, (255, 0, 0), font_name)
    else:
        display_text(screen, 'You lose!', (Grid_Size // 2, Grid_Size // 2), 80, (255, 0, 0), font_name)
    display_text(screen, 'Press any key to quit...', (Grid_Size // 2, Grid_Size // 2 + 80), 20, (0, 0, 255), font_name)
    pygame.display.flip()

    # 按任意键结束
    press = False
    while not press:
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                pygame.QUIT
            elif event.type == pygame.KEYDOWN:
                press = True
                # pass
