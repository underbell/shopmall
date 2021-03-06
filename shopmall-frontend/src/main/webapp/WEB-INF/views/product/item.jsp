<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>  
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec"%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<% pageContext.setAttribute("newline", "\n");%>
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
	<meta name="description" content="">
	<meta name="author" content="">
	<title>Shop Homepage - Start Bootstrap Template</title>
	<script   src="${pageContext.servletContext.contextPath }/assets/js/jquery/jquery.min.js"></script>
	<!-- Bootstrap core CSS -->
	<link href="${pageContext.servletContext.contextPath }/assets/bootstrap/css/bootstrap.min.css" rel="stylesheet">
	<!-- Custom styles for this template -->
	<link href="${pageContext.servletContext.contextPath }/assets/css/shop-item.css" rel="stylesheet">
	<script type="text/javascript">
		$(function () {
			
			// 옵션 선택
			$('.option-select').on('change',function(){
				// 옵션 모든 것을 선택했는지 확인
				var first = $('select option:selected').first().val();
				
				var last = $('select option:selected').last().val();
				if(first != 'null' && last != 'null'){
					if(first == last){
						var result = $('select option:selected').first().text();
						$('#option-choice').text(result);
						$('#input-option-value').val(result);
					}else{
						var result = $('select option:selected').first().text() +'/' +$('select option:selected').last().text();
						$('#option-choice').text(result);
						$('#input-option-value').val(result);
					}
				}
			});
			
			// 수량 체크 함수
			$('#countMius').on('click',function(){
				var price = parseInt('${product.price}');
				var count = parseInt($('#inputCount').val()) -1 ;
				if(count >0){
					$('#inputCount').val(count);
					$('#totalPrice').html(price * count);
					$('#input-price').val(price * count);
				}
			});
			$('#countPlus').on('click',function(){
				var price = parseInt('${product.price}');
				var count = parseInt($('#inputCount').val()) + 1 ;
				$('#inputCount').val(count);
				$('#totalPrice').html(price * count);
				$('#input-price').val(price * count);
			});
			// 이미지 미리보기
			var main_src = '';
			
			<c:forEach items="${product.prodImgList}" var="vo">
				<c:if test="${vo.istitle eq true }">
					main_src = '${vo.url}';
				</c:if>
			</c:forEach>
			
			
			$('.images').on('mouseenter',function(){
				var src = this.src;
				$('#main-img').attr('src',src);
			});
			
			$('.images').on('mouseleave',function(){
				$('#main-img').remove();
				var tags = '<img id="main-img" src="${pageContext.servletContext.contextPath }/assets/images/'+main_src+'"/>'
				$('#main-img-div').append(tags);
			});
			
		});
	</script>
</head>

<body>
	<!-- Navigation -->
	<c:import url='/WEB-INF/views/includes/navigation.jsp'>
		<c:param name="active" value="shopping" />
	</c:import>
	<!-- /.Navigation -->

	<!-- Page Content -->
	<div class="container">

		<div class="row content-wrapper">
			<!-- 카테고리  -->
			<div class="col-lg-3">
				<h1 class="my-4">ShopMall</h1>
				<div class="list-group">
					<c:forEach items="${category}" var="vo" varStatus="status">
							<c:if test="${vo.catg_top_no eq null }">
								<a href="${pageContext.servletContext.contextPath }/product/category/${vo.no}" class="list-group-item">${vo.name }</a>
							</c:if>
					</c:forEach>
				</div>
			</div>
			<!-- /.col-lg-3 -->

			<div class="col-lg-9 item-wrapper">
				<form action="${pageContext.servletContext.contextPath }/cart" method="post">
				<div class="row">
					<div class="col-lg-7">
						<div class="img-title col-lg-12" id="main-img-div">
							<c:forEach items="${product.prodImgList}" var="vo">
								<c:if test="${vo.istitle eq true }">
									<img id="main-img" src="${pageContext.servletContext.contextPath }/assets/images/${vo.url}"/>
								</c:if>
							</c:forEach>
						</div>
						<div class="img-list col-lg-12">
							<div class="row">
								<c:forEach items="${product.prodImgList}" var="vo">
									<c:if test="${vo.istitle eq false }">
										<div class="col-lg-4">
											<img class="images" src="${pageContext.servletContext.contextPath }/assets/images/${vo.url}"/>
										</div>
									</c:if>
								</c:forEach>
							</div>
						</div>
						
					</div>
					<div class="col-lg-5 product-info">
						<%-- <form action="${pageContext.servletContext.contextPath }/cart" method="post"> --%>
						<div class="col-lg-12">
							<h2>${product.title }</h2>
							<input type="hidden" name="no" value="${product.no }"/>
							<%-- <sec:authorize access="isAuthenticated()">
								<sec:authentication property = "principal.no" var = "no"/>
								<input type="hidden" name="no" id="input-member-no" value="${no}"/>
							</sec:authorize> --%>
						</div>
						<div class="col-lg-12">
							<div class="row">
								<div class="col-lg-3">
									<h5> price</h5>
								</div>
								<div class="col-lg-9">
									<h4>${product.price }</h4>
								</div>
							</div>
						</div>
						<c:forEach items="${product.optionList }" var="vo">
							<div class="col-lg-12 product-option">
								<div class="row">
									<div class="col-lg-3">
											<h5>${vo.name }</h5>
									</div>
									<div class="col-lg-9">
											<select class="browser-default custom-select option-select" name="option">
												<option value="null" disabled selected>${vo.name }을/를 선택하세요</option>
												<c:forEach items="${vo.optionDetailList }" var="od">
													<option value="${od.no }">${od.value }</option>
												</c:forEach>
											</select>
									</div>
								</div>
							</div>
						</c:forEach>
						<div class="col-lg-12">
							<div class="row">
								<div class="col-lg-6 option-title" >
									<h5>${product.title }</h5>
									<h5 id="option-choice" ></h5>
									<input type="hidden" name="opt_value" id="input-option-value" value=""/>
								</div>
								<div class="col-lg-6 ">
									<div class="row option-count">
										<div class="col-lg-3">
											<button id="countMius" class="btn" type="button">-</button>
										</div>
										<div class="col-lg-6">
											<input type="text" name="count" value="1" class="form-control" id="inputCount" readonly/>
										</div>
										<div class="col-lg-3">
											<button id="countPlus" class="btn" type="button">+</button>
										</div>
									</div>
								</div>
							</div>
						</div>
						<div class="col-lg-12">
							<div class="row">
								<div class="col-lg-4">
									<h5>총 가격</h5>
								</div>
								<div class="col-lg-8">
									<h4 id="totalPrice">${product.price }</h4>
								</div>
							</div>
						</div>
						<div class="col-lg-12">
							<div class="row">
								<div class="col-lg-6">
									<button class="btn btn-primary btn-block">구매하기</button>
								</div>
								<div class="col-lg-6">
									<button class="btn btn-info btn-block" id="insert-cart" type="submit">장바구니</button>
								</div>
							</div>
						</div>
					</div>
				</div>
				<hr/>
				<div class="row product-content">
					<div class="col-lg-12 title">
						<h4>상품 상세설명</h4>
					</div>
					<div class="col-lg-12 detail">
						<p>
							${fn:replace(product.detail,newline,"<br>") }
						</p>
					</div>				
				</div>
			</form>
			</div>
			<!-- /.col-lg-9 -->
		</div>

	</div>
	<!-- /.container -->

	<!-- Footer -->
	<c:import url='/WEB-INF/views/includes/footer.jsp' />
	<!-- /.Footer -->
</body>

</html>