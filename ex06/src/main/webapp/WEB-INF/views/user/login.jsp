<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@include file="../include/header.jsp"%>

<section class="login-page">
	<div class="login-box">
		<div class="login-logo">
			<a href="/resources/index2.html">로그인 화면</a>
		</div><!-- /.login-logo -->
		<div class="login-box-body">
			<p class="login-box-msg">로그인 하세요!</p>
        
			<form action="/user/loginPost" method="post">
				<div class="form-group has-feedback">							
					<input type="text" name="uid" class="form-control" placeholder="USER ID">
					<span class="glyphicon glyphicon-envelope form-control-feedback"></span>
				</div>
				
				<div class="form-group has-feedback">							
					<input type="text" name="upw" class="form-control" placeholder="PASSWORD">
					<span class="glyphicon glyphicon-envelope form-control-feedback"></span>
				</div>	
								
				<div class="row">
					<div class="col-xs-8">
						<div class="checkbox icheck">
							<label><input type="checkbox" name="useCookie">로그인 유지</label>
						</div>
					</div>
					
					<div class="col-xs-4">
						<button type="submit" class="btn btn-primary btn-block btn-flat">로그인</button>
					</div>
				</div>
				
			</form>

			<a href="#">비밀번호 잊어버림</a><br>
			<a href="register.html" class="text-center">회원가입</a>

		</div><!-- /.login-box-body -->
				
	</div><!-- /.login-box -->
	
</section>

<%@include file="../include/footer.jsp"%>
