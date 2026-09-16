document.addEventListener("DOMContentLoaded", () => {
  const listContainer = document.getElementById("site-list");

  chrome.storage.local.get({ sites: {} }, (data) => {
    const sites = data.sites;
    const domains = Object.keys(sites);

    if (domains.length === 0) {
      listContainer.innerHTML = "<div style='color:#999; text-align:center; padding:20px;'>저장된 사이트 리소스가 없습니다.</div>";
      return;
    }
    listContainer.innerHTML = "";

    domains.forEach(domain => {
      const site = sites[domain];
      
      // 용량 합산 연산
      const cssSize = site.css ? site.css.reduce((a, b) => a + b.size, 0) : 0;
      const jsSize = site.js ? site.js.reduce((a, b) => a + b.size, 0) : 0;
      const imgSize = site.images ? site.images.reduce((a, b) => a + b.size, 0) : 0;
      const totalSize = cssSize + jsSize + imgSize;

      const card = document.createElement("div");
      card.className = "site-card";
      card.innerHTML = `
        <div class="site-title">🌐 ${domain}</div>
        <div class="info-row"><span>🎨 CSS 재사용</span><span class="size-tag">${site.css?.length || 0}개 (${(cssSize/1024).toFixed(1)} KB)</span></div>
        <div class="info-row"><span>⚡ JS 재사용</span><span class="size-tag">${site.js?.length || 0}개 (${(jsSize/1024).toFixed(1)} KB)</span></div>
        <div class="info-row"><span>🖼️ 이미지(해시비교)</span><span class="size-tag">${site.images?.length || 0}개 (${(imgSize/1024).toFixed(1)} KB)</span></div>
        <div class="info-row" style="font-weight:bold; border:none;"><span style="color:#333;">총 절약된 대역폭</span><span style="color:#107c41;">${(totalSize/1024).toFixed(1)} KB</span></div>
        <div class="btn-group">
          <button class="view-btn" data-id="${domain}">📄 내용 확인</button>
          <button class="delete-btn" data-id="${domain}">🗑️ 캐시 삭제</button>
        </div>
      `;
      listContainer.appendChild(card);
    });

    // 클릭 이벤트 제어 리스너
    listContainer.addEventListener("click", (e) => {
      const domain = e.target.getAttribute("data-id");
      if (!domain) return;

      if (e.target.classList.contains("view-btn")) {
        // 내용 확인 기능: 새 탭을 열어 정밀하게 수집된 소스코드를 보여줌
        const targetSite = sites[domain];
        const logWindow = window.open("", "_blank");
        logWindow.document.write(`
          <html><head><title>${domain} 리소스 보관함</title></head><body style="font-family:monospace; padding:20px;">
          <h2>📦 [${domain}] 내부 저장 데이터 리스트</h2>
          <h3>CSS 파일 해시 정보 (${targetSite.css.length}개)</h3>
          <ul>${targetSite.css.map(c => `<li><b>해시[${c.hash}]:</b> ${c.url.substring(0, 70)}... (${c.size}B)</li>`).join('')}</ul>
          <h3>JS 파일 해시 정보 (${targetSite.js.length}개)</h3>
          <ul>${targetSite.js.map(j => `<li><b>해시[${j.hash}]:</b> ${j.url.substring(0, 70)}... (${j.size}B)</li>`).join('')}</ul>
          </body></html>
        `);
      } 
      else if (e.target.classList.contains("delete-btn")) {
        // 삭제 기능
        if (confirm(`[${domain}]의 로컬 저장소 캐시를 완전히 파기하시겠습니까? 다음 접속 시 서버에서 재전송을 받게 됩니다.`)) {
          delete sites[domain];
          chrome.storage.local.set({ sites }, () => {
            location.reload();
          });
        }
      }
    });
  });
});
