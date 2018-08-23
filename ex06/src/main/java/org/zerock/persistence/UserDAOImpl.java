package org.zerock.persistence;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;
import org.zerock.domain.LoginDTO;
import org.zerock.domain.UserVO;

@Repository
public class UserDAOImpl implements UserDAO{
	@Inject
	private SqlSession session;
	
	private static String namespace="org.zerock.mapper.userMapper";
	
	@Override
	public UserVO login(LoginDTO dto) throws Exception {
		
		return session.selectOne(namespace+".login",dto);
	}

	@Override
	public void keepLogin(String uid, String sessionId, Date next) {
		Map<String,Object> map=new HashMap<>();
		map.put("uid", uid);
		map.put("sessionId", sessionId);
		map.put("next", next);
		
		session.update(namespace+".keepLogin",map);
	}

	@Override
	public UserVO checkUserWithSessionKey(String value) {
		
		return session.selectOne(namespace+".checkUserWithSessionKey",value);
	}

}
