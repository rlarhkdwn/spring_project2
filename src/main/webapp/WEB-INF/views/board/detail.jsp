<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

<jsp:include page="../layout/header.jsp" />
	<div class=".container-sm p-5">
		<h3>Board Detail Page</h3>
		
		<!-- c:set 값을 저장하는 변수처럼 사용 -->
		<c:set value="${boardFileDTO.board}" var="board" />
		<%-- <c:set value="${boardFileDTO.flist}" var="flist" /> --%>
		
		<div class="mb-3">
			<label for="b" class="form-label">Bno</label>
			<input type="text" class="form-control" id="b" name="bno" value="${board.bno}" readonly placeholder="bno...">
		</div>
		<div class="mb-3">
		<div class="mb-3">
			<label for="t" class="form-label">Title</label>
			<input type="text" class="form-control" id="t" name="title" value="${board.title}" readonly placeholder="title...">
		</div>
		<div class="mb-3">
			<label for="w" class="form-label">Writer</label>
			<input type="text" class="form-control" id="w" name="writer" value="${board.writer}" readonly placeholder="writer...">
		</div>
		<div class="mb-3">
			<label for="r" class="form-label">RegDate</label>
			<input type="text" class="form-control" id="r" name="regDate" value="${board.regDate}" readonly placeholder="regDate...">
		</div>
		<div class="mb-3">
			<label for="rc" class="form-label">ReadCount</label>
			<input type="text" class="form-control" id="rc" name="readCount" value="${board.readCount}" readonly placeholder="regDate...">
		</div>
		<div class="mb-3">
			<label for="c" class="form-label">Content</label>
			<textarea class="form-control" id="c" name="content" rows="3" readonly placeholder="content...">${board.content}</textarea>
		</div>
		
		<!-- file print -->
		<div class="mb-3">
			<ul class="list-group">
				<!-- 파일의 개수만큼 li반복 type=1 이면 그림을 표시, 아니면 파일모양으로(다운로드 가능) 표시-->
				<c:forEach items="${boardFileDTO.flist}" var="fvo">
					<li class="list-group-item">
						<c:choose>
							<c:when test="${fvo.fileType > 0}">
								<!-- 그림 파일 -->
								<div>
									<img alt="" src="/upload/${fvo.saveDir}/${fvo.uuid}_th_${fvo.fileName}">
								</div>
							</c:when>
							<c:otherwise>
								<!-- 일반 파일 -->
								<a href="/upload/${fvo.saveDir}/${fvo.uuid}_${fvo.fileName}" download="${fvo.fileName}">
									<svg xmlns="http://www.w3.org/2000/svg" width="32" height="32" fill="currentColor" class="bi bi-file-earmark-arrow-down-fill" viewBox="0 0 16 16">
  										<path d="M9.293 0H4a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h8a2 2 0 0 0 2-2V4.707A1 1 0 0 0 13.707 4L10 .293A1 1 0 0 0 9.293 0M9.5 3.5v-2l3 3h-2a1 1 0 0 1-1-1m-1 4v3.793l1.146-1.147a.5.5 0 0 1 .708.708l-2 2a.5.5 0 0 1-.708 0l-2-2a.5.5 0 0 1 .708-.708L7.5 11.293V7.5a.5.5 0 0 1 1 0"/>
									</svg>
								</a>
							</c:otherwise>
						</c:choose>
						<div class="mb-3">
							<div class="fw-bold">${fvo.fileName}</div>
						</div>
						<span class="badge text-bg-primary">${fvo.regDate} / ${fvo.fileSize}</span>
					</li>
				</c:forEach>
			</ul>
		</div>
		
		<a href="/board/list"><button type="button" class="btn btn-primary">list</button></a>
		<sec:authorize access="isAuthenticated()">
			<sec:authentication property="principal.userVO.nickName" var="authNick"/>
			<c:if test="${board.writer eq authNick}">
				<a href="/board/modify?bno=${board.bno}"><button type="button" class="btn btn-warning">modify</button></a>
				<a href="/board/delete?bno=${board.bno}"><button type="button" class="btn btn-danger">delete</button></a>
			</c:if>
		</sec:authorize>
		
		<!-- comment -->
		<!-- post -->
		<sec:authorize access="isAuthenticated()">
			<div class="input-group my-3">
				<span class="input-group-text" id="cmtWriter">${authNick}</span>
				<input type="text" class="form-control" id="cmtText" placeholder="Add Comment..." aria-label="Username" aria-describedby="basic-addon1">
				<button type="button" id="cmtAddBtn" class="btn btn-success">post</button>
			</div>
		</sec:authorize>
		<!-- print -->
		<ul class="list-group list-group-flush" id="cmtListArea">
			<li class="list-group-item">
				<div class="mb-3">
					<div class="fw-bold">writer</div>
					content
				</div>
				<span class="badge text-bg-primary">regDate</span>
			</li>
		</ul>
		
		<!-- 더보기 버튼 : 한 페이지에 5개씩 댓글 표시 더 있으면 더보기 버튼 활성화 -->
		<div class="mb-3">
			<button type="button" id="moreBtn" data-page="1" style="visibility: hidden;" class="btn btn-outline-success">More +</button>
		</div>
		
		<!-- Modal -->
		<div class="modal fade" id="cmtModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
		    <div class="modal-dialog">
			    <div class="modal-content">
				    <div class="modal-header">
				        <h1 class="modal-title fs-5" id="exampleModalLabel">Modal title</h1>
				        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
				    </div>
				    <div class="modal-body">
				        <input type="text" class="form-control" id="cmtTextMod">
				    </div>
				    <div class="modal-footer">
				        <button type="button" class="btn btn-primary" id="cmtModBtn">Modify</button>
				        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
				    </div>
			    </div>
		    </div>
		</div>
		
		
	<script type="text/javascript">
		const bnoValue = `<c:out value="${board.bno}" />`
		const loginNick = `<c:out value="${authNick}" />`
		console.log(loginNick)
	</script>
	
	<script type="text/javascript" src="/resources/js/boardDetailComment.js"></script>
	
	<script type="text/javascript">
		spreadCommentList(bnoValue);
	</script>
	
	</div>
<jsp:include page="../layout/footer.jsp" />
