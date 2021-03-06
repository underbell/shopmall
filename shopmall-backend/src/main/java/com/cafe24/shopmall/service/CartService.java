package com.cafe24.shopmall.service;


import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.cafe24.shopmall.repository.CartDAO;
import com.cafe24.shopmall.vo.CartVo;

@Service
public class CartService {
	
	@Autowired
	private CartDAO cartDao;

	public Long findInventoryNo(String opt_value, Long prd_no) {
		return cartDao.findInventroyNo(opt_value,prd_no);
	}
	
	/**
	 *  1. 회원 일 때,
	 *  1.1 세션으로 넘어온 값을 가져가서 비회원 테이블에 있는 장바구니 목록 을 가져온다.
	 *  1.1.1 있으면 비회원 테이블에서 지우고 회원 장바구니 테이블에 insert한다.
	 *  1.1.1.1 insert하려는 inventroyno와 같은지 비교하여 있으면 수량 만큼 update 한다.
	 *  1.1.2 없으면 회원 테이블에서 inventroyno가 존재하는지 검색한다.
	 *  1.1.2.1 존재하면 false로 return 한다.
	 *  
	 */
	@Transactional
	public Map<String,Object> add(CartVo cartVo) {
		
		Map<String,Object> map = new HashMap<String, Object>();
		Boolean result = null;
		//비회원
		if(cartVo.getMember_code() == null) {
			Integer count = cartDao.get(cartVo,"none");
			result = count == null?cartDao.insert(cartVo, "none"):false;
			
			if(!result) {
				map.put("session_id",cartVo.getSession_id());
				map.put("inventory_no",cartVo.getInventory_no());
				map.put("count", count);
			}
			
		}
		//회원
		else {
			Integer count = cartDao.get(cartVo, "member");
			result = count == null?cartDao.insert(cartVo, "member"):false;
			
			if(!result) {
				map.put("member_code",cartVo.getMember_code());
				map.put("inventory_no",cartVo.getInventory_no());
				map.put("count", count);
			}
		}
		
		map.put("isOk", result);
		
		return map;
	}
	
	//회원
	public List<Map<String,Object>> get(Long member_code) {
		List<Map<String,Object>> cartList = cartDao.getList(member_code,"member");
		return cartList;
	}
	//비회원
	public List<Map<String, Object>> get(String session_id) {
		List<Map<String, Object>> cartList = cartDao.getList(session_id,"none");
		return cartList;
	}
	
	// 수정하기
	@Transactional
	public CartVo modify(CartVo cartVo) {
		
		String status = cartVo.getMember_code()==null?"none":"member";
		
		cartDao.update(cartVo,status);
		
		return cartDao.getCart(cartVo, status);
	}
	@Transactional
	public Boolean delete(CartVo cartVo) {
		
		String status = cartVo.getMember_code()==null?"none":"member";
		
		Boolean result = cartDao.delete(cartVo,status);
		
		return result;
	}

	public List<Map<String,Object>> addLogin(long member_code, String session_id) {
		
		//비회원 장바구니 List<CartVo> 가져오기
		List<Map<String, Object>> noneCartList = cartDao.getList(session_id, "none");
		
		if(noneCartList != null && noneCartList.size() > 0) {
			//비회원 장바구니에서 삭제
			cartDao.deleteCartList(session_id,"none");
			
//			// 회원 장바구니에 insert
//			for(CartVo vo : noneCartList) {
//				vo.setMember_code(member_code);
//				// 있으면 update
//				if(cartDao.get(vo,"member")!= null) {
//					cartDao.update(vo, "member");
//				}else {
//					cartDao.insert(vo, "member");
//				}
//			}
		}
		
		
		return cartDao.getList(member_code, "member");
	}

}
