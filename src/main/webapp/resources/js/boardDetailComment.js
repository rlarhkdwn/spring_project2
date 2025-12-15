console.log("boardDetailComment.js in");
console.log(bnoValue);
console.log(loginNick);

const csrfToken = document.querySelector('meta[name="_csrf"]').getAttribute('content');
const csrfHeader = document.querySelector('meta[name="_csrf_header"]').getAttribute('content');

if (loginNick) {
	document.getElementById('cmtAddBtn').addEventListener('click', ()=>{
		const cmtText = document.getElementById('cmtText');
		const cmtWriter = document.getElementById('cmtWriter');
	
		if (cmtText.value == '') {
			alert('댓글을 입력해주세요');
			cmtText.focus();
			return;
		}
	
		let cmtData = {
			bno : bnoValue,
			writer : cmtWriter.innerText,
			content : cmtText.value
		}
		console.log(cmtData);
	
		// 비동기로 cmtData 보내기
		postCommentToServer(cmtData).then(result => {
			if (result == 1) {
				alert('댓글 등록 성공!')
				cmtText.value = "";
			}
	
			// 댓글 출력
			spreadCommentList(cmtData.bno);
		})
	});
}


// 댓글 뿌리기
function spreadCommentList(bno, page=1) {
	getCommentListFromServer(bno, page).then(result => {
		console.log(result);
		const ul = document.getElementById('cmtListArea');
		if (result.cmtList.length > 0) {
			// 댓글이 있는 경우
			if (page == 1) {
				ul.innerHTML = '';
			}
			let li = ``;
			for(let cvo of result.cmtList){
				li += `<li class="list-group-item" data-cno="${cvo.cno}">`;
				li += `<div class="mb-3">`;
				li += `<div class="fw-bold">${cvo.writer}</div>`;
				li += `${cvo.content}`;
				li += `</div>`;
				li += `<span class="badge text-bg-primary">${cvo.regDate}</span>`;
				if(loginNick === cvo.writer){
					li += `<button type="button" class="btn btn-warning btn-sm mod" data-bs-toggle="modal" data-bs-target="#cmtModal">%</button>`;
					li += `<button type="button" class="btn btn-danger btn-sm del">x</button>`;
				}
				li += `</li>`;
			}
			ul.innerHTML += li;
			
			// 더보기 버튼 체크
			let moreBtn = document.getElementById('moreBtn');
			// 더보기 버튼이 표시되는 조건
			// 5개보다 리스트의 개수가 더 많다면 표시
			// pgvo.pageNo < realEndPage => 더보기 버튼 표시
			if (result.pgvo.pageNo < result.realEndPage) {
				// 버튼 표시
				// style="visiblity: hidden;" : 숨김 "visible" : 표시
				moreBtn.style.visibility = "visible";
				// page 값을 1증가 => data-page="1" 증가 후 다시 data-page 달기
				moreBtn.dataset.page = Number(moreBtn.dataset.page) + 1;
			} else {
				// 현재 페이지가 전체 페이지보다 작지 않으면
				moreBtn.style.visibility = "hidden"; // 숨김
			}
		} else {
			// 댓글이 없는 경우
			ul.innerHTML = `<li class="list-group-item">Comment List Enpty</li>`;
		}
	})
}

document.addEventListener('click', (e)=>{
	if(e.target.id == "moreBtn") {
		// 더보기 버튼
		let page = Number(e.target.dataset.page);
		spreadCommentList(bnoValue, page);
	}

	if(e.target.classList.contains('mod')) {
		// 수정 처리
		// 수정 버튼을 클릭하면 모달에 writer, content 등록
		let li = e.target.closest('li'); // 내 버튼이 속한 li
		let cno = li.dataset.cno;
		// nextSibling : 같은 부모에 속해있는 형제노드를 반환
		let cmtText = li.querySelector('.fw-bold').nextSibling;
		console.log(cmtText.nodeValue);
		console.log(typeof cmtText.nodeValue); // return nextNode => nodeValue 값만 분리

		let cmtWriter = li.querySelector('.fw-bold').innerText;
		let content = cmtText.nodeValue;

		document.getElementById('cmtTextMod').value = content;
		document.getElementById('exampleModalLabel').innerHTML = `no.${cno} <b>${cmtWriter}</b>`;

		// cmtModBtn => data-cno="cno" dataset 달기
		document.getElementById("cmtModBtn").setAttribute("data-cno", cno);
		
	}
	
	if(e.target.id == "cmtModBtn"){
		// 모달에서 버튼을 클릭하면 => 수정 비동기 처리
		// cno, content => 서버로 전송하여 update

		let cmtData = {
			cno : e.target.dataset.cno,
			content : document.getElementById('cmtTextMod').value
		}

		// 비동기 함수 만들어서 전송
		updateCommentToServer(cmtData).then(result => {
			if (result > 0) {
				alert("수정 성공!!");
			} else {
				alert("수정 실패!!");
			}
			// 댓글 출력
			spreadCommentList(bnoValue);

			// 모달창 닫기 : btn-close 클래스를 클릭하시오
			document.querySelector(".btn-close").click();
		});
	}

	if(e.target.classList.contains('del')) {
		// 삭제 처리
		// 삭제 버튼을 클릭하면 => cno를 경로에 달고 컨트롤러로 처리요청
		// `/comment/delete/${cno}`
		let li = e.target.closest('li');
		let cno = li.dataset.cno;
		deleteCommentToServer(cno, bnoValue).then(result => {
			if (result > 0) {
				alert("삭제 성공!!");
			} else {
				alert("삭제 실패!!");
			}
			document.getElementById('moreBtn').dataset.page = 1;
			spreadCommentList(bnoValue);
		});
	}
})

// delete
async function deleteCommentToServer(cno, bno) {
	try {
		const url = `/comment/delete/${cno}/${bno}`;
		const config = {
			method : "DELETE",
			headers : {
				[csrfHeader] : csrfToken
			}
		}
		const res = await fetch(url, config);
		const result = res.text();
		return result;
	} catch (error) {
		console.log(error);
	}
}

// modify
async function updateCommentToServer(cmtData) {
	try {
		const url = "/comment/modify";
		const config = {
			method : "PUT",
			headers : {
				'Content-Type' : 'application/json; charset=utf-8',
				[csrfHeader] : csrfToken
			},
			body : JSON.stringify(cmtData)
		}

		const res = await fetch(url, config);
		const result = await res.text();
		return result;
	} catch (error) {
		console.log(error);
	}
}

/*
<li class="list-group-item">
	<div class="mb-3">
		<div class="fw-bold">writer</div>
		content
	</div>
	<span class="badge text-bg-primary">regDate</span>
</li>
*/

// list
async function getCommentListFromServer(bno, page) {
	try {
		const res = await fetch(`/comment/list/${bno}/${page}`); // path로 데이터 보내기
		const result = res.json(); // List<CommentVO>
		return result;
	} catch (error) {
		console.log(error);
	}
}

// post
async function postCommentToServer(cmtData) {
	try {
		const url = "/comment/post";
		const config = {
			method : 'POST',
			headers : {
				'Content-Type' : 'application/json; charset=utf-8',
				[csrfHeader] : csrfToken
			},
			body : JSON.stringify(cmtData)
		}
		const res = await fetch(url, config);
		const result = await res.text();
		return result
	} catch (error) {
		console.log(error);
	}
}