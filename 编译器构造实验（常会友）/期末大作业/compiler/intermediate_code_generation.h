/*
Author: KONZEM
Date: 2020/06/28
File Name: intermediate_code_generation.cpp
Usage: semantic analysis and intermedia code gengeration
Core Knowledge: 1. back patch 2. merge 
*/

#ifndef INTERMEDIATE_CODE_GENERATION
#define INTERMEDIATE_CODE_GENERATION

#include "syntax_analysis.h"
#include "syntax_analysis.cpp"

// ����ڵ�����������䣺������仹�Ǹ�ֵ��� 
enum STMT_TYPE {
	ST_NONE, ST_CONDITION, ST_ASSIGN
};

// �����м�������� 
enum CODE_TYPE{
	UNKNOWN, START, END,
    READ, WRITE, ASSIGN,
    ADD, SUB, MUL, DIV,
    GRT, GEQ, LSS, LEQ, EQU, 
    AND, OR, NOT,
    JUMP, JUMP_LSS, JUMP_GRT,
    JUMP_EQU, JUMP_LEQ, JUMP_GEQ
};

// �м���� 
struct Code {
	CODE_TYPE type = CODE_TYPE::UNKNOWN;		// ���� 
	string p1, p2, p3;							// �������� 
	int addr;									// ����ĵ�ַ 
	int jump_addr = -1;							// ��Ծ���������� 
	Code* next = NULL;							// 
	
	string stmt();								// ���������ַ�� 
};

class Generator {
	private:
		vector<Code*> codes;					// �����м���� 
		int tmp = 0;							// Ϊ��������ʱ������id 
		
		string get_tmp_var() {					// ������ʱ������id 
			return "tmp" + to_string(tmp++);
		}
		string generate(TreeNode* root, STMT_TYPE stmt_type = STMT_TYPE::ST_NONE);	// ����ĳһ���ڵ���м���� 
		Code* gen_code(CODE_TYPE type, string p1, string p2, string p3);			// ����һ���м���� 
		void back_patch(int a, int b);												// ���� 
		int merge(int a, int b);													// �ϲ� 
		void jump(TreeNode* node, CODE_TYPE type, string p1, string p2);			// ����һ��if goto�����һ��goto���� 
		
	public:
		Generator(TreeNode* root);
		~Generator() {
			for (auto* code: codes) delete code;
		}
		const vector<Code*> getCodes() {		// ���������м���� 
			return codes;
		} 
};

#endif
