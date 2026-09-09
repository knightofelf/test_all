

//-----------------------------------------
//popup.js 에서는 div 를 사용할 수 있다.
//-----------------------------------------

var test = new Object();
test.str = new String();
var tab_last = new Number();



//-----------------------------------------
//popup.html 의 시작은 여기서 한다. ㅇ_ㅇ;;
//-----------------------------------------
document.addEventListener('DOMContentLoaded', function () 
{
	//dumpBookmarks();


	fn_list_all();

//	chrome.runtime.sendMessage("create");



//-----------------------------------------
//background.js 로 메시지 보내는 방법
//-----------------------------------------

});





function fn_list_all()
{


chrome.tabs.query({}, tabs => {
//    alert ( tabs.length );
	tab_last = tabs.length;
});


	//
	var select_windowId = 0;

	//선택 시작


	//
	test.str = "";
	chrome.windows.getAll({populate: true}, function(windows)
	{
		for(w=0;w<windows.length;w++)
		{
			for(t=0;t<windows[w].tabs.length;t++)
			{

//				if(windows[w].tabs[t].windowId == select_windowId)
				{
					var t = windows[w].tabs[t].index;


var url = windows[w].tabs[t].url;
url = url.replace("https://", "http://");


	test.str +=	windows[w].tabs[t].title +"<BR>"+
			"<a href='"+ url +"'>"+ url +"</a>" +"<BR>" +"<BR>";


				}

			}
		}
	});
}



//-----------------------------------------
//0.1초 후에 저장한 값을 얻어온다. ㅇ_ㅇ;;
//-----------------------------------------
//https://webisfree.com/2014-04-08/[javascript]-시간-지연-함수-일정-시간-뒤-실행시키기-settimeout()-%7B%7D
var myTimer = setTimeout(function()
{

	//-----------------------------------------
	//크롬 저장소 값을 얻는 방법 : background.js 에서 값 얻을 때 사용
	//-----------------------------------------
	//Chrome Development Part 1: Extensions
	//https://www.codeproject.com/Articles/1103565/Chrome-Development-Part-Extensions

	chrome.storage.local.get("browser", function(data)
	{
		var div = document.getElementById('test2');
		div.innerHTML = data.browser;
		div.innerHTML = test.str;
	});

	//-----------------------------------------
	//크롬 저장소 값 사용방법 : 초기화
	//-----------------------------------------
	chrome.storage.local.set({"browser": ""}, function()
	{
		
	});

	//
	clearTimeout(myTimer);
}, 100);
























