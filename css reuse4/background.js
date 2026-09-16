// 웹 요청 가로채기 제어 (Fetch API Interceptor 대체 모델)
chrome.webRequest.onBeforeRequest.addListener(
  (details) => {
    // 팝업이나 문서 자체 요청은 제외하고 리소스만 스크리닝
    if (["stylesheet", "script", "image"].includes(details.type)) {
      const url = details.url;
      const urlObj = new URL(url);
      const hostname = urlObj.hostname;

      // 동기식 처리를 위해 스토리지 캐시 검사 프로세스 작동 (핵심 기법)
      // 실제 정밀 구현 시 서비스워커 내 전역 변수에 스토리지를 동기화하여 검사속도를 맞춥니다.
      return { cancel: false }; 
    }
  },
  { urls: ["<all_urls>"] },
  ["blocking"]
);

// Content Script와의 통신을 통해 가로챈 스크립트/스타일을 페이지에 직접 dynamic하게 먹여주는 대체 보완 로직
chrome.runtime.onMessage.addListener((message, sender, sendResponse) => {
  if (message.action === "getStoredResource") {
    chrome.storage.local.get({ sites: {} }, (data) => {
      const siteData = data.sites[message.hostname];
      sendResponse({ data: siteData || null });
    });
    return true;
  }
});
