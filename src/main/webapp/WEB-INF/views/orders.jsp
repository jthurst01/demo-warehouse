<%@ page session="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<html>
	<head>
		<title>Orders</title>
		<link rel="stylesheet" href="<c:url value="/resources/blueprint/screen.css" />" type="text/css" media="screen, projection">
		<%--<link rel="stylesheet" href="<c:url value="/resources/blueprint/print.css" />" type="text/css" media="print">--%>
		<!--[if lt IE 8]>
			<link rel="stylesheet" href="<c:url value="/resources/blueprint/ie.css" />" type="text/css" media="screen, projection">
		<![endif]-->
		<script type="text/javascript" src="<c:url value="/resources/jquery-1.4.min.js" /> "></script>
        <script type="text/javascript" src="<c:url value="/resources/json2.js" /> "></script>
        <script type="text/javascript" src="<c:url value="/resources/canvas-all.js" /> "></script>

        <c:if test="${not empty signedRequestJson}">
          <script type="text/javascript"/>
            var signedRequest = JSON.parse('${signedRequestJson}');
          </script>
        </c:if>
	</head>
	<body>
		<div class="container">
            <h2 style="font-size: 1.5em; font-weight: bold;">
				Existing Invoice Statements
			</h2>
			<table width="75%">
				<tr><th width="20%">Invoice Statement</th><th width="15%">Invoice Status</th><th width="15%">Invoice Total</th><th width="*"># Line Items</th></tr>
			    <c:forEach items="${orders}" var="order">
			    	<tr>
                      <td><a href="orderui/${order.id}"><c:out value="${order.orderId}"/></a></td>
                      <td><c:out value="${order.status}"/></td>
                      <td><c:out value="${order.total}"/></td>
                      <td><c:out value="${order.lineItemCount}"/></td>
			    	</tr>
			    </c:forEach>
			</table>
		</div>
	</body>

	<script type="text/javascript">
		$(document).ready(function() {
			$("#order").submit(function() {
				var order = $(this).serializeObject();
				$.postJSON("order", [order], function(data) {
					$.getJSON("order/" + data[0].order_number, function(order) {
						alert("Created order "+data[0].order_number+
								"\nID = "+order.id);
						window.location.reload(true);
					});
				}, function(data) {
					var response = JSON.parse(data.response);
					alert("Error: "+response[0].id);
				});
				return false;
			});
		});
	</script>

</html>
