package com.koreait.www.service;


import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreait.www.domain.BoardFileDTO;
import com.koreait.www.domain.BoardVO;
import com.koreait.www.domain.FileVO;
import com.koreait.www.domain.PagingVO;
import com.koreait.www.repository.BoardDAO;
import com.koreait.www.repository.FileDAO;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@RequiredArgsConstructor
@Slf4j
@Service
public class BoardServiceImpl implements BoardService {
	private final BoardDAO bdao;
	private final FileDAO fdao;

//	@Override
//	public int insert(BoardVO board) {
//		return bdao.insert(board);
//	}

	@Override
	public List<BoardVO> getList(PagingVO pgvo) {
		return bdao.getList(pgvo);
	}

	@Transactional
	@Override
	public BoardFileDTO getDetail(long bno) {
		BoardVO board = bdao.getDetail(bno);
		List<FileVO> flist = fdao.getList(bno);
		BoardFileDTO boardFileDTO = new BoardFileDTO(board, flist);
		return boardFileDTO;
	}

	@Transactional
	@Override
	public int update(BoardFileDTO bfdto) {
		int isOk = bdao.update(bfdto.getBoard());

		// 수정 후 detail로 가면 조회수 1증가 => 미리 1감소
		isOk *= bdao.updateReadCount(bfdto.getBoard().getBno(), -1);
		
		if(bfdto.getFlist() == null) {
			// 파일이 없다면
			return isOk;
		}
		if (isOk > 0) {
			for(FileVO fvo : bfdto.getFlist()) {
				// bno값은 없는 상태
				fvo.setBno(bfdto.getBoard().getBno());
				isOk *= fdao.insertFile(fvo);
			}
			isOk *= bdao.updateFileQty(bfdto.getBoard().getBno(), bfdto.getFlist().size());
		}
		return isOk;
	}

	@Transactional
	@Override
	public int delete(long bno) {
		int isOk = bdao.delete(bno);
		if (isOk > 0) {
			fdao.removeFileByBno(bno);
		}
		return isOk;
	}

	@Override
	public int getTotalCount(PagingVO pgvo) {
		return bdao.getTotalCount(pgvo);
	}

	@Override
	public int addReadCount(long bno, int i) {
		return bdao.updateReadCount(bno, i);
	}

	@Transactional
	@Override
	public int insert(BoardFileDTO bfdto) {
		// board => insert => boardMapper
		// file => insert => fileMaper
		int isOk = bdao.insert(bfdto.getBoard()); // DB에 insert가 되면 bno 생김
		if(bfdto.getFlist() == null) { // 파일이 없는 경우
			return isOk;
		}
		
		// fileDAO 생성 => fileMapper 생성 => fileVO 값을 DB로 등록
		// bno 가져오기
		if (isOk > 0) {
			long bno = bdao.getBno();
			for (FileVO fvo : bfdto.getFlist()) {
				fvo.setBno(bno);
				// 저장
				isOk *= fdao.insertFile(fvo);
			}
			isOk *= bdao.updateFileQty(bno, bfdto.getFlist().size());
		}		
		return isOk;
	}

	@Transactional
	@Override
	public int removeFile(String uuid) {
		int bno = fdao.getBno(uuid);
		int isOk = fdao.removeFile(uuid);
		if (isOk > 0) {			
			isOk *= bdao.updateFileQty(bno, -1);
		}
		return isOk; 
	}

}
