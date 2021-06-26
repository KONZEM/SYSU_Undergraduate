/*
Author: KONZEM
Date: 2020/06/28
File Name: lexical_analysis.cpp
Usage: lexical analysis
Core Knowledge: 1. ID -> letter (digit|letter)*
 	  			2. NUMBER -> digit digit* 
 	  			3. STRING: any character except '
 	  			4. blank includes '\n' '\f' '\v' ('\r' if read in binary)
				5. comment -> { any character }
*/

#include "lexical_analysis.h"
		
void LexicalAnalysis::log_error(string error) {
	compile_error = true;
	cout << "行 " << line << "，列 " << column << "     错误：" + error << endl;
	// 如果该行发生错误，停止分析该行，开始分析下一行 
	if (!infile.eof()) {			
		char ch;
		infile.get(ch);
		while (!infile.eof() && ch != '\n')	infile.get(ch);
		if (ch == '\n')	next_line(true);
	}
}

void LexicalAnalysis::next_line(bool log_error_call) {
	line += 1;
	column = 0;
	isOp = false;
	if (!log_error_call && type != TOKEN_TYPE::COMMENT)			// 因为注释可以出现换行符，所以type不可以被初始化	
		type = TOKEN_TYPE::NONE;
	else if (log_error_call)									// log_error调用的话，所有的变量都要初始化 
		type = TOKEN_TYPE::NONE;
}

void LexicalAnalysis::handle_token() {
	TokenInfo token_info = *(new TokenInfo(type, token, line, column - token.length()));
	TOKEN_TYPE t = getType(token);
	if ((token_info.type == TOKEN_TYPE::NONE || token_info.type == TOKEN_TYPE::ID)		// 关键词如repeat不能错误地认为是ID；op_xxx还没有定type 
		&& t != TOKEN_TYPE::NONE)
	 	token_info.type = t;
	 	
	if (token_info.type != TOKEN_TYPE::COMMENT) tokens.push_back(token_info);			// 注释不需要计入 
	
	token = "";													// 初始化变量 
	type = TOKEN_TYPE::NONE;								
	isOp = false; 
}

void LexicalAnalysis::analyse() {
	line = 1;
	column = 0;
	isOp = false;
	
	char ch;
	while (true) {
		infile.get(ch);
		column ++;
		// 读完文件 
		if (infile.eof()) {
			if (type == TOKEN_TYPE::COMMENT) log_error("缺少字符\"}\"");
			if (type == TOKEN_TYPE::STRING) log_error("缺少字符\"\'\"");
			if (!token.empty()) handle_token();
			break;
		}
		
		// 先判断分割符 
		if (isSep(ch)) {
			if (token.empty()) {
				if (ch == '\n') next_line(false);
				continue;
			};
			if (type != TOKEN_TYPE::COMMENT && type != TOKEN_TYPE::STRING)
			{
				handle_token();
				if (ch == '\n') next_line(false);
				continue;
			}
			else if (ch == '\n' && type == TOKEN_TYPE::STRING) log_error("缺少字符\"\'\"");
			if (ch == '\n') next_line(false);
		}
		
		if (isOp && getType(token) != TOKEN_TYPE::NONE && getType(token + ch) == TOKEN_TYPE::NONE)	handle_token();
		
		// op_xxx也是一种分隔符 
		if (!token.empty() && type != TOKEN_TYPE::COMMENT && type != TOKEN_TYPE::STRING && !isOp && isOperator(ch))	handle_token();
		
		// NUMBER中不能出现除数字外的字符 
		if (type == TOKEN_TYPE::NUMBER && !isNumber(ch)) log_error(string("NUMER类型含有非法字符") + ch);
		
		// ID中不能出现除字母和数字外的字符 
		if (type == TOKEN_TYPE::ID && !isNumber(ch) && !isLetter(ch)) log_error(string("ID类型含有非法字符") + ch); 
		
		// 读取token的第一个字符 
		if (token.empty()) {
			if (isNumber(ch)) type = TOKEN_TYPE::NUMBER;
			else if (isLetter(ch)) type = TOKEN_TYPE::ID;
			else if (isOperator(ch)) isOp = true;					// 暂时没定type 
			else if (ch == '\'') type = TOKEN_TYPE::STRING;
			else if (ch == '{') type = TOKEN_TYPE::COMMENT;
			else if (!isSep(ch)) log_error(string("非法起始字符") + ch);
		}
		else {
			if (type == TOKEN_TYPE::STRING && ch == '\'') {			// 完整的STRING 
				token += ch;
				handle_token();
				continue;
			}
			else if (type == TOKEN_TYPE::COMMENT && ch == '}') {	// 完整的注释 
				token += ch;
				handle_token();
				continue;
			}
		}
				
		token += ch; 
//				cout << token << ' ' << toString(type) << endl;
	}
	if (!token.empty()) handle_token();								// 处理最后的token 
}

