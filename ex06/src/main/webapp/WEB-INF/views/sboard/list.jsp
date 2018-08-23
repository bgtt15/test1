<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@include file="../include/header.jsp"%>

<section class="content">
	<div class="row">
		<div class="col-md-12">
			<div class="box">
				<div class="box-header with-border">
					<h3 class="box-title">LIST ALL PAGE</h3>
				</div>				
				
				<div class="box-body">
					
					<select name="searchType">
						<option value="n"
							<c:out value="${cri.searchType==null?'selected':'' }"/>>---</option>
						<option value="t"
							<c:out value="${cri.searchType eq 't'?'selected':'' }"/>>제목</option>
						<option value="c"
							<c:out value="${cri.searchType eq 'c'?'selected':'' }"/>>내용</option>
						<option value="w"
							<c:out value="${cri.searchType eq 'w'?'selected':'' }"/>>작성자</option>
					</select>
					
					<input type="text" name="keyword" id="keywordInput" value='${cri.keyword }'>
					<button id='searchBtn'>검색</button>
					<button id='newBtn'>글쓰기</button>
					
					<table class="table table-bordered">
						<tr>
							<th style="width:50px">번호</th>
							<th>제목</th>
							<th>작성자</th>
							<th>등록일</th>
							<th style="width:60px">조회수</th>
						</tr>
						
						<c:forEach var="boardVO" items="${list }">
							<tr>
								<td>${boardVO.bno }</td>
								<td><a href='/sboard/readPage${pageMaker.makeSearch(pageMaker.cri.page) }&bno=${boardVO.bno }'>${boardVO.title } <strong>[${boardVO.replycnt }]</strong></a></td>
								<td>${boardVO.writer }</td>
								<td><fmt:formatDate pattern="yyyy-MM-dd HH:mm" value="${boardVO.regdate }"/></td>
								<td><span class="badge bg-red">${boardVO.viewcnt }</span></td>
							</tr>						
						</c:forEach>
					</table>
				</div>
				
				<div class="box-footer">
					<div class="text-center">
						<ul class="pagination">
							
							<c:if test="${pageMaker.prev }">
								<li><a href="list${pageMaker.makeSearch(pageMaker.startPage-1) }">[이전]</a></li>
							</c:if>
							
							<c:forEach begin="${pageMaker.startPage }" end="${pageMaker.endPage }" var="idx">
								<li <c:out value="${pageMaker.cri.page==idx?'class=active':'' }"/>>
									<a href="list${pageMaker.makeSearch(idx) }">${idx }</a>
								</li>
							</c:forEach>
							
							<c:if test="${pageMaker.next && pageMaker.endPage>0 }">
								<li><a href="list${pageMaker.makeSearch(pageMaker.endPage+1) }">[다음]</a></li>
							</c:if>
						</ul>
					
					</div>
				</div>
				
			</div>
		</div>
	</div>
</section>

<%@include file="../include/footer.jsp"%>

<script>
$(document).ready(function(){
	$('#searchBtn').on("click",function(event){
		self.location="list"
			+'${pageMaker.makeQuery(1)}'
			+"&searchType="
			+$("select option:selected").val()
			+"&keyword="+encodeURIComponent($('#keywordInput').val());
	});
	$('#newBtn').on("click",function(evt){
		self.location="register";
	});
});
</script>
