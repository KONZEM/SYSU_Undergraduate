/*
����Ǵ����ŵ����֣�һ��Ҫ�����ţ�����-2�ڱ��ʽ��Ϊ(-2)��+2ͬ�� 
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
	// ���������е����һ���ӺŻ���� 
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
	// ���������е����һ���˺Ż���� 
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
	s��������������ʽ
	l��Ԥ�������������ʽ�ĳ��� 
	*/
	string* ps = new string [500];
	int l = s.length();
	bool last_is_num = 0;
	len = 0;
	for (int i=0; i<l; ++i) {
		// ������ 
		if ((s[i] >= '0' && s[i] <= '9') || s[i] == '.'){
			ps[len] += s[i];
			last_is_num = 1;
		}
		// ������ 
		else if (s[i] == '+' || s[i] == '-' || s[i] == '*' || s[i] == '/' || s[i] == '(' || s[i] == ')'){
			if (last_is_num) {
				len++;
				last_is_num = 0;
			}
			// ���� 
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
		// ��Ч�ַ� 
		else if (s[i] != ' ') return NULL;
	}
	return ps;
}

int main() {
	string s;
	int len;
	while (1) {
		cout << "�������������ʽ������END��������" << endl;
		getline(cin, s);		// �����������ʽ 
		transform(s.begin(), s.end(), s.begin(), ::tolower); 		// תСд 
		if (s == "end") break; 
		// Ԥ����������������ʽ
		string* ps = preprocess(s, len); 
//		for (int i=0; ps[i]!=""; ++i) cout << ps[i] << ' ';
		if (!ps) {
			cout << "������Ч���ţ�����������" << endl << endl;
			continue; 
		} 
		// ת��Ϊ�沨�����ʽ 
		cout << "���沨�����ʽΪ��" << endl; 
		E(ps, 0, len-1);
//		 �汾2 
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
