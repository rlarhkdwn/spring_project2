<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>


<jsp:include page="../layout/header.jsp" />
	<div class=".container-sm p-5">
		<h3>User Login Page</h3>
		<form action="/user/login" method="POST">
			<!-- csrf 토큰 추가 -->
			<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
			<div class="mb-3">
				<label for="e" class="form-label">Email</label>
				<input type="text" class="form-control" id="e" name="email" placeholder="id@example.com">
			</div>
			<div class="mb-3">
				<label for="p" class="form-label">Password</label>
				<input type="password" class="form-control" id="p" name="pwd" placeholder="password...">
			</div>
			<!-- 로그인 실패시 에러메시지 출력 -->
			<c:if test="${errorMessage ne null}">
				<div class="text-danger">${errorMessage} / ${failEmail}</div>
			</c:if>
			<button type="submit" class="btn btn-primary">Login</button>
		</form>
	</div>
<jsp:include page="../layout/footer.jsp" />
