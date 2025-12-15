package com.koreait.www.repository;

import java.util.List;

import com.koreait.www.domain.FileVO;

public interface FileDAO {

	int insertFile(FileVO fvo);

	List<FileVO> getList(long bno);

	int removeFile(String uuid);

	int getBno(String uuid);

	List<FileVO> getTodayFileList(String today);

	void removeFileByBno(long bno);

}
