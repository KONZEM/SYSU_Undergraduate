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
	cout << "�� " << line << "���� " << column << "     ����" + error << endl;
	// ������з�������ֹͣ�������У���ʼ������һ�� 
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
	if (!log_error_call && type != TOKEN_TYPE::COMMENT)			// ��Ϊע�Ϳ��Գ��ֻ��з�������type�����Ա���ʼ��	
		type = TOKEN_TYPE::NONE;
	else if (log_error_call)									// log_error���õĻ������еı�����Ҫ��ʼ�� 
		type = TOKEN_TYPE::NONE;
}

void LexicalAnalysis::handle_token() {
	TokenInfo token_info = *(new TokenInfo(type, token, line, column - token.length()));
	TOKEN_TYPE t = getType(token);
	if ((token_info.type == TOKEN_TYPE::NONE || token_info.type == TOKEN_TYPE::ID)		// �ؼ�����repeat���ܴ������Ϊ��ID��op_xxx��û�ж�type 
		&& t != TOKEN_TYPE::NONE)
	 	token_info.type = t;
	 	
	if (token_info.type != TOKEN_TYPE::COMMENT) tokens.push_back(token_info);			// ע�Ͳ���Ҫ���� 
	
	token = "";													// ��ʼ������ 
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
		// �����ļ� 
		if (infile.eof()) {
			if (type == TOKEN_TYPE::COMMENT) log_error("ȱ���ַ�\"}\"");
			if (type == TOKEN_TYPE::STRING) log_error("ȱ���ַ�\"\'\"");
			if (!token.empty()) handle_token();
			break;
		}
		
		// ���жϷָ�� 
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
			else if (ch == '\n' && type == TOKEN_TYPE::STRING) log_error("ȱ���ַ�\"\'\"");
			if (ch == '\n') next_line(false);
		}
		
		if (isOp && getType(token) != TOKEN_TYPE::NONE && getType(token + ch) == TOKEN_TYPE::NONE)	handle_token();
		
		// op_xxxҲ��һ�ַָ��� 
		if (!token.empty() && type != TOKEN_TYPE::COMMENT && type != TOKEN_TYPE::STRING && !isOp && isOperator(ch))	handle_token();
		
		// NUMBER�в��ܳ��ֳ���������ַ� 
		if (type == TOKEN_TYPE::NUMBER && !isNumber(ch)) log_error(string("NUMER���ͺ��зǷ��ַ�") + ch);
		
		// ID�в��ܳ��ֳ���ĸ����������ַ� 
		if (type == TOKEN_TYPE::ID && !isNumber(ch) && !isLetter(ch)) log_error(string("ID���ͺ��зǷ��ַ�") + ch); 
		
		// ��ȡtoken�ĵ�һ���ַ� 
		if (token.empty()) {
			if (isNumber(ch)) type = TOKEN_TYPE::NUMBER;
			else if (isLetter(ch)) type = TOKEN_TYPE::ID;
			else if (isOperator(ch)) isOp = true;					// ��ʱû��type 
			else if (ch == '\'') type = TOKEN_TYPE::STRING;
			else if (ch == '{') type = TOKEN_TYPE::COMMENT;
			else if (!isSep(ch)) log_error(string("�Ƿ���ʼ�ַ�") + ch);
		}
		else {
			if (type == TOKEN_TYPE::STRING && ch == '\'') {			// ������STRING 
				token += ch;
				handle_token();
				continue;
			}
			else if (type == TOKEN_TYPE::COMMENT && ch == '}') {	// ������ע�� 
				token += ch;
				handle_token();
				continue;
			}
		}
				
		token += ch; 
//				cout << token << ' ' << toString(type) << endl;
	}
	if (!token.empty()) handle_token();								// ��������token 
}

