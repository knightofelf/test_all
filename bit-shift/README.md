# bit-shift
✅ 왼쪽 이동은 N진수의 거듭제곱 곱하기, 오른쪽 이동은 N의 거듭제곱 나누기(몫) <br>
Left shift means multiplying by powers of N, right shift means dividing by powers of N (integer quotient). <br>
✅ 비트를 좌로 이동하면 제곱.  우로 이동하면 제곱근 비슷 <br>
<pre>
2진수 = N*2 or N/2 
1000 = 8 
0100 = 4 
0010 = 2 

16진수 = N*16 or N/16 
C0 00 = 49152 
0C 00 = 3072 
00 C0 = 192 
00 0C = 12 
</pre>
<br>
<br>
제곱근 (제곱의 반대) 비슷 구하기 = (다진법) 진수 비트 0빼기  <br>
“Square root (inverse of squaring) = remove trailing zeros in N‑ary bit notation.”  <br>

<pre>
2진수. 마지막이 1인 경우는 1을 빼고. 0을 뺀다 ㅇ_ㅇ;;
다진수. 마지막이 N인 경우. N을 빼고. 0을 뺀다 ㅇ_ㅇ’’

16진수 HEX - 시프트(Shift) 또는 자리 이동(16)
C0 =                             C =        C7 =               
(C x 16) + 0 =                   12         (C x 16) + 7 =  
(12 x 16) + 0 = 192
</pre>
