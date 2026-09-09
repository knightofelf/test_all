InstancedMesh 3D 텍스처 투영 뷰어 - GPU 점유율 0% <br>
웹 브라우저로 js html 3D 데모 보는데. 게임에 영향을 줌.    버그인가 ㅇ_ㅇ?? <br>
<br>
<pre>
- InstancedMesh 3D 텍스처 투영 뷰어 - GPU 점유율 0%  (놀라운 효율 ㅇ_ㅇ'') 
- 게임 렌더와 FPS도 멈춤 ㅇ_ㅇ;; 

- JS 코드에서 gl.getExtension('WEBGL_lose_context').loseContext(); 를 호출하면 브라우저의 WebGL 컨텍스트를 강제로 해제할 수 있습니다. ??
- WebGPU (차세대 API) navigator.gpu.requestAdapter() → requestDevice() 로 GPU 디바이스를 초기화.
- 동기화 비용 증가: OpenGL은 glFenceSync, DirectX는 Fence를 사용하지만 서로 다른 API 간에는 교차 동기화가 불가능해 CPU/GPU stall 발생.

</pre>
