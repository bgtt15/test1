<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<html>
<head>
	<title>Home</title>
<style>
	#modDiv{
		width:300px;
		height:100px;
		background-color:gray;
		position:absolute;
		top:50%;
		left:50%;
		margin-top:-50px;
		margin-left:-150px;
		padding:10px;
		z-index:1000;
		display:none;
	}
</style>
</head>

<body>
<h1>Ajax Test Page</h1>

<div>
	<div>
		답변자<input type="text" name="replyer" id="newReplyWriter">
	</div>
	<div>
		답변글<input type="text" name="replytext" id="newReplyText">
	</div>
	<button id="replyAddBtn">답변 추가</button>
</div>

<ul id="replies">
</ul>

<div id="modDiv">
	<div class="modal-title"></div>
	<div>
		<input type="text" id="replytext">
	</div>
	<div>
		<button type="button" id="replyModBtn">수정</button>
		<button type="button" id="replyDelBtn">삭제</button>
		<button type="button" id="closeBtn">닫기</button>
	</div>
</div>

<ul class='pagination'>
</ul>

</body>
</html>

<script src="/resources/plugins/jQuery/jQuery-2.1.4.min.js">
</script>
<script>
var bno=1111;
var replyPage=1;
getPageList(1);

$("#replyAddBtn").on("click",function(){
	var replyer=$("#newReplyWriter").val();
	var replytext=$("#newReplyText").val();
	
	$.ajax({
		type:'post',
		url:'/replies',
		headers:{
			"Content-Type":"application/json",
			"X-HTTP-Method-Override":"POST"
		},
		dataType:'text',
		data:JSON.stringify({
			bno:bno,
			replyer:replyer,
			replytext:replytext
		}),
		success:function(result){
			if(result=='SUCCESS'){
				alert("등록 되었습니다.");
				//getAllList(bno);
				getPageList(replyPage);
			}
		}		
	});	
});

function getAllList(bno){	
	
	$.getJSON("/replies/all/"+bno,function(data){
		console.log(data.length);
		var str="";
		
		$(data).each(function(){
			str+="<li data-rno='"+this.rno+"' class='replyLi'>"
				+this.rno+":"+this.replytext
				+"<button>MOD</button></li>";
		});
		$("#replies").html(str);
	});
}

//MOD버튼 클릭, 박스 보이게
$("#replies").on("click",".replyLi button",function(){
	var reply=$(this).parent();
	var rno=reply.attr("data-rno");
	var replytext=reply.text();
	
	$(".modal-title").html(rno);
	$("#replytext").val(replytext);
	$("#modDiv").show("slow");
});

//다이얼로그 박스에서 삭제버튼
$("#replyDelBtn").on("click",function(){
	var rno=$(".modal-title").html();	
	
	$.ajax({
		type:'delete',
		url:'/replies/'+rno,
		headers:{
			"Content-Type":"application/json",
			"X-HTTP-Method-Override":"DELETE"
		},
		dataType:'text',
		success:function(result){
			if(result=='SUCCESS'){
				alert("삭제 되었습니다.");
				$("#modDiv").hide("slow");
				//getAllList(bno);
				getPageList(replyPage);
			}
		}		
	});	
});

//다이얼로그 박스에서 수정 버튼
$("#replyModBtn").on("click",function(){
	var rno=$(".modal-title").html();
	var replytext=$("#replytext").val();
	
	$.ajax({
		type:'put',
		url:'/replies/'+rno,
		headers:{
			"Content-Type":"application/json",
			"X-HTTP-Method-Override":"PUT"
		},
		dataType:'text',
		data:JSON.stringify({
			replytext:replytext
		}),
		success:function(result){
			if(result=='SUCCESS'){
				alert("수정 되었습니다.");
				$("#modDiv").hide("slow");
				//getAllList(bno);
				getPageList(replyPage);
			}
		}		
	});	
});

//다이얼로그 박스에서 닫기 버튼
$("#closeBtn").on("click",function(){
	$("#modDiv").hide("slow");	
});

//페이징
function getPageList(page){
	$.getJSON("/replies/"+bno+"/"+page,function(data){
		console.log(data.list.length);
		var str="";
		
		$(data.list).each(function(){
			str+="<li data-rno='"+this.rno+"' class='replyLi'>"
				+this.rno+":"+this.replytext
				+"<button>MOD</button></li>";
		});
		
		$("#replies").html(str);
		printPaging(data.pageMaker);
	});
}

function printPaging(pageMaker){
	var str="";
	
	if(pageMaker.prev){
		str+="<li><a href='"+(pageMaker.startPage-1)+"'> << </a></li>";
	}
	for(var i=pageMaker.startPage;i<=pageMaker.endPage;i++){
		var strClass=pageMaker.cri.page==i?'class=active':'';
		str+="<li "+strClass+"><a href='"+i+"'>"+i+"</a></li>";
	}
	if(pageMaker.next){
		str+="<li><a href='"+(pageMaker.endPage+1)+"'> >> </a></li>";
	}
	$('.pagination').html(str);
}

//페이지번호 이벤트처리
$(".pagination").on("click","li a",function(event){
	event.preventDefault();
	replyPage=$(this).attr("href");
	getPageList(replyPage);
});
</script>





