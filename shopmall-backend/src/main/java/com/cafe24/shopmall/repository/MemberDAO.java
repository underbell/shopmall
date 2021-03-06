package com.cafe24.shopmall.repository;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.cafe24.shopmall.vo.MemberVo;

@Repository
public class MemberDAO {
	
	
	@Autowired
	private SqlSession sqlSession;
	
	/**
	 * 아이디 중복체크
	 */
	public Boolean isIdExist(String id) {
		Long cnt = sqlSession.selectOne("member.selectById", id);
		return cnt == 1;
	}
	
	/**
	 *  회원 존재 여부 
	 */
	public boolean isExistMemberNo(Long value) {
		int result = sqlSession.selectOne("member.isExistMemberNo", value);
		return result==1;
	}
	
	/**
	 * member 테이블에 행 추가 
	 */
	public Long insertMember(MemberVo memberVo) {
		sqlSession.insert("member.insertMember", memberVo);
		return memberVo.getCode();
	}
	/**
	 * 로그인 
	 */
	public MemberVo selectUserById(String id) {
		MemberVo result = sqlSession.selectOne("member.selectUserById", id);
		return result;
	}
	
	/**
	 * 회원 정보가져오기
	 */
	public MemberVo getMemberInfo(Long no) {
		return sqlSession.selectOne("member.selectMemberByCode", no);
	}
	
	/**
	 * 관리자 회원 목록 가져오기
	 */
	public List<MemberVo> getMemberList(){
		return sqlSession.selectList("member.selectMemberList");
	}

	public Boolean updateMember(MemberVo memberVo) {
		int result = sqlSession.update("member.updateMember", memberVo);
		return result==1;
	}

	public Boolean deleteMember(Map<String, Object> param) {
		int result = sqlSession.update("member.deleteMember", param);
		return result == 1;
	}

}
