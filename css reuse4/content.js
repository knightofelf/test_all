// 데이터를 SHA-256 해시값으로 변환하는 함수 (100B 비교 대체 - 변조 및 동일성 체크)
async function getHash(textOrBlob) {
  const msgUint8 = typeof textOrBlob === "string" 
    ? new TextEncoder().encode(textOrBlob) 
    : new Uint8Array(await textOrBlob.arrayBuffer());
  const hashBuffer = await crypto.subtle.digest('SHA-256', msgUint8);
  const hashArray = Array.from(new Uint8Array(hashBuffer));
  return hashArray.map(b => b.toString(16).padStart(2, '0')).join('').substring(0, 10); // 앞 10자리만 사용
}

// 최초 방문 시 서버에서 오는 리소스를 가레채 보관함에 채우기
window.addEventListener("DOMContentLoaded", async () => {
  const resources = performance.getEntriesByType("resource");
  const hostname = window.location.hostname;

  chrome.storage.local.get({ sites: {} }, async (data) => {
    const sites = data.sites;
    if (!sites[hostname]) {
      sites[hostname] = { css: [], js: [], images: [] };
    }

    for (const res of resources) {
      try {
        if (!res.name.startsWith('http')) continue;
        
        const response = await fetch(res.name);
        const size = res.transferSize || res.encodedBodySize || 0;
        
        if (res.initiatorType === "css" || res.name.endsWith(".css")) {
          const content = await response.text();
          const hash = await getHash(content);
          if (!sites[hostname].css.some(c => c.url === res.name)) {
            sites[hostname].css.push({ url: res.name, size, hash, content });
          }
        } 
        else if (res.initiatorType === "script" || res.name.endsWith(".js")) {
          const content = await response.text();
          const hash = await getHash(content);
          if (!sites[hostname].js.some(j => j.url === res.name)) {
            sites[hostname].js.push({ url: res.name, size, hash, content });
          }
        } 
        else if (res.initiatorType === "img" || /\.(jpg|jpeg|png|gif|webp|svg)/i.test(res.name)) {
          const blob = await response.blob();
          const hash = await getHash(blob);
          
          // Blob 데이터를 스토리지에 저장하기 위해 Base64 데이터 URL로 변환
          const reader = new FileReader();
          reader.readAsDataURL(blob);
          reader.onloadend = () => {
            if (!sites[hostname].images.some(i => i.url === res.name)) {
              sites[hostname].images.push({ url: res.name, size, hash, content: reader.result });
              chrome.storage.local.set({ sites });
            }
          };
        }
      } catch (e) {
        // 교차 출처(CORS) 제한 등으로 가져오지 못한 리소스는 패스
      }
    }
    chrome.storage.local.set({ sites });
  });
});
