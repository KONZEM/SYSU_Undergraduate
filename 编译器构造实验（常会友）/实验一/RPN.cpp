#include <bits/stdc++.h>
using namespace std;

string RPN(string s) {
	stack<char> st;		// 存放运算符 
	string ans = "";		// 最终的逆波兰表达式 
	int l = s.length();		// 算数表达式字符串的长度 
	
	for (int i=0; i<l; ++i) {
		// 操作数部分 
		if ((s[i] >= '0' && s[i] <= '9') || s[i] == '.') ans += s[i];
		// 左括号直接进栈 
		else if (s[i] == '(') 	st.push(s[i]);
		// 右括号，出栈至 左括号 
		else if (s[i] == ')') {
			while (!st.empty() && st.top() != '(') {
				ans += ' ';
				ans += st.top();
				st.pop();
			}
			if (st.empty()) return "表达式无效";		// 没有对应的左括号 
			st.pop();		// 弹出左括号 
		}
		// 乘除运算符 
		else if (s[i] == '*' || s[i] == '/') {
			ans += ' ';
			// 出栈至 加减运算符 或者 左括号 或者 栈为空 
			while (!st.empty() && st.top()!= '(' && st.top() != '+' && st.top() != '-') {
				ans += st.top();
				ans += ' '; 
				st.pop();
			}
			st.push(s[i]);		// 当前运算符进栈 
		}
		// 加减运算符 
		else if (s[i] == '+' || s[i] == '-') {
			ans += ' ';
			// 栈至 左括号 或者 栈为空 
			while (!st.empty() && st.top() != '(') {
				ans += st.top();
				ans += ' ';
				st.pop();
			}
			st.push(s[i]);		// 当前运算符进栈 
		}
	}
	
	// 表达式扫描完，栈中还有运算符 
	while (!st.empty() && st.top() != '(') {
		ans += ' '; 
		ans += st.top();
		st.pop();
	}
	if (!st.empty()) return "表达式无效";		// 没有对应的右括号 
	
	return ans;
}

int main() {
	string s;
	while (1) {
		cout << "请输入中缀表达式：（输入END结束）" << endl;
		getline(cin, s);		// 输入表达式 
		transform(s.begin(), s.end(), s.begin(), ::tolower); 		// 转小写 
		if (s == "end") break; 
		cout << "逆波兰表达式为：" << endl;
		cout << RPN(s) << endl << endl << endl;
	}
	return 0;
} 
