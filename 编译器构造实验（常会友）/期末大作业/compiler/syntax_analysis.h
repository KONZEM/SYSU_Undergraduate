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

// ����������� 
enum VALUE_TYPE {
	VT_NONE, VT_INT, VT_BOOL, VT_STRING
};

// ����ڵ����� 
enum NODE_TYPE {
	PROGRAM, 			// ���򣨿�ʼ���ڵ� 
	STMT_SEQUENCE, 		// ����б�ڵ� 
	IF_STMT, 			// �������ڵ� 
	REPEAT_STMT, 		// repeat���ڵ� 
	ASSIGN_STMT,		// ��ֵ���ڵ� 
    READ_STMT, 			// read���ڵ� 
	WRITE_STMT, 		// write���ڵ� 
	WHILE_STMT,			// while���ڵ� 
    GRT_EXP, 			// ���ڱ��ʽ�ڵ� 
	GEQ_EXP, 			// ���ڵ��ڱ��ʽ�ڵ� 
	LSS_EXP, 			// С�ڱ��ʽ�ڵ� 
	LEQ_EXP, 			// С�ڵ��ڱ��ʽ�ڵ� 
	EQU_EXP, 			// ���ڱ��ʽ�ڵ� 
    OR_EXP, 			// �߼�����ʽ�ڵ� 
	AND_EXP, 			// �߼�����ʽ�ڵ� 
	NOT_EXP,			// �߼��Ǳ��ʽ�ڵ� 
    ADD_EXP, 			// �ӷ����ʽ�ڵ� 
	SUB_EXP, 			// �������ʽ�ڵ� 
	MUL_EXP, 			// �˷����ʽ�ڵ�
	DIV_EXP,			// �������ʽ�ڵ�
    FACTOR,				// ԭ�ӽڵ�
    KEY_WORD, 			// �ؼ��ʽڵ� Ϊ�����read��write��until��Щ�ؼ��� 
    NONE				// δ֪�ڵ� 
};

// ��enumת��Ϊstring 
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

// ���ű���¼�����ı��� 
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

// �﷨���Ľڵ� 
struct TreeNode {
	NODE_TYPE node_type = NODE_TYPE::NONE;			// �ڵ����� 
	VALUE_TYPE value_type = VALUE_TYPE::VT_NONE; 	// factor�ڵ�ʱ���� 
	vector<TreeNode*> children;						// �ӽڵ� 
	TokenInfo* token = NULL;						// key_word�ڵ��factor�ڵ�ʱ���� 
	
	int _true = 0, _false = 0, _begin = 0;			// �м��������ʱ�õ���back_patch��merge 
	
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

// �﷨������ 
class SyntaxAnalysis {
	private:
		// ��ȡtoken�ӿ� 
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
		
		TokenInterface* _interface;						// ��ȡtoken�ӿ� 
		SymbolTable symbol_table;						// ���ű� 
		TreeNode* root = NULL;							// ���ڵ� 
		
		TokenInfo token, last_token;					// ��ǰ�����token��ǰһ��token 
			
		bool compile_error = false;						// �﷨�����Ƿ���� 

		bool match(TOKEN_TYPE expected, bool flag=false);	// ƥ�䵱ǰtoken�����Ƿ����������flag��ʾ�Ƿ�ǿ��ƥ�� 
		void parse();									// �����﷨���� 
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
		void check_operand(TreeNode* node);				// ���������Ĳ����� 
		void log_error(string error, int line, int column);	// ��ʾ���� 
		
	public: 
		SyntaxAnalysis(vector<TokenInfo> tokens) {
			_interface = new TokenInterface(tokens);	// ��ʼ�﷨���� 
			parse();
		}
		TreeNode* getRoot() {							// ���ظ��ڵ� 
			return root;
		} 
		const SymbolTable* getSymbolTable() {			// ���ط��ű� 
			return &symbol_table;
		} 
		~SyntaxAnalysis() {
			delete root;
		}
		bool success() {								// �﷨�����Ƿ�ɹ� 
			return !compile_error;
		}
		void print_tree(TreeNode* node, int num);		// ����﷨�� 

};

#endif
