console.log("boardModify.js in");

const csrfToken = document.querySelector('meta[name="_csrf"]').getAttribute('content');
const csrfHeader = document.querySelector('meta[name="_csrf_header"]').getAttribute('content');

// 파일, 이미지 삭제 비동기 함수
async function removeFile(uuid, saveDir, fileName) {
    try {
        const url = `/board/removeFile`;
        const res = await fetch(url, {
            method: 'DELETE',
            headers: {
                'Content-Type': 'application/json',
                [csrfHeader] : csrfToken
            },
            body: JSON.stringify({
                uuid: uuid,
                saveDir: saveDir,
                fileName: fileName
            })
        });

        return res.text();
    } catch (error) {
        console.log(error);
    }
}

document.addEventListener('click', (e)=>{
    if(e.target.id == "file-x") {
        let uuid = e.target.dataset.uuid;
        let saveDir = e.target.dataset.saveDir;
        let fileName = e.target.dataset.fileName;
        console.log(saveDir, fileName);
        removeFile(uuid, saveDir, fileName).then(result=>{
            if (result > 0) {
                // 화면에서 li 삭제
                e.target.closest('li').remove();
            }
        });
    }
})