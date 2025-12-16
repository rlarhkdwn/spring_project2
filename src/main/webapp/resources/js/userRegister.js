console.log("userRegister in");

document.addEventListener('change', (e)=>{
    if (e.target.id == 'e'){
        const email = e.target.value;
        const evr = document.getElementById('emailValidResult');
        if (vaildEmail(email)){
            evr.innerHTML = `<span style="color: green;">사용가능한 아이디</span>`;
        } else {
            evr.innerHTML = `<span style="color: red;">이메일 형식이 올바르지 않습니다.</span>`;
        }
        onOffSubmitBtn()
    }
    
    if (e.target.id == 'p'){
        const password = e.target.value;
        console.log(password)
        const pvr = document.getElementById('passwordValidResult');
        if (vaildPassword(password)){
            pvr.innerHTML = `<span style="color: green;">사용가능한 비밀번호</span>`;
        } else {
            pvr.innerHTML = `<span style="color: red;">비밀번호 형식이 올바르지 않습니다.</span>`;
        }
        onOffSubmitBtn()
    }

    if (e.target.id == 'n'){
        const nickName = e.target.value;
        console.log(nickName)
        onOffSubmitBtn()
    }
})

function vaildEmail(email) {
    return (/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/).test(email)
}

function vaildPassword(password) {
    return (/^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#$%^&*])[A-Za-z\d!@#$%^&*]{8,20}$/).test(password)
}

function onOffSubmitBtn(){
    const btn = document.getElementById('submit');
    const email = document.getElementById('e').value;
    const password = document.getElementById('p').value;
    const nickName = document.getElementById('n').value;
    if (vaildEmail(email) && vaildPassword(password) && nickName != ''){
        btn.disabled = false;
    } else {
        btn.disabled = true;
    }
}