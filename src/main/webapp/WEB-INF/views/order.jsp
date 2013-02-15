<%@ page session="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<html>
	<head>

		<title>Order</title>
		<link rel="stylesheet" href="<c:url value="/resources/blueprint/screen.css" />" type="text/css" media="screen, projection">
		<%--<link rel="stylesheet" href="<c:url value="/resources/blueprint/print.css" />" type="text/css" media="print">--%>
		<!--[if lt IE 8]>
			<link rel="stylesheet" href="<c:url value="/resources/blueprint/ie.css" />" type="text/css" media="screen, projection">
		<![endif]-->
		<%--<link rel="stylesheet" href="<c:url value="/resources/popup.css" />" type="text/css" media="screen, projection">--%>
		<script type="text/javascript" src="<c:url value="/resources/jquery-1.4.min.js" /> "></script>
        <script type="text/javascript" src="<c:url value="/resources/json.min.js" /> "></script>
        <script type="text/javascript" src="<c:url value="/resources/canvas-all.js" /> "></script>
        <script>
            var sr =  JSON.parse('${not empty signedRequestJson?signedRequestJson:"{}"}');
            Sfdc.canvas(function() {
                // Setup the finalize
                if (sr.client.oauthToken){
                    $('#finalizeButton').click(finalizeHandler);
                    $('#finalizeButton').show();
                }
                else{
                    $('#finalizeButton').click(null);
                    $('#finalizeButton').hide();
                }
            });

            function finalizeHandler(){
                var invoiceUri=sr.context.links.sobjectUrl + "work_wef__Invoice_Statement__c/${order.id}";
                var body = {"work_wef__Status__c":"Shipped"};
                Sfdc.canvas.client.ajax(invoiceUri,{
                        client : sr.client,
                        method: 'PATCH',
                        contentType: "application/json",
                        data: JSON.stringify(body),
                        success : localUpdateHandler
                });
            }

            function localUpdateHandler(data){
                console.log("Status from remote salesforce call:", data);
                if (data.status === 200 || data.status === 204){
                  // Update local Order status.
                  $.ajax({
                      url : "/order/${order.id}",
                      type: "PUT",
                      data: JSON.stringify({status:"Shipped", orderId:"${order.orderId}", total:"${order.total}"}),
                      success: function() {
                          //document.location.reload(true);
                          window.top.location.href = getRoot() + "/${order.id}";
                      },
                      error: function(){
                        alert("Error occurred updating local status.");
                      },
                      contentType:"application/json"
                  });
                }
                else{
                    alert("Remote call to salesforce failed. Status: "+data.status+", Text: " + data.statusText);
                }
            }
            
            function getRoot() {
            	return sr.client.instanceUrl;
            }
        </script>
		
		<style>
			#myTable {
				padding: 0px 0px 4px 0px;
			}
			
			#myTable td {
				border-bottom: 1px solid #CCCCCC;
			}
			
			.myCol {
				text-align: left;
				color: #4a4f5b;
				font-weight: bold;
			}
			
			.valueCol {
				padding-left:10px;
			}
			
			#bodyDiv {
				padding:0px;
				padding-top: 0px;
			}
			
			#lineItemTitle {
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
			
			#lineItemTable {
				border-right: 1px solid #CDCDCD;
				border-left: 1px solid #CDCDCD;
			}
			
			#lineItemTable th {
				background: #f2f3f3;
				border: 1px solid #CDCDCD;
				border-left: 0px;
				position: relative;
				bottom: 2px;
				padding-right: 5px;
				padding-left: 4px;
			}
			
			.span-12 {
				width:700px;
			}
			
			.myLineItemTableRow {
				background: white;
				border-bottom: 1px solid #CCCCCC;
			}
			
			.myLineItemTableRow td {
				padding: 4px 0px 4px 8px;
				border-bottom: 1px solid #CCCCCC;
			}
		</style>

	</head>
	<body>
		<div id="bodyDiv" style="width:inherit;">
		<div class="container"> 
			<h2 style="font-size: 1.5em; font-weight: bold;">
				Invoice Statement <a href="#" onclick="window.top.location.href = getRoot() + '/${order.id}';"> <c:out value="${order.id}"/> </a>
			</h2>
			<div class="span-12 last"> 
				<table id="myTable">
                <tr><td class="myCol">Order Id:</td><td class="valueCol"><c:out value="${order.orderId}"/></td></tr>
                <tr><td class="myCol">Total:</td><td class="valueCol"><c:out value="${order.total}"/></td></tr>
                <tr><td class="myCol">Status:</td><td class="valueCol"><c:out value="${order.status}"/></td></tr>
				</table>
				
				<div id="myPageBlockTable">
                <h2 id="lineItemTitle">
                    Line Items
                </h2>
                <table id="lineItemTable">
                    <tr><th style="border-left:0px;">ID</th><th>Line Item Name</th><th>Quantity</th><th>Unit Price</th><th>Total</th><th style="border-right:0px;">Item</th></tr>
                    <c:forEach items="${order.lineItems}" var="li">
                        <tr class="myLineItemTableRow">
                            <td><a href="#" onclick="window.top.location.href = getRoot() + '/${li.id}';"><c:out value="${li.id}"/></a></td>
                            <td><c:out value="${li.lineItemId}"/></td>
                            <td><c:out value="${li.quantity}"/></td>
                            <td><c:out value="${li.unitPrice}"/></td>
                            <td><c:out value="${li.total}"/></td>
                            <td><c:out value="${li.item}"/></td>
                        </tr>
                    </c:forEach>
                </table>
                <button onclick="location.href='/orderui'">Back</button>
			    <c:if test="${order.status ne 'Shipped'}">
                    <button id="finalizeButton">Finalize</button>
                </c:if>
                </div>
			</div>
		</div>
		<div>
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
