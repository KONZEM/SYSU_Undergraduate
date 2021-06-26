/*
Author: KONZEM
Date: 2020/06/28
File Name: syntax_analysis.cpp
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

#include "syntax_analysis.h"

bool SyntaxAnalysis::match(TOKEN_TYPE expect, bool flag) {
	if (token.type == expect) {					// 匹配，记录当前token，获取下一个token 
		last_token = token;
		token = _interface->getNextToken();			
		return true;
	} 
	else {
		if (flag) {								// 强制匹配失败，报错 
			if (token.type == TOKEN_TYPE::NONE)
				log_error("期望的词类型为" + toString(expect) + "，但在" +
				          token.token + "后已没有词", token.line, token.column);
			else
				log_error("期望的词类型为" + toString(expect), token.line, token.column);
		}
	}
	return false;
}

void SyntaxAnalysis::parse() {
	root = program();
	check_operand(root);
}

TreeNode* SyntaxAnalysis::program() {
	token = _interface->getNextToken();
	declarations();
	TreeNode* stmt_seq = stmt_sequence();
	if (token.type != TOKEN_TYPE::NONE)
		log_error("之后的程序被忽略", token.line, token.column);
	return stmt_seq;

}

void SyntaxAnalysis::declarations() {
	VALUE_TYPE type = VALUE_TYPE::VT_NONE;
	while (match(TOKEN_TYPE::KEY_INT) || match(TOKEN_TYPE::KEY_BOOL) ||
	        match(TOKEN_TYPE::KEY_STRING)) {
//	    cout << endl << toString(last_token.type) << ' ' ;
		switch(last_token.type) {
			case TOKEN_TYPE::KEY_INT:
				type = VALUE_TYPE::VT_INT;
				break;
			case TOKEN_TYPE::KEY_BOOL:
				type = VALUE_TYPE::VT_BOOL;
				break;
			case TOKEN_TYPE::KEY_STRING:
				type = VALUE_TYPE::VT_STRING;
				break;
		}
		do {
			if (!match(TOKEN_TYPE::ID, true)) break;
//			cout << last_token.token << ' ';
	        const SymbolTable::Symbol* symbol = symbol_table.find(last_token.token);
	        if (symbol == NULL)
		        symbol_table.insert(last_token.token, type, last_token.line);
		    else
			    log_error("变量" + last_token.token + "已定义", last_token.line, last_token.column);
		} while(match(TOKEN_TYPE::OP_COMMA));
		match(TOKEN_TYPE::OP_SEMICOLON, true);		// decalration与declaration之间一定要有分号，decalration与stmt_sequnce之间一定要有分号
	}
}

TreeNode* SyntaxAnalysis::stmt_sequence() {
	TreeNode* node = new TreeNode(NODE_TYPE::STMT_SEQUENCE);
	do {
		TreeNode* child = statement();
		if (child != NULL)
			node->children.push_back(child);
	}while(match(TOKEN_TYPE::OP_SEMICOLON));		// statement与statement之间一定要有分号
	if (node->children.empty()) return NULL;
	return node;
}

TreeNode* SyntaxAnalysis::statement() {
	TreeNode* node = NULL;
	switch(token.type) {
		case TOKEN_TYPE::KEY_IF:
			node = if_stmt();
			break;
		case TOKEN_TYPE::KEY_REPEAT:
			node = repeat_stmt();
			break;
		case TOKEN_TYPE::KEY_READ:
			node = read_stmt();
			break;
		case TOKEN_TYPE::KEY_WRITE:
			node = write_stmt();
			break;
		case TOKEN_TYPE::KEY_WHILE:
			node = while_stmt();
			break;
		case TOKEN_TYPE::ID:
			node = assign_stmt();
			break;
	}
	return node;
}

TreeNode* SyntaxAnalysis::if_stmt() {
	TreeNode* node = new TreeNode(NODE_TYPE::IF_STMT);
	
	match(TOKEN_TYPE::KEY_IF, true);							// if
	TreeNode* child = new TreeNode(NODE_TYPE::KEY_WORD);
	child->token = new TokenInfo(last_token);
	node->children.push_back(child);
	
	node->children.push_back(or_exp());							// or-exp
	
	match(TOKEN_TYPE::KEY_THEN, true);							// then
	child = new TreeNode(NODE_TYPE::KEY_WORD);
	child->token = new TokenInfo(last_token);
	node->children.push_back(child);
	
	node->children.push_back(stmt_sequence());					// stmt-sequence
	
	if (match(TOKEN_TYPE::KEY_ELSE)) {							// else
		child = new TreeNode(NODE_TYPE::KEY_WORD);
		child->token = new TokenInfo(last_token);
		node->children.push_back(child);
		
		node->children.push_back(stmt_sequence());				// stmt-sequence
	}
	
	match(TOKEN_TYPE::KEY_END, true);							// end
	child = new TreeNode(NODE_TYPE::KEY_WORD);
	child->token = new TokenInfo(last_token);
	node->children.push_back(child);
	
	return node;
}

TreeNode* SyntaxAnalysis::repeat_stmt() {
	TreeNode* node = new TreeNode(NODE_TYPE::REPEAT_STMT);
	
	match(TOKEN_TYPE::KEY_REPEAT, true);						// repeat
	TreeNode* child = new TreeNode(NODE_TYPE::KEY_WORD);
	child->token = new TokenInfo(last_token);
	node->children.push_back(child);
	
	node->children.push_back(stmt_sequence());					// stmt-sequence
	
	match(TOKEN_TYPE::KEY_UNTIL, true);							// until
	child = new TreeNode(NODE_TYPE::KEY_WORD);
	child->token = new TokenInfo(last_token);
	node->children.push_back(child);
	
	node->children.push_back(or_exp());							// or-exp
	return node;
}

TreeNode* SyntaxAnalysis::read_stmt() {
	TreeNode* node = new TreeNode(NODE_TYPE::READ_STMT);
		
	match(TOKEN_TYPE::KEY_READ, true);							// read
	TreeNode* child = new TreeNode(NODE_TYPE::KEY_WORD);
	child->token = new TokenInfo(last_token);
	node->children.push_back(child);
	
	if (token.type == TOKEN_TYPE::ID)							// identifier
		node->children.push_back(factor());
	else if (token.type == TOKEN_TYPE::NONE)
		log_error("在read后缺少词", last_token.line, last_token.column);
	else
		log_error("期望词类型为ID", token.line, token.column);

	return node;
}

TreeNode* SyntaxAnalysis::write_stmt() {
	TreeNode* node = new TreeNode(NODE_TYPE::WRITE_STMT);
	
	match(TOKEN_TYPE::KEY_WRITE, true);							// write
	TreeNode* child = new TreeNode(NODE_TYPE::KEY_WORD);
	child->token = new TokenInfo(last_token);
	node->children.push_back(child);
	
	node->children.push_back(or_exp());							// or-exp
	return node;
}

TreeNode* SyntaxAnalysis::while_stmt() {
	TreeNode* node = new TreeNode(NODE_TYPE::WHILE_STMT);		
	
	match(TOKEN_TYPE::KEY_WHILE, true);							// while
	TreeNode* child = new TreeNode(NODE_TYPE::KEY_WORD);
	child->token = new TokenInfo(last_token);
	node->children.push_back(child);
	
	node->children.push_back(or_exp());							// or-exp
	
	match(TOKEN_TYPE::KEY_DO, true);							// do
	child = new TreeNode(NODE_TYPE::KEY_WORD);
	child->token = new TokenInfo(last_token);
	node->children.push_back(child);
	
	node->children.push_back(stmt_sequence());					// stmt-sequence
	
	match(TOKEN_TYPE::KEY_END, true);							// end
	child = new TreeNode(NODE_TYPE::KEY_WORD);
	child->token = new TokenInfo(last_token);
	node->children.push_back(child);
	
	return node;
}

TreeNode* SyntaxAnalysis::assign_stmt() {
	TreeNode* node = new TreeNode(NODE_TYPE::ASSIGN_STMT);
	
	node->children.push_back(factor());							// identifier
		
	match(TOKEN_TYPE::OP_ASSIGN, true);							// :=
	TreeNode* child = new TreeNode(NODE_TYPE::KEY_WORD);
	child->token = new TokenInfo(last_token);
	node->children.push_back(child);
	
	node->children.push_back(or_exp());							// or-exp
	
	return node;
}

TreeNode* SyntaxAnalysis::or_exp() {
	TreeNode* node = new TreeNode(NODE_TYPE::OR_EXP);
	
	node->children.push_back(and_exp());						// and-exp 
		
	if (match(TOKEN_TYPE::KEY_OR)) {							// or
		TreeNode* child = new TreeNode(NODE_TYPE::KEY_WORD);
		child->token = new TokenInfo(last_token);
		node->children.push_back(child);
		
		node->children.push_back(or_exp());						// or-exp
	} 
	else {
		TreeNode* tmp = node->children[0];
		node->children.pop_back();
		delete node;
		node = tmp;
	}
	
	return node;
}

TreeNode* SyntaxAnalysis::and_exp() {
	TreeNode* node = new TreeNode(NODE_TYPE::AND_EXP);
	
	node->children.push_back(comparison_exp());					// comparison-exp
	
	if (match(TOKEN_TYPE::KEY_AND)) {							// and
		TreeNode* child = new TreeNode(NODE_TYPE::KEY_WORD);
		child->token = new TokenInfo(last_token);
		node->children.push_back(child);
		
		node->children.push_back(and_exp());					// and-exp
	} 
	else {
		TreeNode* tmp = node->children[0];
		node->children.pop_back();
		delete node;
		node = tmp;
	}
	
	return node;
}

TreeNode* SyntaxAnalysis::comparison_exp() {
	TreeNode* node = new TreeNode(NODE_TYPE::NONE);
	
	node->children.push_back(add_sub_exp());					// add-sub-exp	
	
	TreeNode* child = NULL;
	switch(token.type) {
		case TOKEN_TYPE::OP_LSS:								// <
			match(TOKEN_TYPE::OP_LSS, true);
			child = new TreeNode(NODE_TYPE::KEY_WORD);
			child->token = new TokenInfo(last_token);
			node->children.push_back(child);
			
			node->node_type = NODE_TYPE::LSS_EXP;
			
			node->children.push_back(add_sub_exp());			// add-sub-exp 
			break;
		case TOKEN_TYPE::OP_LEQ:
			match(TOKEN_TYPE::OP_LEQ, true);					// <=
			child = new TreeNode(NODE_TYPE::KEY_WORD);
			child->token = new TokenInfo(last_token);
			node->children.push_back(child);
			
			node->node_type = NODE_TYPE::LEQ_EXP;
			
			node->children.push_back(add_sub_exp());			// add-sub-exp
			break;
		case TOKEN_TYPE::OP_GRT:
			match(TOKEN_TYPE::OP_GRT, true);					// >
			child = new TreeNode(NODE_TYPE::KEY_WORD);			
			child->token = new TokenInfo(last_token);
			node->children.push_back(child);
			
			node->node_type = NODE_TYPE::GRT_EXP;		
			
			node->children.push_back(add_sub_exp());			// add-sub-exp
			break;
		case TOKEN_TYPE::OP_GEQ:
			match(TOKEN_TYPE::OP_GEQ, true);					// >=
			child = new TreeNode(NODE_TYPE::KEY_WORD);
			child->token = new TokenInfo(last_token);
			node->children.push_back(child);
			
			node->node_type = NODE_TYPE::GEQ_EXP;			
				
			node->children.push_back(add_sub_exp());			// add-sub-exp
			break;
		case TOKEN_TYPE::OP_EQU:
			match(TOKEN_TYPE::OP_EQU, true);					// =
			child = new TreeNode(NODE_TYPE::KEY_WORD);
			child->token = new TokenInfo(last_token);
			node->children.push_back(child);
			
			node->node_type = NODE_TYPE::EQU_EXP;				
			
			node->children.push_back(add_sub_exp());			// add-sub-exp
			break;
		default:
			TreeNode* tmp = node->children[0];
			node->children.pop_back();
			delete node;
			node = tmp;
	}
	
	return node;
}

TreeNode* SyntaxAnalysis::add_sub_exp() {
	TreeNode* node = new TreeNode(NODE_TYPE::NONE);
	
	node->children.push_back(mul_div_exp());					// mul-div-exp
	
	TreeNode* child = NULL;
	switch(token.type) {
		case TOKEN_TYPE::OP_ADD:	
			match(TOKEN_TYPE::OP_ADD, true);					// +
			child = new TreeNode(NODE_TYPE::KEY_WORD);
			child->token = new TokenInfo(last_token);
			node->children.push_back(child);
			
			node->node_type = NODE_TYPE::ADD_EXP;
			
			node->children.push_back(add_sub_exp());			// add-sub-exp
			break;
		case TOKEN_TYPE::OP_SUB:
			match(TOKEN_TYPE::OP_SUB, true);					// -
			child = new TreeNode(NODE_TYPE::KEY_WORD);
			child->token = new TokenInfo(last_token);
			node->children.push_back(child);
			
			node->node_type = NODE_TYPE::SUB_EXP;
			
			node->children.push_back(add_sub_exp());			// add-sub-exp
			break;
		default:
			TreeNode* tmp = node->children[0];
			node->children.pop_back();
			delete node;
			node = tmp;
			break;
	}
	
	return node;
}

TreeNode* SyntaxAnalysis::mul_div_exp() {
	TreeNode* node = new TreeNode(NODE_TYPE::NONE);
	
	node->children.push_back(factor());						// factor
	
	TreeNode* child = NULL; 
	switch(token.type) {
		case TOKEN_TYPE::OP_MUL:		
			match(TOKEN_TYPE::OP_MUL, true);				// *
			child = new TreeNode(NODE_TYPE::KEY_WORD);
			child->token = new TokenInfo(last_token);
			node->children.push_back(child);
			
			node->node_type = NODE_TYPE::MUL_EXP;
			
			node->children.push_back(mul_div_exp());		// mul-div-exp
			break;
		case TOKEN_TYPE::OP_DIV:	
			match(TOKEN_TYPE::OP_DIV, true);				//  /
			child = new TreeNode(NODE_TYPE::KEY_WORD);
			child->token = new TokenInfo(last_token);
			node->children.push_back(child);
			
			node->node_type = NODE_TYPE::DIV_EXP;
			
			node->children.push_back(mul_div_exp());		// mul-div-exp
			break;
		default:
			TreeNode* tmp = node->children[0];
			node->children.pop_back();
			delete node;
			node = tmp;
			break;
	}
	
	return node;
}

TreeNode* SyntaxAnalysis::factor() {
	TreeNode* node = new TreeNode(NODE_TYPE::FACTOR);
	
	TreeNode* child = NULL;
	switch(token.type) {	
		case TOKEN_TYPE::ID: {									// ID
			node->token = new TokenInfo(token);		
			
			const SymbolTable::Symbol* symbol = symbol_table.find(token.token);
			if (symbol == NULL)
				log_error("变量" + token.token + "没有定义", token.line, token.column);
			else {
				node->value_type = symbol->value_type;
				symbol_table.insert (token.token, node->value_type, token.line);
			}
			match(TOKEN_TYPE::ID, true);
			break;
		}
		case TOKEN_TYPE::NUMBER: {								// NUMBER
			node->token = new TokenInfo(token);
			node->value_type = VALUE_TYPE::VT_INT;
			match(TOKEN_TYPE::NUMBER, true);
			break;
		}	
		case TOKEN_TYPE::STRING: {								// STRINg
			node->token = new TokenInfo(token);		
			node->value_type = VALUE_TYPE::VT_STRING;
			match(TOKEN_TYPE::STRING, true);
			break;
		}
		case TOKEN_TYPE::KEY_TRUE: {							// true
			node->token = new TokenInfo(token);
			node->value_type = VALUE_TYPE::VT_BOOL;
			match(TOKEN_TYPE::KEY_TRUE, true);
			break;
		}
		case TOKEN_TYPE::KEY_FALSE: {							// false 
			node->token = new TokenInfo(token);
			node->value_type = VALUE_TYPE::VT_BOOL;
			match(TOKEN_TYPE::KEY_FALSE, true);
			break;
		}
		case TOKEN_TYPE::OP_LP: {								// ( or-exp ) 
			delete node;
			match(TOKEN_TYPE::OP_LP, true);
			node = or_exp();
			match(TOKEN_TYPE::OP_RP, true);
			break;
		}
		case TOKEN_TYPE::KEY_NOT: {								// not factor
			node->node_type = NODE_TYPE::NOT_EXP;
			
			match(TOKEN_TYPE::KEY_NOT, true);
			TreeNode* child = new TreeNode(NODE_TYPE::KEY_WORD);
			node->token = new TokenInfo(last_token);
			node->children.push_back(child);
			
			node->children.push_back(factor());
			break;
		}
		default:
			if (token.type == TOKEN_TYPE::NONE)
				log_error("在" + token.token + "后缺少词", token.line, token.column);
			else
				log_error("错误词类型", token.line, token.column);
			delete node;
			break;
	}
	
	return node;
}

void SyntaxAnalysis::check_operand(TreeNode* node) {
	if (node == NULL) return ;
	for (TreeNode* child: node->children)
		if (child != NULL) check_operand(child);
			switch(node->node_type) {
				case NODE_TYPE::LSS_EXP:
				case NODE_TYPE::LEQ_EXP:
				case NODE_TYPE::GRT_EXP:
				case NODE_TYPE::GEQ_EXP:
					if (node->children[0] == NULL || node->children[2] == NULL)
						log_error("缺少操作数", node->children[1]->token->line, node->children[1]->token->column);
					else if (node->children[0]->value_type != VALUE_TYPE::VT_INT)
						log_error("第一个操作数类型不是int类型", node->children[0]->token->line, node->children[0]->token->column);
					else if (node->children[2]->value_type != VALUE_TYPE::VT_INT)
						log_error("第二个操作数类型不是int类型", node->children[2]->token->line, node->children[2]->token->column);
					node->value_type = VALUE_TYPE::VT_BOOL;
					break;
				case NODE_TYPE::OR_EXP:
				case NODE_TYPE::AND_EXP:
					if (node->children[0] == NULL || node->children[2] == NULL)
						log_error("缺少操作数", node->children[1]->token->line, node->children[1]->token->column);
					else if (node->children[0]->value_type != VALUE_TYPE::VT_BOOL)
						log_error("第一个操作数类型不是bool类型", node->children[0]->token->line, node->children[0]->token->column);
					else if (node->children[2]->value_type != VALUE_TYPE::VT_BOOL)
						log_error("第二个操作数类型不是bool类型", node->children[2]->token->line, node->children[2]->token->column);
					node->value_type = VALUE_TYPE::VT_BOOL;
					break;
				case NODE_TYPE::EQU_EXP:
					if (node->children[0] == NULL || node->children[2] == NULL)
						log_error("缺少操作数", node->children[1]->token->line, node->children[1]->token->column);
					else if (node->children[0]->value_type != node->children[2]->value_type)
						log_error("操作数类型不一致", node->children[1]->token->line, node->children[1]->token->column);
					node->value_type = VALUE_TYPE::VT_BOOL;
					break;
				case NODE_TYPE::NOT_EXP:
					if (node->children[1] == NULL)
						log_error("缺少操作数", node->token->line, node->token->column);
					else if (node->children[1]->value_type != VALUE_TYPE::VT_BOOL)
						log_error("操作数类型不是bool类型", node->children[1]->token->line, node->children[1]->token->column);
					break;
				case NODE_TYPE::ADD_EXP:
				case NODE_TYPE::SUB_EXP:
				case NODE_TYPE::MUL_EXP:
				case NODE_TYPE::DIV_EXP:
					if (node->children[0] == NULL || node->children[2] == NULL)
						log_error("缺少操作数", node->children[1]->token->line, node->children[1]->token->column);
					else if (node->children[0]->value_type != VALUE_TYPE::VT_INT)
						log_error("第一个操作数类型不是int类型", node->children[0]->token->line, node->children[0]->token->column);
					else if (node->children[2]->value_type != VALUE_TYPE::VT_INT)
						log_error("第二个操作数类型不是int类型", node->children[2]->token->line, node->children[2]->token->column);
					node->value_type = VALUE_TYPE::VT_INT;
					break;
				case NODE_TYPE::IF_STMT:
				case NODE_TYPE::WHILE_STMT:
					if (node->children[1]->value_type != VALUE_TYPE::VT_BOOL)
						log_error("条件不是bool类型", node->children[0]->token->line, node->children[0]->token->column);
					break;
				case NODE_TYPE::REPEAT_STMT:
					if (node->children[3]->value_type != VALUE_TYPE::VT_BOOL)
						log_error("条件不是bool类型", node->children[1]->token->line, node->children[1]->token->line);
					break;
				case NODE_TYPE::ASSIGN_STMT:
					if (node->children[0] == NULL || node->children[2] == NULL)
						log_error("缺少操作数", node->children[1]->token->line, node->children[1]->token->column);
					else if (node->children[0]->value_type != node->children[2]->value_type) 
						log_error("操作数类型不一致", node->children[1]->token->line, node->children[1]->token->column);
					break;
			}
}

void SyntaxAnalysis::print_tree(TreeNode* node, int num) {
	if (node == NULL) return ;
	cout << "|" << endl;
	for (int i=0; i<num; ++i) cout  << "--";
	string s = toString(node->node_type);
	if (s != "")	cout << s << endl;
	else if (node->node_type == NODE_TYPE::FACTOR)
		cout << "factor: " + node->token->token << endl;
	else if (node->node_type == NODE_TYPE::KEY_WORD)
		cout << "key word: " + node->token->token << endl;
	for (TreeNode* child:node->children)
		if (child != NULL) print_tree(child, num + 1);
}

void SyntaxAnalysis::log_error(string error, int line, int column) {
	compile_error = true;
	cout << "Line " << line << ", Column " << column << "     error: " + error << endl;
} 

