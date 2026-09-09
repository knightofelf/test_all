// 간단한 RSA 구현 예시 (실제 서비스용 아님)

function gcd(a, b) {
  return b === 0 ? a : gcd(b, a % b);
}

function modInverse(e, phi) {
  let [old_r, r] = [e, phi];
  let [old_s, s] = [1, 0];
  while (r !== 0) {
    let q = Math.floor(old_r / r);
    [old_r, r] = [r, old_r - q * r];
    [old_s, s] = [s, old_s - q * s];
  }
  return (old_s + phi) % phi;
}

// 키 생성
let p = 61, q = 53;
let n = p * q;
let phi = (p - 1) * (q - 1);
let e = 17; // 공개 지수
let d = modInverse(e, phi); // 개인 지수

function encryptMessage() {
  let msg = document.getElementById("message").value;
  let bytes = stringToUtf8Bytes(msg);
  let cipher = Array.from(bytes).map(b => modPow(b, e, n).toString());
  document.getElementById("cipher").innerText = cipher.join(",");
}

function decryptMessage() {
  let cipherText = document.getElementById("cipher").innerText.split(",");
  let plainBytes = cipherText.map(c => Number(modPow(BigInt(c), d, n)));
  let plain = utf8BytesToString(plainBytes);
  document.getElementById("plain").innerText = plain;
}




function modPow(base, exp, mod) {
  let result = 1n;
  let b = BigInt(base);
  let e = BigInt(exp);
  let m = BigInt(mod);

  while (e > 0n) {
    if (e % 2n === 1n) {
      result = (result * b) % m;
    }
    b = (b * b) % m;
    e = e / 2n;
  }
  return result;
}


function stringToCodes(str) {
  return Array.from(str).map(ch => ch.charCodeAt(0));
}


function stringToUtf8Bytes(str) {
  return new TextEncoder().encode(str); // UTF-8 바이트 배열
}

function utf8BytesToString(bytes) {
  return new TextDecoder().decode(new Uint8Array(bytes));
}


