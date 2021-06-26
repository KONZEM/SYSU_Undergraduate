/*
Author: KONZEM
Date: 2020/06/28
File Name: intermediate_code_generation.cpp
Usage: semantic analysis and intermedia code gengeration
Core Knowledge: 1. back patch 2. merge 
*/

#include "intermediate_code_generation.h"

string Code::stmt() {
    switch (type) {
        case CODE_TYPE::UNKNOWN:
			break;
		case CODE_TYPE::START:
			return "start";
        case CODE_TYPE::END:
			return "end";
		case CODE_TYPE::READ:
            return "read " + p3;
        case CODE_TYPE::WRITE:
            return "write " + p3;
        case CODE_TYPE::ASSIGN:
            return p3 + " := " + p1;
        case CODE_TYPE::JUMP:
            return "goto " + p3;
        case CODE_TYPE::JUMP_LSS:
            return "if " + p1 + " < " + p2 + " goto " + p3;
        case CODE_TYPE::JUMP_GRT:
            return "if " + p1 + " > " + p2 + " goto " + p3;
        case CODE_TYPE::JUMP_EQU:
            return "if " + p1 + " = " + p2 + " goto " + p3;
        case CODE_TYPE::JUMP_LEQ:
            return "if " + p1 + " <= " + p2 + " goto " + p3;
        case CODE_TYPE::JUMP_GEQ:
            return "if " + p1 + " >= " + p2 + " goto " + p3;
        case CODE_TYPE::ADD:
            return p3 + " := " + p1 + " + " + p2;
        case CODE_TYPE::SUB:
            return p3 + " := " + p1 + " - " + p2;
        case CODE_TYPE::MUL:
            return p3 + " := " + p1 + " * " + p2;
        case CODE_TYPE::DIV:
            return p3 + " := " + p1 + " / " + p2;
        case CODE_TYPE::GRT:
        	return p3 + " := " + p1 + " > " + p2;
        case CODE_TYPE::GEQ:
        	return p3 + " := " + p1 + " >= " + p2;
        case CODE_TYPE::LSS:
        	return p3 + " := " + p1 + " < " + p2;
        case CODE_TYPE::LEQ:
        	return p3 + " := " + p1 + " <= " + p2;
        case CODE_TYPE::EQU:
        	return p3 + " := " + p1 + " = " + p2;
		case CODE_TYPE::AND:
            return p3 + " := " + p1 + " and " + p2;
        case CODE_TYPE::OR:
            return p3 + " := " + p1 + " or " + p2;
        case CODE_TYPE::NOT:
            return p3 + " := " + " not " + p1;
    }
    return "";
}

Generator::Generator(TreeNode* root) {
	codes.push_back(gen_code(CODE_TYPE::START, "", "", ""));
	generate(root);
	for (auto* code: codes) 
		if (code->jump_addr != -1)
			code->p3 = to_string(code->jump_addr);
	codes.push_back(gen_code(CODE_TYPE::END, "", "", ""));
}

// 生成一条中间代码 
Code* Generator::gen_code(CODE_TYPE type, string p1, string p2, string p3) {
	Code* code = new Code;
	code->addr = codes.size();
	code->type = type;
	code->p1 = p1;
	code->p2 = p2;
	code->p3 = p3;
	return code; 
}

// 回添跳转地址 
void Generator::back_patch(int a, int b) {
	Code* code = codes[a];
//	cout << "in back_patch" << endl;
	while (code != NULL) {
//		cout << code->addr << ' ' << a << endl;
//		if (b < codes.size())
//			cout << codes[b]->addr << ' ' << b << endl;
//		else 
//			cout << b << endl;
		code->jump_addr = b;
		code = code->next;
	}
//	cout << endl;
}

// 合并相同的跳转地址 
int Generator::merge(int a, int b) {
	Code* code1 = codes[a];
	Code* code2 = codes[b];
	int addr = code2->addr;
//	cout << "in merge" << endl;
//	cout << code1->addr << ' ' << a << endl;
//	cout << code2->addr << ' ' << b << endl;
	while(code2->next != NULL) 
		code2 = code2->next;
//	cout << code2->addr << endl << endl;
	code2->next = code1;
	return addr;
}

void Generator::jump(TreeNode* node, CODE_TYPE type, string p1, string p2) {
	node->_true = codes.size();
	node->_begin = node->_true;
	node->_false = node->_true + 1;
	codes.push_back(gen_code(type, p1, p2, ""));							// 条件跳转 
	codes.push_back(gen_code(CODE_TYPE::JUMP, "", "", ""));				// 无条件跳转 
}

string Generator::generate(TreeNode* node, STMT_TYPE stmt_type) {
    if (node == NULL)
        return "";
    std::string name;
    switch (node->node_type) {
    	case NODE_TYPE::STMT_SEQUENCE: {
            for (TreeNode* child: node->children)
            	generate(child, stmt_type);
            break;
        }
        case NODE_TYPE::IF_STMT: {
            node->children[1]->_begin = codes.size();
            generate(node->children[1], STMT_TYPE::ST_CONDITION);
            int then_b = codes.size();
            generate(node->children[3], STMT_TYPE::ST_CONDITION);
            Code* code = gen_code(CODE_TYPE::JUMP, "-", "-", "");
            codes.push_back(code);
            int else_b = codes.size();
            if (node->children.size() > 5)
            	generate(node->children[5], STMT_TYPE::ST_CONDITION);
            code->jump_addr = codes.size();
            back_patch(node->children[1]->_false, else_b);
            back_patch(node->children[1]->_true, then_b);
            break;
        }
        case NODE_TYPE::READ_STMT:
            codes.push_back(gen_code(CODE_TYPE::READ, "", "", node->children[1]->token->token));
            break;
        case NODE_TYPE::WRITE_STMT: {
            codes.push_back(gen_code(CODE_TYPE::WRITE, "", "", node->children[1]->token->token));
            break;
        }
        case NODE_TYPE::REPEAT_STMT: {
            int repeat_b = codes.size();
            generate(node->children[1], STMT_TYPE::ST_CONDITION);
            node->children[3]->_begin = codes.size();
            generate(node->children[3], STMT_TYPE::ST_CONDITION);
            back_patch(node->children[3]->_true, repeat_b);
            back_patch(node->children[3]->_false, codes.size());
            break;
        }
        case NODE_TYPE::WHILE_STMT: {
            node->children[1]->_begin = codes.size();
            generate(node->children[1], STMT_TYPE::ST_CONDITION); 
            int while_t = codes.size();
            generate(node->children[3], STMT_TYPE::ST_CONDITION); 
            back_patch(node->children[1]->_true, while_t);
            back_patch(node->children[1]->_false, codes.size() + 1);
            codes.push_back(gen_code(CODE_TYPE::JUMP, "", "", to_string(node->children[1]->_begin)));
            break;
        }
        case NODE_TYPE::ASSIGN_STMT: {
            name = generate(node->children[2], STMT_TYPE::ST_ASSIGN);
            codes.push_back(gen_code(CODE_TYPE::ASSIGN, name, "", node->children[0]->token->token));
            break;
        }
        case NODE_TYPE::GRT_EXP: {
            string t1 = generate(node->children[0], stmt_type);
            string t2 = generate(node->children[2], stmt_type);
            if (stmt_type == STMT_TYPE::ST_CONDITION)						// 条件跳转 
            	jump(node, CODE_TYPE::JUMP_GRT, t1, t2);
            else {															// 赋值 
				name = get_tmp_var();
                codes.push_back(gen_code(CODE_TYPE::GRT, t1, t2, name));
			}
            break;
        }
        case NODE_TYPE::GEQ_EXP: {
            string t1 = generate(node->children[0], stmt_type);
            string t2 = generate(node->children[2], stmt_type);
            if (stmt_type == STMT_TYPE::ST_CONDITION) 						// 条件跳转 			
            	jump(node, CODE_TYPE::JUMP_GEQ, t1, t2);
            else {															// 赋值 
				name = get_tmp_var();
                codes.push_back(gen_code(CODE_TYPE::GEQ, t1, t2, name));
			}
            break;
        }
        case NODE_TYPE::LSS_EXP: {
            string t1 = generate(node->children[0], stmt_type);
            string t2 = generate(node->children[2], stmt_type);
            if (stmt_type == STMT_TYPE::ST_CONDITION)						// 条件跳转
            	jump(node, CODE_TYPE::JUMP_LSS, t1, t2);
            else {															// 赋值 
				name = get_tmp_var();
                codes.push_back(gen_code(CODE_TYPE::LSS, t1, t2, name));
			}
			break;
        }
        case NODE_TYPE::LEQ_EXP: {										
            string t1 = generate(node->children[0], stmt_type);
            string t2 = generate(node->children[2], stmt_type);
            if (stmt_type == STMT_TYPE::ST_CONDITION)						// 条件跳转 
            	jump(node, CODE_TYPE::JUMP_LEQ, t1, t2);
            else {															// 赋值 
				name = get_tmp_var();
                codes.push_back(gen_code(CODE_TYPE::LEQ, t1, t2, name));
			}
            break;
        }
        case NODE_TYPE::EQU_EXP: {											
            string t1 = generate(node->children[0], stmt_type);
            string t2 = generate(node->children[2], stmt_type);
            if (stmt_type == STMT_TYPE::ST_CONDITION)						// 条件跳转 
            	jump(node, CODE_TYPE::JUMP_EQU, t1, t2);
            else {															// 赋值 
				name = get_tmp_var();
                codes.push_back(gen_code(CODE_TYPE::EQU, t1, t2, name));
			}
            break;
        }
        case NODE_TYPE::AND_EXP: {								
            string t1 = generate(node->children[0], stmt_type);
            string t2 = generate(node->children[2], stmt_type);	
            if (stmt_type == STMT_TYPE::ST_CONDITION) {						// 条件跳转 
                back_patch(node->children[0]->_true, node->children[2]->_begin);
                node->_begin = node->children[0]->_begin;
                node->_true = node->children[2]->_true;
                node->_false = merge(node->children[0]->_false, node->children[2]->_false);
            } else {														// 赋值 
                name = get_tmp_var();
                codes.push_back(gen_code(CODE_TYPE::AND, t1, t2, name));
            }
            break;
        }
        case NODE_TYPE::OR_EXP: {
            string t1 = generate(node->children[0], stmt_type); 
            string t2 = generate(node->children[2], stmt_type);
            if (stmt_type == STMT_TYPE::ST_CONDITION) {						// 条件跳转 
                back_patch(node->children[0]->_false, node->children[2]->_begin);
                node->_begin = node->children[0]->_begin;
                node->_true = merge(node->children[0]->_true, node->children[2]->_true);
                node->_false = node->children[2]->_false;
            } else {														// 赋值 
                name = get_tmp_var();
                codes.push_back(gen_code(CODE_TYPE::OR, t1, t2, name));
            }
            break;
        }
        case NODE_TYPE::NOT_EXP: {
            string t = generate(node->children[1, stmt_type]);
            if (stmt_type == STMT_TYPE::ST_CONDITION) {						// 条件跳转 
                node->_begin = node->children[1]->_begin;
                node->_true = node->children[1]->_false;
                node->_false = node->children[1]->_true;
            } else {														// 赋值 
                name = get_tmp_var();						
                codes.push_back(gen_code(CODE_TYPE::NOT, t, "", name));
            }
            break;
        }
        case NODE_TYPE::ADD_EXP: {											// 四则运算只能是赋值 
            string t1 = generate(node->children[0], stmt_type);
            string t2 = generate(node->children[2], stmt_type);
            name = get_tmp_var();
            codes.push_back(gen_code(CODE_TYPE::ADD, t1, t2, name));
            break;
        }
        case NODE_TYPE::SUB_EXP: {
            string t1 = generate(node->children[0], stmt_type);
            string t2 = generate(node->children[2], stmt_type);
            name = get_tmp_var();
            codes.push_back(gen_code(CODE_TYPE::SUB, t1, t2, name));
            break;
        }
        case NODE_TYPE::MUL_EXP: {
            string t1 = generate(node->children[0], stmt_type);
            string t2 = generate(node->children[2], stmt_type);
            name = get_tmp_var();
            codes.push_back(gen_code(CODE_TYPE::MUL, t1, t2, name));
            break;
        }
        case NODE_TYPE::DIV_EXP: {
            string t1 = generate(node->children[0], stmt_type);
            string t2 = generate(node->children[2], stmt_type);
            name = get_tmp_var();
            codes.push_back(gen_code(CODE_TYPE::DIV, t1, t2, name));
            break;
        }
        case NODE_TYPE::FACTOR: {
            name = node->token->token;
            // 类型为bool，是条件语句的子节点 
            if (node->value_type == VALUE_TYPE::VT_BOOL && stmt_type == STMT_TYPE::ST_CONDITION) {
                node->_true = codes.size();
                node->_begin = node->_true;
                node->_false = node->_true + 1;
                codes.push_back(gen_code(CODE_TYPE::JUMP_EQU, node->token->token, "true", ""));
                codes.push_back(gen_code(CODE_TYPE::JUMP, "", "", ""));
            }
            break;
        }
        default:
            break;
    }
    return name;
}

