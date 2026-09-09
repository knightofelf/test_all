#include <iostream>
#include <cstdlib>
#include <ctime>
#include <cstring>

using namespace std;

// 源껎뿀釉?AI 媛 ?뺣━??肄붾뱶 ????;

    char order[10];
    int counts[8] = {0};  // Counter for each value (0-7)
    
// Generate random data with balanced distribution across 8 values
// Returns the count of generated values
int fn_rand_length()
{
    unsigned char vv[10];
    
    memset(order, 0x00, 10);
    memset(vv, 0x00, 10);
    memset(counts, 0x00, 8*sizeof(int));
    
    int index = 0;
    
    // Generate until all 8 values are generated at least once
    while (index < 8)
    {
        int random_val = rand() % 8;
        
        // If this value hasn't been generated yet
        if (counts[random_val] == 0)
        {
            vv[index] = '0' + random_val;
            order[index] = '0' + random_val;
            counts[random_val]++;
            index++;
        }
    }
    
    return index;  // Return count (always 8)
}

int main(int argc, char** argv)
{
    srand((unsigned int)time(NULL));
    
    // Test fn_rand_length()
    unsigned char rand_data[10];
    
    for (int i = 0; i < 10; i++)
    {
        int len = fn_rand_length();
        cout << "Generated " << len << " random values " ;
    	for (int j = 0; j < 8; j++)
	    {
    	    cout << order[j];
	    }
        cout << " ";
    	for (int j = 0; j < 8; j++)
	    {
    	    cout << counts[j];
	    }
        cout << endl;
    }
    
    return 0;
}
