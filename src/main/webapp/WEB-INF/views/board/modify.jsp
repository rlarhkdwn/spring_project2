<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>


<jsp:include page="../layout/header.jsp" />
	<div class=".container-sm p-5">
		<h3>Board Detail Page</h3>
		
		<c:set value="${boardFileDTO.board}" var="board" />
		
		<form action="/board/update" method="POST" enctype="multipart/form-data">
			<!-- csrf 토큰 추가 -->
			<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">
			<div class="mb-3">
				<label for="b" class="form-label">Bno</label>
				<input type="text" class="form-control" id="b" name="bno" value="${board.bno}" readonly placeholder="bno...">
			</div>
			<div class="mb-3">
				<label for="t" class="form-label">Title</label>
				<input type="text" class="form-control" id="t" name="title" value="${board.title}" placeholder="title...">
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
				<textarea class="form-control" id="c" name="content" rows="3" placeholder="content...">${board.content}</textarea>
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
							<button type="button" class="btn btn-danger btn-sm file-x" id="file-x" data-uuid="${fvo.uuid}" data-save-dir="${fvo.saveDir}" data-file-name="${fvo.fileName}">x</button>
						</li>
					</c:forEach>
				</ul>
			</div>
			
			<!-- 첨부 파일 업로드 라인 -->
			<div class="mb-3">
				<label for="file" class="form-label"></label>
				<!-- multiple옵션은 파일을 여러개 올릴 수 있음 -->
				<input type="file" class="form-control" id="file" name="files" multiple="multiple" style="display:none;"></input>
				<button type="button" class="btn btn-outline-dark" id="trigger">file</button>
			</div>
			<!-- 파일 목록 라인 -->
			<div class="mb-3" id="fileZone"></div>
		
			<button type="submit" class="btn btn-success" id="regBtn">update</button>
			<a href="/board/list"><button type="button" class="btn btn-primary">cancel</button></a>
		</form>
		
		<script type="text/javascript" src="/resources/js/boardRegisterFile.js"></script>
		<script type="text/javascript" src="/resources/js/boardModify.js"></script>
	</div>
<jsp:include page="../layout/footer.jsp" />
