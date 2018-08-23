package org.zerock.persistence;

import java.util.List;

import org.zerock.domain.Criteria;
import org.zerock.domain.ReplyVO;

public interface ReplyDAO {
	public List<ReplyVO> list(int bno) throws Exception;
	public void create(ReplyVO vo) throws Exception;
	public void update(ReplyVO vo) throws Exception;
	public void delete(int rno) throws Exception;
	
	public List<ReplyVO> listPage(int bno,Criteria cri) throws Exception;
	public int count(int bno) throws Exception;
	
	public int getBno(int rno) throws Exception;
}

