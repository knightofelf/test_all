#include <iostream>
#include <string>
#include <vector>
#include <algorithm>
#include <sstream>

using namespace std;

struct AbacusColumn {
    string upper;       
    string beam;        
    vector<string> lower; 
    char digit;         
    bool isFraction;    
};

// [문자열 도우미] 3자리마다 콤마 삽입
string formatWithCommas(const string& numStr) {
    if (numStr.empty() || numStr == "0") return "0";
    string res = "";
    int count = 0;
    for (int i = (int)numStr.length() - 1; i >= 0; --i) {
        res = numStr[i] + res;
        count++;
        if (count % 3 == 0 && i != 0) {
            res = "," + res;
        }
    }
    return res;
}

// [문자열 도우미] 정수부와 소수부 분리 및 패딩 제거
void parseScaledStrings(const string& totalStr, int decimalCount, string& intPart, string& fracPart) {
    string temp = totalStr;
    if ((int)temp.length() <= decimalCount) {
        temp = string(decimalCount + 1 - temp.length(), '0') + temp;
    }
    int totalLen = temp.length();
    int intLen = totalLen - decimalCount;

    intPart = (intLen > 0) ? temp.substr(0, intLen) : "0";
    fracPart = (decimalCount > 0) ? temp.substr(intLen) : "";
    
    while (intPart.length() > 1 && intPart[0] == '0') {
        intPart = intPart.substr(1);
    }
}

// [문자열 도우미] 입력 문자열을 소수 자릿수에 맞춰 정수형 문자열로 변환
string scaleInputString(string inputStr, int decimalCount) {
    if (inputStr.find('.') == string::npos) {
        return inputStr + string(decimalCount, '0');
    }
    size_t dotPos = inputStr.find('.');
    string intPart = inputStr.substr(0, dotPos);
    string fracPart = inputStr.substr(dotPos + 1);
    
    if ((int)fracPart.length() > decimalCount) {
        fracPart = fracPart.substr(0, decimalCount);
    } else {
        fracPart += string(decimalCount - fracPart.length(), '0');
    }
    return intPart + fracPart;
}

// [문자열 연산] 무한 자릿수 덧셈 (num1 + num2)
string stringAdd(string num1, string num2) {
    string res = "";
    int i = num1.length() - 1, j = num2.length() - 1, carry = 0;
    while (i >= 0 || j >= 0 || carry) {
        int sum = carry;
        if (i >= 0) sum += num1[i--] - '0';
        if (j >= 0) sum += num2[j--] - '0';
        carry = sum / 10;
        stringstream ss;
        ss << (sum % 10);
        res += ss.str();
    }
    reverse(res.begin(), res.end());
    return res;
}

// [문자열 연산] 무한 자릿수 크기 비교 (num1 >= num2 이면 true)
bool isGreaterOrEqual(string num1, string num2) {
    while(num1.length() > 1 && num1[0] == '0') num1 = num1.substr(1);
    while(num2.length() > 1 && num2[0] == '0') num2 = num2.substr(1);
    if (num1.length() != num2.length()) return num1.length() > num2.length();
    return num1 >= num2;
}

// [문자열 연산] 무한 자릿수 뺄셈 (num1 - num2, 단 num1 >= num2 보장되어야 함)
string stringSubtract(string num1, string num2) {
    string res = "";
    int i = num1.length() - 1, j = num2.length() - 1, borrow = 0;
    while (i >= 0 || j >= 0) {
        int diff = (num1[i--] - '0') - borrow;
        if (j >= 0) diff -= (num2[j--] - '0');
        if (diff < 0) {
            diff += 10;
            borrow = 1;
        } else {
            borrow = 0;
        }
        stringstream ss;
        ss << diff;
        res += ss.str();
    }
    reverse(res.begin(), res.end());
    while (res.length() > 1 && res[0] == '0') res = res.substr(1);
    return res;
}

// [문자열 연산] 무한 자릿수 곱셈 (num1 * num2) 후 SCALE 보정
string stringMultiply(string num1, string num2, int decimalCount) {
    int n = num1.length(), m = num2.length();
    vector<int> result(n + m, 0);
    for (int i = n - 1; i >= 0; i--) {
        for (int j = m - 1; j >= 0; j--) {
            int mul = (num1[i] - '0') * (num2[j] - '0');
            int p1 = i + j, p2 = i + j + 1;
            int sum = mul + result[p2];
            result[p2] = sum % 10;
            result[p1] += sum / 10;
        }
    }
    string res = "";
    for (int num : result) {
        if (!(res.empty() && num == 0)) {
            stringstream ss; ss << num; res += ss.str();
        }
    }
    if (res.empty()) return "0";
    // 배율 보정: 곱셈 연산 시 SCALE이 제곱되므로 decimalCount 만큼 뒤를 잘라냄
    if ((int)res.length() <= decimalCount) return "0";
    return res.substr(0, res.length() - decimalCount);
}

// [문자열 연산] 무한 자릿수 나눗셈 나눗셈(몫) 후 SCALE 보정
string stringDivide(string num1, string num2, int decimalCount) {
    // 나누기 전에 피제수(num1)에 SCALE(10^decimalCount)을 곱해 정밀도를 확보
    num1 += string(decimalCount, '0');
    while(num1.length() > 1 && num1[0] == '0') num1 = num1.substr(1);
    while(num2.length() > 1 && num2[0] == '0') num2 = num2.substr(1);
    if (num2 == "0") return "ERROR_DIV_ZERO";
    if (!isGreaterOrEqual(num1, num2)) return "0";

    string res = "", temp = "";
    for (int i = 0; i < (int)num1.length(); i++) {
        temp += num1[i];
        while(temp.length() > 1 && temp[0] == '0') temp = temp.substr(1);
        int count = 0;
        while (isGreaterOrEqual(temp, num2)) {
            temp = stringSubtract(temp, num2);
            count++;
        }
        stringstream ss; ss << count; res += ss.str();
    }
    while (res.length() > 1 && res[0] == '0') res = res.substr(1);
    return res;
}

// 주판 데이터 생성 매핑 함수
AbacusColumn createAbacusColumn(char digitChar, bool isFraction) {
    int digit = digitChar - '0';
    AbacusColumn col;
    col.digit = digitChar;
    col.isFraction = isFraction;
    col.beam = "===";
    col.upper = (digit >= 5) ? " | " : "   ";

    int activeLower = digit % 5;
    col.lower.resize(4, "   ");
    for (int b = 0; b < 4; ++b) {
        col.lower[b] = (b < activeLower) ? " | " : "   ";
    }
    return col;
}

// 화면 및 주판 렌더링 함수
void printAbacus(const string& totalStr, int decimalCount) {
    string intPart, fracPart;
    parseScaledStrings(totalStr, decimalCount, intPart, fracPart);

    cout << "\n========================================================================\n";
    cout << " VALUE: " << formatWithCommas(intPart);
    if (decimalCount > 0) cout << "." << fracPart;
    cout << "\n========================================================================\n";

    string abacusStr = intPart + fracPart;
    int totalLen = abacusStr.length();

    vector<AbacusColumn> columns;
    for (int i = 0; i < totalLen; ++i) {
        bool isFrac = (totalLen - i) <= decimalCount;
        columns.push_back(createAbacusColumn(abacusStr[i], isFrac));
    }

    int colsCount = columns.size();
    
    // 1. 윗알 영역
    cout << "  ";
    for (int i = 0; i < colsCount; ++i) {
        if (decimalCount > 0 && colsCount - i == decimalCount) cout << " : "; 
        cout << columns[i].upper;
    }
    cout << "\n";

    // 2. 가름대
    cout << "  ";
    for (int i = 0; i < colsCount; ++i) {
        if (decimalCount > 0 && colsCount - i == decimalCount) cout << " : ";
        cout << columns[i].beam;
    }
    cout << "  <= 가름대\n";

    // 3. 아래알 4줄
    for (int row = 0; row < 4; ++row) {
        cout << "  ";
        for (int i = 0; i < colsCount; ++i) {
            if (decimalCount > 0 && colsCount - i == decimalCount) cout << " : ";
            cout << columns[i].lower[row];
        }
        cout << "\n";
    }

    // 4. 하단 숫자 레이블
    cout << "  ";
    for (int i = 0; i < colsCount; ++i) {
        if (decimalCount > 0 && colsCount - i == decimalCount) cout << " . ";
        cout << " " << columns[i].digit << " ";
    }
    cout << "\n\n";
}

int main() {
    int decimalCount = 20; // 20자리 고정 확장
    string totalStr = "0"; // 초기값 0

    cout << "========================================================================\n";
    cout << "      ?? InfAbacus (Pure String 사칙연산 에디션)      \n";
    cout << "      소수점 자릿수: " << decimalCount << "자리 고정 연산 모드\n";
    cout << "========================================================================\n";

    printAbacus(totalStr, decimalCount);

    while (true) {
        cout << "명령 입력 (예: 123456.123456, -100.5, *2.5, /2, 종료: q): ";
        string input;
        cin >> input;

        if (input == "q" || input == "Q") {
            cout << "계산기를 종료합니다.\n";
            break;
        }

        char op = input[0];
        string rawNum = "";

        if (op == '+' || op == '-' || op == '*' || op == '/') {
            rawNum = input.substr(1);
        } else {
            op = '+';
            rawNum = input;
        }

        // 입력 문자열 검증 및 배율 스케일링
        string scaledInput = scaleInputString(rawNum, decimalCount);

        if (op == '+') {
            totalStr = stringAdd(totalStr, scaledInput);
        } 
        else if (op == '-') {
            if (!isGreaterOrEqual(totalStr, scaledInput)) {
                cout << "? 주판은 음수 결과를 표현할 수 없습니다!\n";
                continue;
            }
            totalStr = stringSubtract(totalStr, scaledInput);
        } 
        else if (op == '*') {
            // 주판 스케일 유지를 위해 함수 내부에서 보정이 일어납니다.
            totalStr = stringMultiply(totalStr, scaledInput, decimalCount);
        } 
        else if (op == '/') {
            string checkDiv = scaleInputString(rawNum, decimalCount);
            while(checkDiv.length() > 1 && checkDiv[0] == '0') checkDiv = checkDiv.substr(1);
            if (checkDiv == "0") {
                cout << "? 0으로 나눌 수 없습니다!\n";
                continue;
            }
            totalStr = stringDivide(totalStr, scaledInput, decimalCount);
        }

        printAbacus(totalStr, decimalCount);
    }

    return 0;
}

