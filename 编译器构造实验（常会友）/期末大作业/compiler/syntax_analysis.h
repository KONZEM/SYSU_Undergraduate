/*
Author: KONZEM
Date: 2020/06/28
File Name: syntax_analysis.h
Usage: syntax analysis
Core Knowledge: syntax definition of TINY+
				1. program -> declarations stmt-sequence
				2. declarations -> decl ; declarations |(different from /) \epsilon
				3. decl -> type-specifier varlist
				4. type-specifier -> int | bool | string
				5. varlist -> identifier (, identifier)*
				6. stmt-sequence -> statement (; statement)*
				7. statement -> if-stmt | repeat-stmt | assign-stmt | read-stmt | write-stmt | while-stmt
				8. while-stmt -> while or-exp then do stmt-sequence end
				9. if-stmt -> if or-exp then stmt-sequence (else stmt-sequence) | \epsilon end
				10. repeat-stmt -> repeat stmt-sequence until or-exp
				11. assign-stmt -> identifier := or-exp
				12. read-stmt -> read identifier
				13. write-stmt -> write or-exp
				14. or-exp -> and-exp (or or-exp) | \epsilon
				15. and-exp -> comparison-exp (and and-exp) | \epsilon
				16. comparison-exp -> add-sub-exp (> | < | >= | <= and-sub-exp) | \epsilon
				17. add-sub-exp -> mul-div-exp (+ | - add-sub-exp) | \epsilon
				18. mul-div-exp -> factor (* | / mul-div-exp) | \epsilon
				19. factor -> ID | NUMBER | STRING | true | false | '(' or-exp ')' | not factor
 
*/

#ifndef SYNTAX_ANALYSIS_H
#define SYNTAX_ANALYSIS_H

#include "lexical_analysis.h"
#include "lexical_analysis.cpp"

// 定义变量类型 
enum VALUE_TYPE {
	VT_NONE, VT_INT, VT_BOOL, VT_STRING
};

// 定义节点类型 
enum NODE_TYPE {
	PROGRAM, 			// 程序（开始）节点 
	STMT_SEQUENCE, 		// 语句列表节点 
	IF_STMT, 			// 条件语句节点 
	REPEAT_STMT, 		// repeat语句节点 
	ASSIGN_STMT,		// 赋值语句节点 
    READ_STMT, 			// read语句节点 
	WRITE_STMT, 		// write语句节点 
	WHILE_STMT,			// while语句节点 
    GRT_EXP, 			// 大于表达式节点 
	GEQ_EXP, 			// 大于等于表达式节点 
	LSS_EXP, 			// 小于表达式节点 
	LEQ_EXP, 			// 小于等于表达式节点 
	EQU_EXP, 			// 等于表达式节点 
    OR_EXP, 			// 逻辑或表达式节点 
	AND_EXP, 			// 逻辑与表达式节点 
	NOT_EXP,			// 逻辑非表达式节点 
    ADD_EXP, 			// 加法表达式节点 
	SUB_EXP, 			// 减法表达式节点 
	MUL_EXP, 			// 乘法表达式节点
	DIV_EXP,			// 除法表达式节点
    FACTOR,				// 原子节点
    KEY_WORD, 			// 关键词节点 为了输出read、write、until这些关键词 
    NONE				// 未知节点 
};

// 将enum转化为string 
string toString(NODE_TYPE type) {
	switch(type) {
		case NODE_TYPE::STMT_SEQUENCE:
			return "stmt_sequence";
		case NODE_TYPE::IF_STMT:
			return "if_stmt";
		case NODE_TYPE::REPEAT_STMT:
			return "repeat_stmt";
		case NODE_TYPE::ASSIGN_STMT:
			return "assign_stmt";
		case NODE_TYPE::READ_STMT:
			return "read_stmt";
		case NODE_TYPE::WRITE_STMT:
			return "write_stmt";
		case NODE_TYPE::WHILE_STMT:
			return "while_stmt";
		case NODE_TYPE::LSS_EXP:
			return "lt_exp";
		case NODE_TYPE::LEQ_EXP:
			return "le_exp";
		case NODE_TYPE::GRT_EXP:
			return "gt_exp";
		case NODE_TYPE::GEQ_EXP:
			return "ge_exp";
		case NODE_TYPE::EQU_EXP:
			return "eq_exp";
		case NODE_TYPE::ADD_EXP:
			return "add_exp";
		case NODE_TYPE::SUB_EXP:
			return "sub_exp";
		case NODE_TYPE::MUL_EXP:
			return "mul_exp";
		case NODE_TYPE::DIV_EXP:
			return "div_exp";
		case NODE_TYPE::OR_EXP:
			return "or_exp";
		case NODE_TYPE::AND_EXP:
			return "and_exp";
		case NODE_TYPE::NOT_EXP:
			return "not_exp";
		default:
			return "";
	}
}

// 符号表，记录声明的变量 
class SymbolTable{
	public:
		struct Symbol {
			int addr;
			VALUE_TYPE value_type;
			vector<int> lines;
		};
		
		void insert(string name, VALUE_TYPE value_type, int line) {
			if (table.count(name)) table[name].lines.push_back(line);
			else {
				table[name].value_type = value_type;
				table[name].addr = addr++;
				table[name].lines.push_back(line);
			}
		}
		
	 	const Symbol* find(string name) {
	 		if (table.count(name)) return &table[name];
	 		return NULL;
		}
	private:
		int addr = 0;
		unordered_map<string, Symbol> table;
};

// 语法树的节点 
struct TreeNode {
	NODE_TYPE node_type = NODE_TYPE::NONE;			// 节点类型 
	VALUE_TYPE value_type = VALUE_TYPE::VT_NONE; 	// factor节点时有用 
	vector<TreeNode*> children;						// 子节点 
	TokenInfo* token = NULL;						// key_word节点和factor节点时有用 
	
	int _true = 0, _false = 0, _begin = 0;			// 中间代码生成时用到，back_patch和merge 
	
	TreeNode(NODE_TYPE node_type) {
		this->node_type = node_type;
	}
	
	~TreeNode() {
		if (!children.empty())
			for (auto* child: children) 
				delete child;
		delete token;
	}
};

// 语法分析器 
class SyntaxAnalysis {
	private:
		// 获取token接口 
		class TokenInterface{
			private:
				vector<TokenInfo> tokens;
				int cur;
				int total;
			
			public:
				TokenInterface(vector<TokenInfo> tokens): tokens(tokens) {
					cur = 0;
					total = tokens.size();
				} 
				TokenInfo getNextToken() {
					if (cur < total) return tokens[cur++];
					TokenInfo t =  *(new TokenInfo(tokens[cur-1]));
					t.type = TOKEN_TYPE::NONE;
					return t;
				}
		};
		
		TokenInterface* _interface;						// 获取token接口 
		SymbolTable symbol_table;						// 符号表 
		TreeNode* root = NULL;							// 根节点 
		
		TokenInfo token, last_token;					// 当前处理的token，前一个token 
			
		bool compile_error = false;						// 语法分析是否出错 

		bool match(TOKEN_TYPE expected, bool flag=false);	// 匹配当前token类型是否符合期望，flag表示是否强制匹配 
		void parse();									// 进行语法分析 
		TreeNode* program();
		void declarations();
		TreeNode* stmt_sequence();
		TreeNode* statement();
		TreeNode* if_stmt();
		TreeNode* repeat_stmt();
		TreeNode* read_stmt();
		TreeNode* write_stmt();
		TreeNode* while_stmt();
		TreeNode* assign_stmt();
		TreeNode* or_exp();
		TreeNode* and_exp();
		TreeNode* comparison_exp();
		TreeNode* add_sub_exp();
		TreeNode* mul_div_exp();
		TreeNode* factor();
		void check_operand(TreeNode* node);				// 检查操作符的操作数 
		void log_error(string error, int line, int column);	// 显示错误 
		
	public: 
		SyntaxAnalysis(vector<TokenInfo> tokens) {
			_interface = new TokenInterface(tokens);	// 开始语法分析 
			parse();
		}
		TreeNode* getRoot() {							// 返回根节点 
			return root;
		} 
		const SymbolTable* getSymbolTable() {			// 返回符号表 
			return &symbol_table;
		} 
		~SyntaxAnalysis() {
			delete root;
		}
		bool success() {								// 语法分析是否成功 
			return !compile_error;
		}
		void print_tree(TreeNode* node, int num);		// 输出语法树 

};

#endif
