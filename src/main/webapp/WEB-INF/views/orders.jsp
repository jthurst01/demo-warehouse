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
          <script type="text/javascript">
            var signedRequest = JSON.parse('${signedRequestJson}');
          </script>
        </c:if>

        <style>
            #myTable {
                padding: 0px 0px 4px 0px;
            }

            #myTable td {
                border-bottom: 1px solid #CCCCCC;
            }

            #shippedInvoiceTitle {
                 font-size: 1.2em;
                 font-weight: bold;
                 padding-right: 10px;
             }

            #unshippedInvoiceTitle {
                font-size: 1.2em;
                font-weight: bold;
                padding-right: 10px;
            }

            #myPageBlockTable {
                padding:5px;
                background: #F8F8F8;
                border: 1px solid #CDCDCD;
                border-radius: 6px;
                border-top: 3px solid #998c7c;
            }

            #shippedInvoiceTable {
                border-right: 1px solid #CDCDCD;
                border-left: 1px solid #CDCDCD;
            }

            #shippedInvoiceTable th {
                background: #f2f3f3;
                border: 1px solid #CDCDCD;
                border-left: 0px;
                position: relative;
                bottom: 2px;
                padding-right: 5px;
                padding-left: 4px;
            }

            .myShippedInvoiceTableRow {
                background: white;
                border-bottom: 1px solid #CCCCCC;
            }

            .myShippedInvoiceTableRow td {
                padding: 4px 0px 4px 8px;
                border-bottom: 1px solid #CCCCCC;
            }

            #unshippedInvoiceTable {
                border-right: 1px solid #CDCDCD;
                border-left: 1px solid #CDCDCD;
            }

            #unshippedInvoiceTable th {
                background: #f2f3f3;
                border: 1px solid #CDCDCD;
                border-left: 0px;
                position: relative;
                bottom: 2px;
                padding-right: 5px;
                padding-left: 4px;
            }

            .myUnshippedInvoiceTableRow {
                background: white;
                border-bottom: 1px solid #CCCCCC;
            }

            .myUnshippedInvoiceTableRow td {
                padding: 4px 0px 4px 8px;
                border-bottom: 1px solid #CCCCCC;
            }
        </style>
	</head>
	<body>
		<div class="container">
            <!--div><img src="/resources/images/logo.png" width="800px" /></div-->
            <h2 style="font-size: 1.5em; font-weight: bold;">
                Existing Invoice Statements
            </h2>
            <div id="myPageBlockTable">
                <h2 id="shippedInvoiceTitle">
                    Pending Invoice Statements
                </h2>
                <table id="unshippedInvoiceTable">
                    <tr><th style="border-left:0px;">Invoice Statement</th><th>Invoice Status</th><th>Invoice Total</th><th style="border-right:0px;"># Line Items</th></tr>
                    <c:forEach items="${orders}" var="order">
                        <c:if test="${order.status ne 'Shipped'}">
                            <tr class="myUnshippedInvoiceTableRow">
                              <td><a href="orderui/${order.id}"><c:out value="${order.orderId}"/></a></td>
                              <td><c:out value="${order.status}"/></td>
                              <td><c:out value="${order.total}"/></td>
                              <td><c:out value="${order.lineItemCount}"/></td>
                            </tr>
                        </c:if>
                    </c:forEach>
                </table>
                <h2 id="unshippedInvoiceTitle">
                    Shipped Invoice Statements
                </h2>
                <table id="shippedInvoiceTable">
                    <tr><th style="border-left:0px;">Invoice Statement</th><th>Invoice Status</th><th>Invoice Total</th><th style="border-right:0px;"># Line Items</th></tr>
                    <c:forEach items="${orders}" var="order">
                        <c:if test="${order.status == 'Shipped'}">
                            <tr class="myShippedInvoiceTableRow">
                                <td><a href="orderui/${order.id}"><c:out value="${order.orderId}"/></a></td>
                                <td><c:out value="${order.status}"/></td>
                                <td><c:out value="${order.total}"/></td>
                                <td><c:out value="${order.lineItemCount}"/></td>
                            </tr>
                        </c:if>
                    </c:forEach>
                </table>
             </div>
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
