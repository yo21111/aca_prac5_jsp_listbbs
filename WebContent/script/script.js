/**
 * 
 */

$(function() {
	let cnt = $("span#hiddenCnt").text();

	$("span#cnt").text(cnt);
	$("span#pages").text(" " + Math.ceil(cnt / 5));

	let curPageNum = $("span#hiddenPageNum").text();
	$("span#curPage").text(curPageNum + " ");

	$("div#"+curPageNum).addClass("currentPage");
	
});