package org.zerock.service;

import java.util.Date;

import org.zerock.domain.LoginDTO;
import org.zerock.domain.UserVO;

public interface UserService {
	public UserVO login(LoginDTO dto) throws Exception;
	public void keepLogin(String uid,String sessionId,Date next)throws Exception;
	public UserVO checkLoginBefore(String value);
}
