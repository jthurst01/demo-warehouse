<%@ page session="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<html>
	<head>
		<title>Order</title>
		<link rel="stylesheet" href="<c:url value="/resources/blueprint/screen.css" />" type="text/css" media="screen, projection">
		<link rel="stylesheet" href="<c:url value="/resources/blueprint/print.css" />" type="text/css" media="print">
		<!--[if lt IE 8]>
			<link rel="stylesheet" href="<c:url value="/resources/blueprint/ie.css" />" type="text/css" media="screen, projection">
		<![endif]-->
		<link rel="stylesheet" href="<c:url value="/resources/popup.css" />" type="text/css" media="screen, projection">
		<script type="text/javascript" src="<c:url value="/resources/jquery-1.4.min.js" /> "></script>
		<script type="text/javascript" src="<c:url value="/resources/json.min.js" /> "></script>
	</head>
	<body>
		<div class="container">
			<h2>
				Order <c:out value="${order.id}"/>
			</h2>
			<div class="span-12 last">
                <p>Order Id: <c:out value="${order.orderId}"/></p>
                <p>Total: <c:out value="${order.total}"/></p>
                <p>Status: <c:out value="${order.status}"/></p>
                <p>Line Items:</p>
                <c:forEach items="${order.lineItems}" var="li">
                    <p>Id: <c:out value="${li.id}"/></p>
                    <p>Line Item Id: <c:out value="${li.lineItemId}"/></p>
                    <p>Quantity: <c:out value="${li.quantity}"/></p>
                    <p>Unit Price: <c:out value="${li.unitPrice}"/></p>
                    <p>Total: <c:out value="${li.total}"/></p>
                    <p>Item: <c:out value="${li.item}"/></p>
                </c:forEach>
			    <a href="/orders">Back</a> <input id="delete" type="submit" value="Delete" />
			</div>
		</div>	
	</body>
	<%--<script>--%>
	<%--$("#delete").click(function() {--%>
		<%--$.deleteJSON("/order/${order.orderId}", function(data) {--%>
			<%--alert("Deleted order ${order.orderId}");--%>
			<%--location.href = "/orderui";--%>
		<%--}, function(data) {--%>
			<%--alert("Error deleting order ${order.orderId}");--%>
		<%--});--%>
		<%--return false;				--%>
	<%--});--%>
	<%--</script>--%>
</html>