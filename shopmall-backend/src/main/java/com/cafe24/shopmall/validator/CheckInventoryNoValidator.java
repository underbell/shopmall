package com.cafe24.shopmall.validator;

import javax.validation.ConstraintValidator;
import javax.validation.ConstraintValidatorContext;

import org.springframework.beans.factory.annotation.Autowired;

import com.cafe24.shopmall.repository.CartDAO;
import com.cafe24.shopmall.validator.constraints.ValidCheckInventoryNO;

public class CheckInventoryNoValidator implements ConstraintValidator<ValidCheckInventoryNO, Long>{
	
	@Autowired
	private CartDAO cartDao;
	
	@Override
	public void initialize(ValidCheckInventoryNO constraintAnnotation) {
	}
	
	@Override
	public boolean isValid(Long value, ConstraintValidatorContext context) {
		
		if(value == null ) {
			return false;
		}
		
		Long no = Long.valueOf(String.valueOf(value));
		
		return cartDao.isExistInventroyNo(no);
	}


}
