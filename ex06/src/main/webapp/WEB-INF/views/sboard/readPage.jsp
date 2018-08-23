<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@include file="../include/header.jsp"%>

<style>
.popup{
	position:absolute;
}
.back{
	background-color:gray;
	opacity:0.5;
	width:100%;
	height:300%;
	overflow:hidden;
	z-index:1101;
}
.front{
	z-index:1110;
	opacity:1;
	border:1px;
	margin:auto;
}
.show{
	position:relative;
	max-width:1200px;
	max-height:800px;
	overflow:auto;
}
</style>

<div class="popup back" style="display:none"></div>
<div id="popup_front" class="popup front" style="display:none;">
	<img id="popup_img">
</div>

<section class="content">

	<div class="row">
		<div class="col-md-12">
		
			<div class="box">
				<div class="box-header with-border">
					<h3 class="box-title">READ BOARD</h3>
				</div>
				
				<form role="form" action="modifyPage" method="post">
					<input type='hidden' name='bno' value="${boardVO.bno}"> 
					<input type='hidden' name='page' value="${cri.page}"> 
					<input type='hidden' name='perPageNum' value="${cri.perPageNum}">
					<input type='hidden' name='searchType' value="${cri.searchType}">
					<input type='hidden' name='keyword' value="${cri.keyword}">
				</form>
				
				<div class="box-body">
					<div class="form-group">
						<label for="exampleInputEmail1">Title</label>
						<input type="text" name="title" class="form-control" value="${boardVO.title }" readonly="readonly">
					</div>
					
					<div class="form-group">
						<label for="exampleInputPassword1">Content</label>
						<textarea class="form-control" name="content" rows="3" readonly="readonly">${boardVO.content }</textarea>
					</div>
					
					<div class="form-group">
						<label for="exampleInputEmail1">Writer</label>
						<input type="text" name="writer" class="form-control" value="${boardVO.writer }" readonly="readonly">
					</div>
				</div>
				
				<ul class="mailbox-attachments clearfix uploadedList">
				</ul>
				
				<div class="box-footer">
					<c:if test="${login.uid==boardVO.writer }">
						<button type="submit" class="btn btn-warning modifyBtn">수정</button>
						<button type="submit" class="btn btn-danger removeBtn">삭제</button>
					</c:if>
					<button type="submit" class="btn btn-primary goListBtn">목록</button>
				</div>
				
				<form role="form" action="modifyPage" method="post">
					<input type="hidden" name="bno" value="${boardVO.bno}">
					<input type="hidden" name="page" value="${cri.page}">
					<input type="hidden" name="perPageNum" value="${cri.perPageNum}">
					<input type="hidden" name="searchType" value="${cri.searchType}">
					<input type="hidden" name="keyword" value="${cri.keyword}">				
				</form>
			</div>
		</div>
	</div>
	
	<!-- 댓글 -->
	<div class="row">
		<div class="col-md-12">
		
			<div class="box box-success">
				<div class="box-header">
					<h3 class="box-title">댓글 추가</h3>
				</div>
				
				<c:if test="${not empty login }">
					<div class="box-body">					
						<label for="newReplyWriter">Writer</label>
						<input type="text" class="form-control" placeholder="USER ID" id="newReplyWriter" value="${login.uid }" readonly="readonly">
						<label for="newReplyText">ReplyText</label>
						<input type="text" class="form-control" placeholder="REPLY TEXT" id="newReplyText">					
					</div>				
					
					<div class="box-footer">
						<button type="submit" class="btn btn-primary" id="replyAddBtn">댓글 추가</button>					
					</div>
				</c:if>
				
				<c:if test="${empty login }">
					<div class="box-body">
						<div>
							<a href="javascript:goLogin();">로그인하세요</a>
						</div>
					</div>
				</c:if>
			</div>
			
			<ul class="timeline">
				<li class="time-label" id="repliesDiv"><span class="bg-green">
		    댓글 목록 <small id='replycntSmall'> [ ${boardVO.replycnt} ] </small>
		    </span></li>
			</ul>		
			
			<div class="text-center">
				<ul id="pagination" class="pagination pagination-sm no-margin">
				</ul>
			</div>
			
		</div>
	</div>
	
	<div id="modifyModal" class="modal" modal-primary fade" role="dialog">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">&times;</button>
					<h4 class="modal-title"></h4>
				</div>
				<div class="modal-body" data-rno>
					<p><input type="text" id="replytext" class="form-control"></p>
				</div>				
					
				<div class="modal-footer">
					<button type="button" class="btn btn-info" id="replyModBtn">수정</button>
					<button type="button" class="btn btn-danger" id="replyDelBtn">삭제</button>
					<button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
				</div>
			</div>
		</div>
	</div>
	
</section>

<%@include file="../include/footer.jsp"%>

<script>
function goLogin(){
	self.location="/user/login";
}

$(document).ready(function(){
	var formObj=$("form[role='form']");
	console.log(formObj);
	
	$(".modifyBtn").on("click",function(){	//수정
		formObj.attr("action","/sboard/modifyPage");
		formObj.attr("method","get");
		formObj.submit();
	});
	
	$(".removeBtn").on("click",function(){		//삭제
		var replyCnt=$("#replycntSmall").html().replace(/[^0-9]/g,"");
	
		if(replyCnt>0){
			alert("댓글이 달린 게시물을 삭제할 수 없습니다.");
			return;
		}
		var arr=[];
		$(".uploadedList li").each(function(index){
			arr.push($(this).attr("data-src"));
		})
		if(arr.length>0){
			$.post("/deleteAllFiles",{files:arr},function(){
				
			});
		}
		
		formObj.attr("action","/sboard/removePage");		
		formObj.submit();
	});
	$(".goListBtn").on("click",function(){	//목록	
		formObj.attr("method","get");
		formObj.attr("action","/sboard/list");
		formObj.submit();
	});
});
</script>

<script src="https://cdnjs.cloudflare.com/ajax/libs/handlebars.js/3.0.1/handlebars.js">
</script>
<script id="template" type="text/x-handlebars-template">
{{#each .}}
<li class="replyLi" data-rno={{rno}}>
	<i class="fa fa-comments bg-blue"></i>
	<div class="timeline-item">
		<span class="time">
			<i class="fa fa-clock-o"></i>{{prettifyDate regdate}}
		</span>
		<h3 class="timeline-header"><strong>{{rno}}</strong>-{{replyer}}</h3>
		<div class="timeline-body">{{replytext}}</div>
		<div class="timeline-footer">
			{{#eqReplyer replyer }}
				<a class="btn btn-primary btn-xs" data-toggle="modal" data-target="#modifyModal">Modify</a>
			{{/eqReplyer}}
		</div>
	</div>
</li>
{{/each}}
</script>

<script src="https://cdnjs.cloudflare.com/ajax/libs/handlebars.js/3.0.1/handlebars.js">
</script>

<script>
var bno=${boardVO.bno};
var replyPage=1;

Handlebars.registerHelper("prettifyDate",function(timeValue){
	var dateObj=new Date(timeValue);
	var year=dateObj.getFullYear();
	var month=dateObj.getMonth()+1;
	var date=dateObj.getDate();
	return year+"/"+month+"/"+date;
});

Handlebars.registerHelper("eqReplyer",function(replyer,block){
	var accum="";
	if(replyer=="${login.uid}"){
		accum+=block.fn();
	}
	return accum;
});

var printData=function(replyArr,target,templateObject){
	var template=Handlebars.compile(templateObject.html());
	var html=template(replyArr);
	$(".replyLi").remove();
	target.after(html);
}

//페이징
function getPage(pageInfo){
	$.getJSON(pageInfo,function(data){
		printData(data.list,$("#repliesDiv"),$("#template"));		
		printPaging(data.pageMaker,$(".pagination"));
		$("#modifyModal").modal('hide');
		
		$("#replycntSmall").html("[ " + data.pageMaker.totalCount +" ]")
	});
}

function printPaging(pageMaker,target){
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
	target.html(str);
}

$("#repliesDiv").on("click",function(){
	if($(".timeline li").size()>1){
		return;
	}
	getPage("/replies/"+bno+"/1");
});

//페이지번호 이벤트처리
$(".pagination").on("click","li a",function(event){
	event.preventDefault();
	replyPage=$(this).attr("href");
	getPage("/replies/"+bno+"/"+replyPage);
});

$("#replyAddBtn").on("click",function(){
	var replyerObj=$("#newReplyWriter");
	var replytextObj=$("#newReplyText");
	var replyer=replyerObj.val();
	var replytext=replytextObj.val();
	
	$.ajax({
		type:'post',
		url:'/replies/',
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
				alert("댓글 추가 되었습니다.");
				replyPage=1;
				getPage("/replies/"+bno+"/"+replyPage);
				//replyerObj.val("");	//댓글 작성자 초기화
				replytextObj.val("");				
			}
		}		
	});	
});

$(".timeline").on("click",".replyLi",function(event){
	var reply=$(this);
	$("#replytext").val(reply.find('.timeline-body').text());
	$(".modal-title").html(reply.attr("data-rno"));
});

//모달창 댓글 수정
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
				alert("댓글 수정 되었습니다.");				
				getPage("/replies/"+bno+"/"+replyPage);							
			}
		}		
	});	
});

//모달창 댓글 삭제
$("#replyDelBtn").on("click",function(){
	var rno=$(".modal-title").html();
	var replytext=$("#replytext").val();
	
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
				alert("댓글 삭제 되었습니다.");				
				getPage("/replies/"+bno+"/"+replyPage);							
			}
		}		
	});	
});
</script>

<script id="templateAttach" type="text/x-handlebars-template">
<li data-src='{{fullName}}'>
	<span class="mailbox-attachment-icon has-img"><img src="{{imgsrc}}" alt="Attachment"></span>
	<div class="mailbox-attachment-info">
		<a href="{{getLink}}" class="mailbox-attachment-name">{{fileName}}</a>
	</div>
</li>
</script>

<script src="/resources/js/upload.js"></script>

<script>
var bno=${boardVO.bno};
var templateAttach=Handlebars.compile($("#templateAttach").html());

$.getJSON("/sboard/getAttach/"+bno,function(list){
	$(list).each(function(){
		var fileInfo=getFileInfo(this);
		var html=templateAttach(fileInfo);
		
		$(".uploadedList").append(html);
	});
});

$(".uploadedList").on("click",".mailbox-attachment-info a",function(event){
	var fileLink=$(this).attr("href");
	
	if(checkImageType(fileLink)){
		event.preventDefault();
		
		var imgTag=$("#popup_img");
		imgTag.attr("src",fileLink);
		
		console.log(imgTag.attr("src"));
		
		$(".popup").show("show");
		imgTag.addClass("show");
	}
});

$("#popup_img").on("click",function(){
	$(".popup").hide("slow");
});

</script>



