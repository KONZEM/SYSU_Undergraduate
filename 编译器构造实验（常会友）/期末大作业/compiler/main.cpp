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
		cout << "�������ļ���" << endl;
		return 0;
	}
	string filename = argv[1];
	ifstream infile(filename);
	if (!infile) {
		cout << "�޷���" + filename << endl;
		return 0;
	}
	
	LexicalAnalysis compile1(infile);
	if (compile1.success()) {
		vector<TokenInfo> tokens = compile1.getTokens();
		cout << "�ʷ�������ɣ�Token���£�" << endl;
		for (TokenInfo token:tokens)
			cout << "(" << toString(token.type) << ", " << token.token << ")" << token.line << ' ' << token.column << endl;
		cout << endl; 
		
		SyntaxAnalysis compile2(tokens);
		if (compile2.success()) {
			cout << "�﷨������ɣ��﷨�����£������ļ�Ŀ¼�ṹ��ʽ�����"  << endl;
			compile2.print_tree(compile2.getRoot(), 0);
			cout << endl;
			 
			Generator compile3(compile2.getRoot());
			cout << "�м����������ɣ����£�" << endl;
			int index = 0;
			vector<Code*> codes = compile3.getCodes();
			for (Code* code: codes)
				cout << index++ << ") " <<  code->stmt() << endl; 
		}
		else
			cout << "�﷨����ʧ�ܣ��������ϴ���" << endl; 
	}
	else 
		cout << "�ʷ�����ʧ�ܣ��������ϴ���" << endl;
	return 0;
}
