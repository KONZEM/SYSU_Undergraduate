#include <bits/stdc++.h>
using namespace std;

string RPN(string s) {
	stack<char> st;		// �������� 
	string ans = "";		// ���յ��沨�����ʽ 
	int l = s.length();		// �������ʽ�ַ����ĳ��� 
	
	for (int i=0; i<l; ++i) {
		// ���������� 
		if ((s[i] >= '0' && s[i] <= '9') || s[i] == '.') ans += s[i];
		// ������ֱ�ӽ�ջ 
		else if (s[i] == '(') 	st.push(s[i]);
		// �����ţ���ջ�� ������ 
		else if (s[i] == ')') {
			while (!st.empty() && st.top() != '(') {
				ans += ' ';
				ans += st.top();
				st.pop();
			}
			if (st.empty()) return "���ʽ��Ч";		// û�ж�Ӧ�������� 
			st.pop();		// ���������� 
		}
		// �˳������ 
		else if (s[i] == '*' || s[i] == '/') {
			ans += ' ';
			// ��ջ�� �Ӽ������ ���� ������ ���� ջΪ�� 
			while (!st.empty() && st.top()!= '(' && st.top() != '+' && st.top() != '-') {
				ans += st.top();
				ans += ' '; 
				st.pop();
			}
			st.push(s[i]);		// ��ǰ�������ջ 
		}
		// �Ӽ������ 
		else if (s[i] == '+' || s[i] == '-') {
			ans += ' ';
			// ջ�� ������ ���� ջΪ�� 
			while (!st.empty() && st.top() != '(') {
				ans += st.top();
				ans += ' ';
				st.pop();
			}
			st.push(s[i]);		// ��ǰ�������ջ 
		}
	}
	
	// ���ʽɨ���꣬ջ�л�������� 
	while (!st.empty() && st.top() != '(') {
		ans += ' '; 
		ans += st.top();
		st.pop();
	}
	if (!st.empty()) return "���ʽ��Ч";		// û�ж�Ӧ�������� 
	
	return ans;
}

int main() {
	string s;
	while (1) {
		cout << "��������׺���ʽ��������END������" << endl;
		getline(cin, s);		// ������ʽ 
		transform(s.begin(), s.end(), s.begin(), ::tolower); 		// תСд 
		if (s == "end") break; 
		cout << "�沨�����ʽΪ��" << endl;
		cout << RPN(s) << endl << endl << endl;
	}
	return 0;
} 
