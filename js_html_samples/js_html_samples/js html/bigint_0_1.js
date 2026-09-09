





var BIG_UNIT = 100000;
/*
var A = bset( "-98050450640" );
var B = bset( "-3500005555001" );
var C = bset( "-3498759375030945y358375753873857875758305873876" );

_debug("A = " + bshow( A ) );
_debug("B = " + bshow( B ) );
_debug("C = " + bshow( C ) );

var test1 = bmul( badd( A, B ), C );
var test2 = badd( bmul( A, C ), bmul( B, C) ) ;

_debug("(A+B)*C = " + bshow( test1 ) );
_debug("AC + BC = " + bshow( test2 ) );
if( babscmp( test2, test1 ) == 0) _debug("* OK");
else _debug("NOT OK");

var objDate = new Date();
var cost = objDate.getTime() - tick0;
_debug("Cost " + cost/1000 + " sec");
*/

function bmul( B1, B2 ) {

	if( !isBigInt(B1) || !isBigInt(B2) ) return null;

	var zeros, _mul;
	var Work = bset("0");


	for( var idx1=0; idx1 < B1.length; idx1++ ) {
		for( var idx2=0; idx2 <B2.length; idx2++ ) {
			zeros = getZeros( ( idx1 + idx2 )*5 );
			_mul = ( B1[idx1] * B2[idx2] ).toString(10) + zeros;
			Work = badd( Work, bset(_mul) );
		}
	}

	return Work;

}

function getZeros( how_many ) {

	var _z = how_many % 10;
	var _z10 = (how_many - _z) / 10;

	var ret = "";

	for( var i = 0; i < _z10; i++ ) ret += "0000000000";
	for( var i = 0; i < _z; i++ ) ret += "0";

	return ret;
}



function bneg( B ) {
	if( !isBigInt( B ) ) return null;

	var ret = new Array();

	for( var i=0; i<B.length; i++ ) ret[i] = (-1) * B[i];
	return ret;
}


function badd( B1, B2 ) {

	if( !isBigInt(B1) || !isBigInt(B2) ) {
		return null;
	}

	var sign1 = bsign(B1), sign2 = bsign(B2);
	var ret_sign;

	// 結果の正負の判定
	if( sign1 * sign2 <0 ) {
		var abscmp = babscmp( B1, B2 );
		if( abscmp > 0 ) ret_sign = sign1;
		else if( abscmp < 0 ) ret_sign = sign2;
		else ret_sign = 1; // 符号だけ異なって絶対値が同じ、和はゼロ

	} else if( sign1 >= 0 ) {
		ret_sign = 1; // 正の数同士の足し算
	} else {
		ret_sign = -1; // 負の数同士の足し算
	}

	var sum = new Array();

	var max = Math.max( B1.length, B2.length );

	for( var i=0; i < max; i++ ) {
		sum[i] = 0;
		if( B1[i] ) sum[i] += B1[i];
		if( B2[i] ) sum[i] += B2[i];

		//_debug("B1[" + i + "] = " + B1[i]);
		//_debug("B2[" + i + "] = " + B2[i]);
		//_debug( "RAW sum[" + i + "] = " + sum[i]);
	}


	// くりあがり等
	for( var i=0; i<sum.length; i++ ) {
		if( ret_sign >= 0 ) { // 結果は非負
			while( sum[i] >= BIG_UNIT ) {
				sum[i]-=BIG_UNIT;
				if(typeof sum[i+1] == "number" ) sum[i+1]++;
				else sum[i+1] = 1;
			}
			while( sum[i] < 0 ) {
				sum[i]+=BIG_UNIT;
				if(typeof sum[i+1] == "number" ) sum[i+1]--;
				else _debug("[Unexpected] sum[i+1] undefined when i=" + i);
			}
		} else { // 結果は負
			while( sum[i] > 0 ) {
				sum[i]-=BIG_UNIT;
				if(typeof sum[i+1] == "number" ) sum[i+1]++;
				else _debug("[Unexpected] sum[i+1] undefined when i=" + i);
			}
			while( sum[i] <= - BIG_UNIT ) {
				sum[i]+=BIG_UNIT;
				if(typeof sum[i+1] == "number" ) sum[i+1]--;
				else sum[i+1] = -1;
			}
		}

		//_debug( "ANS sum[" + i + "] = " + sum[i]);

	}

	// 正と負の足し算の結果、打ち消し合って要素数が減る可能性を考慮する
	return bset( bshow( sum ) );
}

function bsub( B1, B2 ) {
	return ( badd( B1, bneg(B2) ) );
}



// bsign 符号を返す
function bsign( B ) {
	if(! isBigInt( B )) return null;

	for( var i=0; i<B.length; i++ ) {
		if(B[i]<0) return -1;
	}

	return 1;
}

// babscmp 2引数の絶対値の大小比較
function babscmp( _bi1, _bi2 ) {
	if(! isBigInt( _bi1 ) || !isBigInt( _bi2 ) ) return null;

	var B1 = new Array();
	var B2 = new Array();

	if(bsign( _bi1 )>=0) B1 = bcopy( _bi1 );
	else B1 = bneg( _bi1 );

	if(bsign( _bi2 )>=0) B2 = bcopy( _bi2 );
	else B2 = bneg( _bi2 );


	if( B1.length != B2.length ) {

		return B1.length - B2.length;
	}

	// 要素数が等しい
	var last_idx = B1.length - 1;

	for( var i = last_idx; i >=0; i-- ) {

		if( B1[i] != B2[i] ) return B1[i] - B2[i];
	}

	return 0;
}

// bcopy BigInt配列をコピー
function bcopy( B ) {
	if( !isBigInt( B ) ) return null;

	var ret = new Array();

	for( var i=0; i<B.length; i++ ) {
		ret[i] = B[i];
	}
	return ret;
}

// bshow BigInt配列を受け取り通常の十進法表示フォーマット文字列を返す
function bshow( B ) {
	if( !isBigInt( B ) ) return null;

	// フォーマットするのでコピーを操作する
	var Work = new Array();

	var sign;
	sign = bsign( B );


	// 非負であることが保証される
	if( sign<0 ) Work = bneg( B );
	else Work = bcopy( B );


	for( var i=0; i < Work.length; i++ ) {
		// 最大要素以外は0パディング
		if( i < Work.length-1 ) Work[i] = ( eval(Work[i]) + BIG_UNIT ).toString().substr( 1 , 5 );
	}

	// 桁区切りのスペースを入れる
	var str = my_reverse(Work).join(" ");

	// マイナスの数なら符号をつける
	if( sign < 0 ) {
		str = "- " + str;
	}

	return str;
}


function _debug( message ) {
	document.write("<p>Debug: " + message + ".<\/p>");
}


// bset 文字列を読んでBigInt配列に格納
function bset( str ) {

	if(!str) str="0";

	// 符号を判定する
	var sign;
	if( str.substr( 0, 1 ) == "-" ) sign = -1;
	else sign = 1;

	// 数字以外のものを無視して正規化
	var canon = "";
	var c;
	for( var i=0; i<str.length; i++ ) {
		c = str.substr( i, 1 );
		if( "0123456789".indexOf( c ) > -1 ) canon += c;
	}


	// 先頭の0を除去
	while( canon.substr( 0, 1 ) == "0" ) {
		canon = canon.substr( 1 , canon.length-1 );
	}


	// 何もなくなってしまったら0とみなす
	if(canon.length==0) {
		canon = "0";
		sign = 1;
	}

	// 格納先を作る
	var Work = new Array();

	// 要素の個数
	var size = Math.ceil( canon.length / 5 );

	// 最大要素の桁数
	var len0 = canon.length % 5;
	if(len0==0) len0=5;

	// とりあえず降順に格納。先頭には0がないので必ず十進法で評価される
	Work[0] = eval( canon.substr( 0, len0 ) );


	var pos = len0;
	var tmp;

	for( var i=1; i<size; i++ ) {
		tmp = canon.substr( pos , 5 );
		pos += 5;

		// 数値に変換。必ず十進法で評価されるよう0を消す
		Work[i] = eval( "1" + tmp ) - BIG_UNIT;

	}


	if( sign < 0 ) Work = bneg( Work );

	// 昇順にする
	return my_reverse( Work );

}

function my_reverse( list ) {
	if(!list || !list.length) return null;

	var ret = new Array();
	var last_idx = list.length-1;

	for( var i=0; i<list.length; i++ ) ret[i] = list[ last_idx - i ];

	return ret;
}


function isBigInt( a ) {
	if( typeof a != "object" ) return false;
	if( typeof a.length != "number" || a.length < 1 ) return false;
	for( var i=0; i<a.length; i++ ) {
		if( typeof a[i] != "number" ) return false;
		if( Math.abs( a[i] ) >= BIG_UNIT || Math.floor( a[i] ) != a[i] ) return false;
		if( i>=1 && a[i]*a[i-1]<0 ) {
			return false;
		}
	}

	return true;
}
