<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>


<jsp:include page="layout/header.jsp" />
	<div class="container-sm">
		<h1>
			My First Spring Project!! 
		</h1>
		
		<P>  The time on the server is ${serverTime}. </P>
	</div>
	
	<script type="text/javascript">
		const modify_msg = `<c:out value="${modify_msg}" />`
		console.log(modify_msg);
		if (modify_msg === "ok") {
			alert("회원정보가 수정되었습니다. 다시 로그인 해주세요.")
		}
		
		const remove_msg = `<c:out value="${remove_msg}" />`
		console.log(remove_msg);
		if (remove_msg === "ok") {
			alert("회원이 삭제되었습니다.");
		} 
		if (remove_msg === "fail") {
			alert("회원삭제 실패");
		}
	</script>
	
<jsp:include page="layout/footer.jsp" />