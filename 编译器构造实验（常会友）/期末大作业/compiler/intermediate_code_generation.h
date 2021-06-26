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

// 定义节点属于哪种语句：条件语句还是赋值语句 
enum STMT_TYPE {
	ST_NONE, ST_CONDITION, ST_ASSIGN
};

// 定义中间代码类型 
enum CODE_TYPE{
	UNKNOWN, START, END,
    READ, WRITE, ASSIGN,
    ADD, SUB, MUL, DIV,
    GRT, GEQ, LSS, LEQ, EQU, 
    AND, OR, NOT,
    JUMP, JUMP_LSS, JUMP_GRT,
    JUMP_EQU, JUMP_LEQ, JUMP_GEQ
};

// 中间代码 
struct Code {
	CODE_TYPE type = CODE_TYPE::UNKNOWN;		// 类型 
	string p1, p2, p3;							// 三个参数 
	int addr;									// 代码的地址 
	int jump_addr = -1;							// 跳跃到哪条代码 
	Code* next = NULL;							// 
	
	string stmt();								// 翻译成三地址码 
};

class Generator {
	private:
		vector<Code*> codes;					// 所有中间代码 
		int tmp = 0;							// 为了生成临时变量的id 
		
		string get_tmp_var() {					// 生成临时变量的id 
			return "tmp" + to_string(tmp++);
		}
		string generate(TreeNode* root, STMT_TYPE stmt_type = STMT_TYPE::ST_NONE);	// 生成某一个节点的中间代码 
		Code* gen_code(CODE_TYPE type, string p1, string p2, string p3);			// 生成一条中间代码 
		void back_patch(int a, int b);												// 回添 
		int merge(int a, int b);													// 合并 
		void jump(TreeNode* node, CODE_TYPE type, string p1, string p2);			// 生成一条if goto代码和一条goto代码 
		
	public:
		Generator(TreeNode* root);
		~Generator() {
			for (auto* code: codes) delete code;
		}
		const vector<Code*> getCodes() {		// 返回所有中间代码 
			return codes;
		} 
};

#endif
