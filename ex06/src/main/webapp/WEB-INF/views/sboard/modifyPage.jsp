<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@include file="../include/header.jsp"%>

<style>
.fileDrop{
	width:80%;
	height:100px;
	border:1px dotted gray;
	background-color:lightslategrey;
	margin:auto;
}
</style>

<section class="content">
	<div class="row">
		<div class="col-md-12">
			<div class="box">
				<div class="box-header with-border">
					<h3 class="box-title">REGISTER BOARD</h3>
				</div>
				
				<form role="form" action="modifyPage" method="post">
					<input type='hidden' name='page' value="${cri.page }">
					<input type='hidden' name='perPageNum' value="${cri.perPageNum }">
					<input type='hidden' name='searchType' value="${cri.searchType }">
					<input type='hidden' name='keyword' value="${cri.keyword }">
					
					<div class="box-body">
						<div class="form-group">
							<label for="exampleInputEmail1">번호</label>
							<input type="text" name="bno" class="form-control" value="${boardVO.bno }" readonly="readonly">
						</div>
						
						<div class="form-group">
							<label for="exampleInputEmail1">제목</label>
							<input type="text" name="title" class="form-control" value="${boardVO.title }">
						</div>
						
						<div class="form-group">
							<label for="exampleInputPassword1">Content</label>
							<textarea class="form-control" name="content" rows="3">${boardVO.content }</textarea>
						</div>
						
						<div class="form-group">
							<label for="exampleInputEmail1">Writer</label>
							<input type="text" name="writer" class="form-control" value="${boardVO.writer }" readonly="readonly">
						</div>
						
						<div class="form-group">
							<label for="exampleInputEmail1">File DROP Here</label>
							<div class="fileDrop"></div>
						</div>	
						
					</div>
					
					<div><hr></div>
						
					<ul class="mailbox-attachments clearfix uploadedList">
					</ul>
					
					<div class="box-footer">						
						<button type="submit" class="btn btn-primary">수정</button>
						<button type="submit" class="btn btn-warning">취소</button>
					</div>
				</form>
			</div>
		</div>
	</div>
</section>

<%@include file="../include/footer.jsp"%>

<script src="https://cdnjs.cloudflare.com/ajax/libs/handlebars.js/3.0.1/handlebars.js">
</script>
<script id="template" type="text/x-handlebars-template">
<li>
	<span class="mailbox-attachment-icon has-img"><img src="{{imgsrc}}" alt="Attachment"></span>
	<div class="mailbox-attachment-info">
		<a href="{{getLink}}" class="mailbox-attachment-name">{{fileName}}</a>
		<a href="{{fullName}}" class="btn btn-default btn-xs pull-right delbtn"><i class="fa fa-fw fa-remove"></i></a>
	</div>
</li>
</script>

<script src="/resources/js/upload.js"></script>

<script>
$(document).ready(function(){
	var formObj=$("form[role='form']");
	console.log(formObj);
	
	$(".btn-warning").on("click",function(){	//취소		
		self.location="/sboard/list?page=${cri.page}&perPageNum=${cri.perPageNum}&searchType=${cri.searchType}&keyword=${cri.keyword}";					
	});
 	formObj.submit(function(event){	//수정		
 		event.preventDefault();
 		
 		var that=$(this);
 		var str="";
 		
 		$(".uploadedList .delbtn").each(function(index){
 			str+="<input type='hidden' name='files["+index+"]' value='"+$(this).attr("href")+"'>";
 		});
 		
 		that.append(str);
 		that.get(0).submit();
	});
});
</script>

<script>
var template=Handlebars.compile($("#template").html());

$(".fileDrop").on("dragenter dragover",function(event){
	event.preventDefault();
});
$(".fileDrop").on("drop",function(event){
	event.preventDefault();
	
	var files=event.originalEvent.dataTransfer.files;
	var file=files[0];
	
	//console.log(file);
	var formData=new FormData();
	formData.append("file",file);
	
	$.ajax({
		url:'/uploadAjax',
		data:formData,
		dataType:'text',
		processData:false,
		contentType:false,
		type:'POST',
		success:function(data){
			var fileInfo=getFileInfo(data);
			var html=template(fileInfo);
			
			$(".uploadedList").append(html);
		}
	});
});

</script>

<script>
var bno=${boardVO.bno};
var templateAttach=Handlebars.compile($("#template").html());

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
		
		$(".popup").show("slow");
		imgTag.addClass("show");
	}
});

$("#popup_img").on("click",function(){
	$(".popup").hide("slow");
});

$(".uploadedList").on("click", ".delbtn", function(event){	
	event.preventDefault();
	
	var that = $(this);
	 
	$.ajax({
	   url:"/deleteFile",
	   type:"post",
	   data: {fileName:$(this).attr("href")},
	   dataType:"text",
	   success:function(result){
		   if(result == 'deleted'){
			   that.closest("li").remove();
		   }
	   }
   });
});

</script>
