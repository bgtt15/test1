package org.zerock.persistence;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;
import org.zerock.domain.BoardVO;
import org.zerock.domain.SearchCriteria;

@Repository
public class BoardDAOImpl implements BoardDAO{
	@Inject
	private SqlSession session;
	
	private static String namespace="org.zerock.mapper.BoardMapper";
	
	@Override
	public void create(BoardVO vo) throws Exception {
		session.insert(namespace+".create",vo);
	}

	@Override
	public BoardVO read(Integer bno) throws Exception {		
		return session.selectOne(namespace+".read",bno);
	}

	@Override
	public void update(BoardVO vo) throws Exception {
		session.update(namespace+".update",vo);
	}

	@Override
	public void delete(Integer bno) throws Exception {
		session.delete(namespace+".delete",bno);
	}

	@Override
	public List<BoardVO> listAll() throws Exception {		
		return session.selectList(namespace+".listAll");
	}

	@Override
	public List<BoardVO> listPage(int page) throws Exception {
		if(page<=0) {
			page=1;
		}
		page=(page-1)*10;
		
		return session.selectList(namespace+".listPage",page);
	}

	@Override
	public List<BoardVO> listSearch(SearchCriteria cri) throws Exception {
		
		return session.selectList(namespace+".listSearch",cri);
	}

	@Override
	public int listSearchCount(SearchCriteria cri) throws Exception {
		
		return session.selectOne(namespace+".listSearchCount",cri);
	}

	@Override
	public void updateReplyCnt(int bno, int amount) throws Exception {
		Map<String,Integer> paramMap=new HashMap<>();
		paramMap.put("bno", bno);
		paramMap.put("amount", amount);
		System.out.println("bno->"+paramMap.get("bno"));
		System.out.println("amount->"+paramMap.get("amount"));
		
		session.update(namespace+".updateReplyCnt",paramMap);
	}

	@Override
	public void updateViewCnt(int bno) throws Exception {
		session.update(namespace+".updateViewCnt",bno);
	}

	@Override
	public void addAttach(String fullName) throws Exception {
		Map<String,String> map=new HashMap<>();
		map.put("fullName",fullName);
		
		session.insert(namespace+".addAttach",map);
	}

	@Override
	public List<String> getAttach(int bno) throws Exception {
		Map<String,Integer> map=new HashMap<>();
		map.put("bno",bno);
		
		return session.selectList(namespace+".getAttach",map);
	}

	@Override
	public void deleteAttach(int bno) throws Exception {
		Map<String,Integer> map=new HashMap<>();
		map.put("bno",bno);
		session.delete(namespace+".deleteAttach",map);
	}

	@Override
	public void replaceAttach(String fullName, int bno) throws Exception {
		Map<String,Object> map=new HashMap<>();
		map.put("bno",bno);
		map.put("fullName",fullName);
		session.insert(namespace+".replaceAttach",map);
	}
		
}
