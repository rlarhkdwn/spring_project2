package com.koreait.www.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.koreait.www.domain.BoardFileDTO;
import com.koreait.www.domain.BoardVO;
import com.koreait.www.domain.CommentVO;
import com.koreait.www.domain.FileVO;
import com.koreait.www.domain.PagingVO;
import com.koreait.www.handler.FileHandler;
import com.koreait.www.handler.PagingHandler;
import com.koreait.www.service.BoardService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@RequiredArgsConstructor
@RequestMapping("/board/*")
@Slf4j
@Controller
public class BoardController {
	// 생성자 주입
	private final BoardService bsv;
	private final FileHandler fh;
	
	// /board/register => /board/register.jsp
	// 요청경로와 리턴경로가 같으면 void
	@GetMapping("/register")
	public void register() {}
	
	// 첨부파일 추가 => multipart/form-data => MultipartFile
	// multiple => 파일 여러개 가능 => MultipartFile[]
	@PostMapping("/insert")
	public String insert(BoardVO board, MultipartFile[] files) {
		List<FileVO> flist = null;
		// files에 값이 있다면 flist를 생성
		if (!files[0].isEmpty()) {
			// 파일에 내용이 있다면...
			// MultipartFile[] => DB에 저장할 값 생성 => List<FileVO>로 생성
			// 실제 파일을 저장 => FileHandler
			flist = fh.uploadFile(files);
			log.info(">>> flist " + flist);
		}
		
		BoardFileDTO bfdto = new BoardFileDTO(board, flist);
		int isOk = bsv.insert(bfdto);
		
		// int isOk = bsv.insert(board);
		log.info(">>> insert " + (isOk > 0 ? "성공" : "실패"));
		return "redirect:/board/list";
	}
	
	@GetMapping("/list")
	public String list(Model model, PagingVO pgvo) {
		log.info(">>> pgvo " + pgvo);
		List <BoardVO> list = bsv.getList(pgvo);
		int totalCount = bsv.getTotalCount(pgvo);
		PagingHandler ph = new PagingHandler(totalCount, pgvo);
		model.addAttribute("list", list);
		model.addAttribute("ph", ph);
		log.info(">>> list " + list);
		log.info(">>> ph " + ph);
		return "/board/list";
	}
	
	@GetMapping({"/detail", "/modify"})
	public void detail(Model model, @RequestParam("bno") long bno, HttpServletRequest request) {
		String path = request.getServletPath();
		if (path.equals("/board/detail")) {
			// readCount 1증가
			int isOk = bsv.addReadCount(bno, 1);
		}
		BoardFileDTO boardFileDTO = bsv.getDetail(bno);
		
		model.addAttribute("boardFileDTO", boardFileDTO);
	}
	
	@PostMapping("/update")
	public String update(Model model, BoardVO board, @RequestParam(value="files", required=false) MultipartFile[] files, RedirectAttributes re) {
		List<FileVO> flist = null;
		if(files[0].getSize() > 0) {
			// 첨부파일이 있는 경우
			flist = fh.uploadFile(files);
		}
		int isOk = bsv.update(new BoardFileDTO(board, flist));
		// model.addAttribute("bno", board.getBno()); => 지금은 데이터가 전달되나 정상적이지 않음(원래 안되고 다른 이유때문에 데이터가 전달되고 있는 상황)
		
		// return "redirect:/board/detail?bno=" + board.getBno();
		re.addAttribute("bno", board.getBno());
		return "redirect:/board/detail";
	}
	
	@GetMapping("/delete")
	public String delete(@RequestParam("bno") long bno) {
		int isOk = bsv.delete(bno);
		return "redirect:/board/list";
	}
	
	@ResponseBody
	@DeleteMapping("/removeFile")
	public String removeFile(@RequestBody FileVO fvo) {
		// DB에서 삭제
		int isOk = bsv.removeFile(fvo.getUuid());
		if (isOk > 0) {
			// 실제 파일 삭제
//			FileHandler fh = new FileHandler();
//			isOk *= fh.removeFile(fvo);
		}
		return isOk > 0 ? "1" : "0";
	}
}
