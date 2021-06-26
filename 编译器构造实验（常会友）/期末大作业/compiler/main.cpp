/*
Author: KONZEM
Date: 2020/06/28
File Name: main.cpp
Usage: compile TINY+ code (three stages: lexical analysis, syntax analysis, semantic analysis and intermedia code gengeration)
*/

#include "intermediate_code_generation.h"
#include "intermediate_code_generation.cpp"

int main(int argc, char* argv[]) {
	if (argc < 2) {
		cout << "请输入文件名" << endl;
		return 0;
	}
	string filename = argv[1];
	ifstream infile(filename);
	if (!infile) {
		cout << "无法打开" + filename << endl;
		return 0;
	}
	
	LexicalAnalysis compile1(infile);
	if (compile1.success()) {
		vector<TokenInfo> tokens = compile1.getTokens();
		cout << "词法分析完成，Token如下：" << endl;
		for (TokenInfo token:tokens)
			cout << "(" << toString(token.type) << ", " << token.token << ")" << token.line << ' ' << token.column << endl;
		cout << endl; 
		
		SyntaxAnalysis compile2(tokens);
		if (compile2.success()) {
			cout << "语法分析完成，语法树如下：（以文件目录结构形式输出）"  << endl;
			compile2.print_tree(compile2.getRoot(), 0);
			cout << endl;
			 
			Generator compile3(compile2.getRoot());
			cout << "中间代码生成完成，如下：" << endl;
			int index = 0;
			vector<Code*> codes = compile3.getCodes();
			for (Code* code: codes)
				cout << index++ << ") " <<  code->stmt() << endl; 
		}
		else
			cout << "语法分析失败，出现如上错误" << endl; 
	}
	else 
		cout << "词法分析失败，出现如上错误" << endl;
	return 0;
}
