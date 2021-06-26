/*
Author: KONZEM
Date: 2020/06/28
File Name: lexical_analysis.h
Usage: lexical analysis
Core Knowledge: 1. ID -> letter (digit|letter)*
 	  			2. NUMBER -> digit digit* 
 	  			3. STRING: any character except '
 	  			4. blank includes '\n' '\f' '\v' ('\r' if read in binary)
				5. comment -> { any character }
*/

#ifndef LEXICAL_ANALYSIS_H
#define LEXICAL_ANALYSIS_H

#include <bits/stdc++.h>
using namespace std;

// ����ʵ����� 
enum class TOKEN_TYPE {
	NONE, COMMENT,
	KEY_TRUE, KEY_FALSE, 					// true false
	KEY_OR, KEY_AND, KEY_NOT, 				// or and not
	KEY_INT, KEY_BOOL, KEY_STRING, 			// int bool string
	KEY_DO, KEY_WHILE, 						// do while
	KEY_REPEAT, KEY_UNTIL, 					// repeat until
	KEY_IF, KEY_THEN, KEY_ELSE, KEY_END, 	// if then else end
	KEY_READ, KEY_WRITE, 					// read write

	OP_GRT, OP_LSS, 						// > <
	OP_LEQ, OP_GEQ, OP_EQU, 				// <= >= =
	OP_COMMA, OP_SEMICOLON, OP_ASSIGN, 		// , ; :=
	OP_ADD, OP_SUB, OP_MUL, OP_DIV, 		// + - * /
	OP_LP, OP_RP, 							// ( )

	ID, NUMBER, STRING
};

// ��enum����ת��Ϊstring 
string toString(TOKEN_TYPE type) {
	switch (type) {
//		case TOKEN_TYPE::COMMENT:
//			return "COMMENT";
		case TOKEN_TYPE::KEY_TRUE:
			return "KEY_TRUE";
		case TOKEN_TYPE::KEY_FALSE:
			return "KEY_FALSE";
		case TOKEN_TYPE::KEY_OR:
			return "KEY_OR";
		case TOKEN_TYPE::KEY_AND:
			return "KEY_AND";
		case TOKEN_TYPE::KEY_NOT:
			return "KEY_NOT";
		case TOKEN_TYPE::KEY_INT:
			return "KEY_INT";
		case TOKEN_TYPE::KEY_BOOL:
			return "KEY_BOOL";
		case TOKEN_TYPE::KEY_STRING:
			return "KEY_STRING";
		case TOKEN_TYPE::KEY_DO:
			return "KEY_DO";
		case TOKEN_TYPE::KEY_WHILE:
			return "KEY_WHILE";
		case TOKEN_TYPE::KEY_REPEAT:
			return "KEY_REPEAT";
		case TOKEN_TYPE::KEY_UNTIL:
			return "KEY_UNTIL";
		case TOKEN_TYPE::KEY_IF:
			return "KEY_IF";
		case TOKEN_TYPE::KEY_THEN:
			return "KEY_THEN";
		case TOKEN_TYPE::KEY_ELSE:
			return "KEY_ELSE";
		case TOKEN_TYPE::KEY_END:
			return "KEY_END";
		case TOKEN_TYPE::KEY_READ:
			return "KEY_READ";
		case TOKEN_TYPE::KEY_WRITE:
			return "KEY_WRITE";

		case TOKEN_TYPE::OP_GRT:
			return "OP_GRT";
		case TOKEN_TYPE::OP_LSS:
			return "OP_LSS";
		case TOKEN_TYPE::OP_LEQ:
			return "OP_LEQ";
		case TOKEN_TYPE::OP_GEQ:
			return "OP_GEQ";
		case TOKEN_TYPE::OP_EQU:
			return "OP_EQU";
		case TOKEN_TYPE::OP_COMMA:
			return "OP_COMMA";
		case TOKEN_TYPE::OP_SEMICOLON:
			return "OP_SEMICOLON";
		case TOKEN_TYPE::OP_ASSIGN:
			return "OP_ASSIGN";
		case TOKEN_TYPE::OP_ADD:
			return "OP_ADD";
		case TOKEN_TYPE::OP_SUB:
			return "OP_SUB";
		case TOKEN_TYPE::OP_MUL:
			return "OP_MUL";
		case TOKEN_TYPE::OP_DIV:
			return "OP_DIV";
		case TOKEN_TYPE::OP_LP:
			return "OP_LP";
		case TOKEN_TYPE::OP_RP:
			return "OP_RP";

		case TOKEN_TYPE::ID:
			return "ID";
		case TOKEN_TYPE::NUMBER:
			return "NUMBER";
		case TOKEN_TYPE::STRING:
			return "STRING";
	}
	return "NONE";
}

// �жϴ����Ĵ���ʲô���� 
TOKEN_TYPE getType(string token) {
	if (token == "true")
		return TOKEN_TYPE::KEY_TRUE;
	else if (token == "false")
		return TOKEN_TYPE::KEY_FALSE;
	else if (token == "or")
		return TOKEN_TYPE::KEY_OR;
	else if (token == "and")
		return TOKEN_TYPE::KEY_AND;
	else if (token == "not")
		return TOKEN_TYPE::KEY_NOT;
	else if (token == "int")
		return TOKEN_TYPE::KEY_INT;
	else if (token == "bool")
		return TOKEN_TYPE::KEY_BOOL;
	else if (token == "string")
		return TOKEN_TYPE::KEY_STRING;
	else if (token == "while")
		return TOKEN_TYPE::KEY_WHILE;
	else if (token == "do")
		return TOKEN_TYPE::KEY_DO;
	else if (token == "if")
		return TOKEN_TYPE::KEY_IF;
	else if (token == "then")
		return TOKEN_TYPE::KEY_THEN;
	else if (token == "else")
		return TOKEN_TYPE::KEY_ELSE;
	else if (token == "end")
		return TOKEN_TYPE::KEY_END;
	else if (token == "repeat")
		return TOKEN_TYPE::KEY_REPEAT;
	else if (token == "until")
		return TOKEN_TYPE::KEY_UNTIL;
	else if (token == "read")
		return TOKEN_TYPE::KEY_READ;
	else if (token == "write")
		return TOKEN_TYPE::KEY_WRITE;

	else if (token == ">")
		return TOKEN_TYPE::OP_GRT;
	else if (token == "<")
		return TOKEN_TYPE::OP_LSS;
	else if (token == "<=")
		return TOKEN_TYPE::OP_LEQ;
	else if (token == ">=")
		return TOKEN_TYPE::OP_GEQ;
	else if (token == "=")
		return TOKEN_TYPE::OP_EQU;
	else if (token == ",")
		return TOKEN_TYPE::OP_COMMA;
	else if (token == ";")
		return TOKEN_TYPE::OP_SEMICOLON;
	else if (token == ":=")
		return TOKEN_TYPE::OP_ASSIGN;
	else if (token == "+")
		return TOKEN_TYPE::OP_ADD;
	else if (token == "-")
		return TOKEN_TYPE::OP_SUB;
	else if (token == "*")
		return TOKEN_TYPE::OP_MUL;
	else if (token == "/")
		return TOKEN_TYPE::OP_DIV;
	else if (token == "(")
		return TOKEN_TYPE::OP_LP;
	else if (token == ")")
		return TOKEN_TYPE::OP_RP;

	return TOKEN_TYPE::NONE;
}

// �Ƿ�����ĸ 
bool isLetter(char ch) {
	if (ch >= 'A' && ch <= 'Z' || ch >= 'a' && ch <= 'z') return true;
	return false;
}

// �Ƿ������� 
bool isNumber(char ch) {
	if (ch >= '0' && ch <= '9') return true;
	return false;
}

// �Ƿ���op_xxx�Ĵ����� 
bool isOperator(char ch) {
	static const string op = "<>=:,;+-*/()";
	return string::npos != op.find(ch);
}

// �Ƿ��Ƿָ�� 
bool isSep(char ch) {
	static const string sep = "\n\t\v\f ";
	return string::npos != sep.find(ch);
}

// Token��Ϣ�����͡����ݡ��ڼ��С��ڼ��� 
struct TokenInfo {
	TOKEN_TYPE type;
	string token;
	int line;
	int column;
	TokenInfo(): type(TOKEN_TYPE::NONE), token("") {}
	TokenInfo(TOKEN_TYPE type, string token, int line, int column): type(type), token(token), line(line), column(column) {}
	TokenInfo(const TokenInfo& token): type(token.type), token(token.token), line(token.line), column(token.column) {}
};

// �ʷ������� 
class LexicalAnalysis {
	private:
		ifstream& infile;								// �ļ��� 
		int line;										// ��ȡ���ڼ��� 
		int column;										// ��ȡ���ڼ��� 
		
		bool isOp = false; 								// ��ǰ��ȡ�����Ƿ���op_xxx 
		vector<TokenInfo> tokens;						// ����������token 
		string token;									// ��ǰ������token 
		TOKEN_TYPE type;								// ��ǰtoken������ 
		
		bool compile_error = false;						// �ʷ������Ƿ���� 

		void log_error(string error);					// ��ʾ���� 
		void next_line(bool log_error_call);			// ��ȡ�µ�һ�У���ʼ��ĳЩֵ 
		void handle_token();							// ����ǰ��ȡ��token 
		void analyse();									// ���дʷ����� 
	
	public:
		LexicalAnalysis(ifstream& infile): infile(infile) {
			analyse();									// ��ʼ�ʷ����� 
		}
		vector<TokenInfo> getTokens() {
			return tokens;								// ���ط�������token 
		}
		bool success() {
			return !compile_error;						// �ʷ������Ƿ�ɹ� 
		}
};

#endif
