/*
如果是带符号的数字，一定要加括号，例如-2在表达式中为(-2)，+2同理。 
*/ 

#include <bits/stdc++.h>

using namespace std;

//void E2(string*, int&);
//void T2(string*, int&);
//void F2(string*, int&);
//
//void E2(string* ps, int& index1) {
//	T2(ps, index1);
//	while (ps[index1] == "+" || ps[index1] == "-") {
//		string _operator = ps[index1++]; 
//		T2(ps, index1);
//		cout << _operator << ' ';
//	}
//}
//
//void T2(string* ps, int& index1) {
//	F2(ps, index1);
//	while (ps[index1] == "*" || ps[index1] == "/") {
//		string _operator = ps[index1++];
//		F2(ps, index1); 
//		cout << _operator << ' ';
//	}
//}
//
//void F2(string* ps, int& index1) {
//	string val = ps[index1++];
//	if (val == "(") {
//		E2(ps, index1);
//		index1++;	
//	}
//	else cout << val << ' ';
//	 
//}
void E(string*, int, int);
void T(string*, int, int);
void F(string*, int, int);

void E(string* ps, int start, int end) {
	int i;
	int parentheses = 0;
	// 不在括号中的最后一个加号或减号 
	for (i=end; i>=start; --i) {
		if (ps[i] == "(") parentheses--;
		if (ps[i] == ")") parentheses++;
		if (!parentheses && (ps[i] == "+" || ps[i] == "-")) break;
	}
	if (i >=start) {
		E(ps, start, i-1);
		T(ps, i+1, end);
		cout << ps[i] << ' ';
	}
	else T(ps, start, end);
}

void T(string* ps, int start, int end) {
	int i;
	int parentheses = 0;
	// 不在括号中的最后一个乘号或除号 
	for (i=end; i>=start; --i) {
		if (ps[i] == "(") parentheses--;
		if (ps[i] == ")") parentheses++;
		if (!parentheses && (ps[i] == "*" || ps[i] == "/")) break;
	}
	if (i >= start) {
		T(ps, start, i-1);
		F(ps, i+1, end);
		cout << ps[i] << ' ';
	}
	else F(ps, start, end);
}

void F(string* ps, int start, int end) {
	if (ps[start] == "(") E(ps, start+1, end-1);
	else cout << ps[start] << ' ';
}	

string* preprocess(string s, int& len) {
	/*
	s：输入的算术表达式
	l：预处理后的算术表达式的长度 
	*/
	string* ps = new string [500];
	int l = s.length();
	bool last_is_num = 0;
	len = 0;
	for (int i=0; i<l; ++i) {
		// 操作数 
		if ((s[i] >= '0' && s[i] <= '9') || s[i] == '.'){
			ps[len] += s[i];
			last_is_num = 1;
		}
		// 操作符 
		else if (s[i] == '+' || s[i] == '-' || s[i] == '*' || s[i] == '/' || s[i] == '(' || s[i] == ')'){
			if (last_is_num) {
				len++;
				last_is_num = 0;
			}
			// 负数 
			if (s[i-1] == '(' && (s[i] == '+' || s[i] == '-')) {
				int j;
				for (j=i; j<l && s[j] != ')'; ++j)
					ps[len] += s[j];
				i = j-1;
				len++;
			} 
			else 
				ps[len++] = s[i];
		}
		// 无效字符 
		else if (s[i] != ' ') return NULL;
	}
	return ps;
}

int main() {
	string s;
	int len;
	while (1) {
		cout << "请输入算术表达式（输入END结束）：" << endl;
		getline(cin, s);		// 输入算术表达式 
		transform(s.begin(), s.end(), s.begin(), ::tolower); 		// 转小写 
		if (s == "end") break; 
		// 预处理输入的算术表达式
		string* ps = preprocess(s, len); 
//		for (int i=0; ps[i]!=""; ++i) cout << ps[i] << ' ';
		if (!ps) {
			cout << "出现无效符号，请重新输入" << endl << endl;
			continue; 
		} 
		// 转换为逆波兰表达式 
		cout << "其逆波兰表达式为：" << endl; 
		E(ps, 0, len-1);
//		 版本2 
//		cout << endl;
//		int index1 = 0;
//		E2(ps, index1);
		cout << endl << endl;
	}
	return 0;
}

/*
3*(4+5/(2-1))
1.414 + 3.666 / (1.333-5.893)
21+42-30/(5+5)*(4-2)
*/
