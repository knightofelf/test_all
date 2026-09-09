#include <iostream>
#include <string>
#include <vector>
#include <algorithm>

using namespace std;

// 주판 한 열의 그래픽 데이터를 담는 구조체
struct AbacusColumn {
    string upper;       // 윗알 (5)
    string beam;        // 가름대
    vector<string> lower; // 아래알 4개
    char digit;         // 현재 자릿수 숫자
    bool isFraction;    // 소수점 아래 자리 여부
};

// 3자리마다 콤마를 찍어주는 함수 (문자열 기반)
string formatWithCommas(const string& numStr) {
    if (numStr.empty()) return "0";
    string res = "";
    int count = 0;
    for (int i = numStr.length() - 1; i >= 0; --i) {
        res = numStr[i] + res;
        count++;
        if (count % 3 == 0 && i != 0) {
            res = "," + res;
        }
    }
    return res;
}

// 숫자 하나(char)를 주판 열 데이터로 변환하는 전통 주판 원리 함수
AbacusColumn createAbacusColumn(char digitChar, bool isFraction) {
    int digit = digitChar - '0';
    AbacusColumn col;
    col.digit = digitChar;
    col.isFraction = isFraction;
    col.beam = "===";

    // 1. 윗알 원리 (5 이상이면 아래로 내려와 가름대에 밀착)
    col.upper = (digit >= 5) ? " | " : "   ";

    // 2. 아래알 원리 (5로 나눈 나머지 개수만큼 위로 올라와 가름대에 밀착)
    int activeLower = digit % 5;
    col.lower.resize(4, "   ");
    
    // 가름대에 붙은 알은 '|', 떨어진 알은 ' '로 표현
    for (int b = 0; b < 4; ++b) {
        if (b < activeLower) {
            col.lower[b] = " | "; // 위로 붙은 활성알
        } else {
            col.lower[b] = "   "; // 바닥에 가라앉은 알
        }
    }
    return col;
}

// 현재 주판의 모든 열을 화면에 그래픽으로 출력하는 함수
void printAbacus(const string& totalStr, int decimalCount) {
    // 자릿수가 소수점 설정보다 짧으면 앞에 0을 채우는 패딩
    string tempStr = totalStr;
    if ((int)tempStr.length() <= decimalCount) {
        tempStr = string(decimalCount + 1 - tempStr.length(), '0') + tempStr;
    }

    int totalLen = tempStr.length();
    int intLen = totalLen - decimalCount;

    // 정수부와 소수부 문자열 분리
    string intPart = (intLen > 0) ? tempStr.substr(0, intLen) : "0";
    string fracPart = (decimalCount > 0) ? tempStr.substr(intLen) : "";

    // 텍스트 디스플레이 출력
    cout << "\n=============================================\n";
    cout << " VALUE: " << formatWithCommas(intPart);
    if (decimalCount > 0) cout << "." << fracPart;
    cout << "\n=============================================\n";

    // 주판 열들 구조화
    vector<AbacusColumn> columns;
    for (int i = 0; i < totalLen; ++i) {
        bool isFrac = (totalLen - i) <= decimalCount;
        columns.push_back(createAbacusColumn(tempStr[i], isFrac));
    }

    // --- 주판 프레임 렌더링 시작 ---
    int colsCount = columns.size();
    
    // 1. 윗알 영역 출력
    cout << "  ";
    for (int i = 0; i < colsCount; ++i) {
        if (decimalCount > 0 && colsCount - i == decimalCount) cout << " : "; // 소수점 가리개 장대
        cout << columns[i].upper;
    }
    cout << "\n";

    // 2. 가름대 (梁) 출력
    cout << "  ";
    for (int i = 0; i < colsCount; ++i) {
        if (decimalCount > 0 && colsCount - i == decimalCount) cout << " : ";
        cout << columns[i].beam;
    }
    cout << "  <= 가름대\n";

    // 3. 아래알 4줄 출력 (실제 주판과 동일하게 위에서부터 배치)
    for (int row = 0; row < 4; ++row) {
        cout << "  ";
        for (int i = 0; i < colsCount; ++i) {
            if (decimalCount > 0 && colsCount - i == decimalCount) cout << " : ";
            cout << columns[i].lower[row];
        }
        cout << "\n";
    }

    // 4. 하단 숫자 레이블 출력
    cout << "  ";
    for (int i = 0; i < colsCount; ++i) {
        if (decimalCount > 0 && colsCount - i == decimalCount) cout << " . ";
        cout << " " << columns[i].digit << " ";
    }
    cout << "\n\n";
}

int main() {
    // Dev-C++ 인코딩 및 콘솔 속도 최적화
    ios_base::sync_with_stdio(false);
    cin.tie(NULL);

    cout << "=========================================\n";
    cout << "      ?? InfAbacus (Dev-C++ Ver)      \n";
    cout << "=========================================\n";
    
    // 초거대 자릿수 연산을 위해 문자열 형태로 주판 숫자를 유지
    // 예시 구동을 위해 100자리 정수 형태의 숫자를 문자열로 세팅
    string mockTotal = "3423434234342343300000000000000000000000000000000000000000000000000000000000000000000000000000000000";
    int decimalCount = 2; // 소수점 아래 2자리 분할 고정

    // 100자리가 넘는 초거대 실수를 주판 원리로 출력
    printAbacus(mockTotal, decimalCount);

    cout << "아무 키나 누르면 종료됩니다...";
    cin.get(); 
    return 0;
}

