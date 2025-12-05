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
<jsp:include page="layout/footer.jsp" />