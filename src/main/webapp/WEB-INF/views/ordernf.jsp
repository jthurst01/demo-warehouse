<%@ page session="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<html>
<head>
    <title>Invoice Statement Not Found</title>
</head>
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
        $('#refreshButton').click(refreshHandler);
    });

    function refreshHandler(){
        alert(sr.context.environment.parameters.orderId);
        var invoiceUri=sr.context.links.sobjectUrl + "work_wef__Invoice_Statement__c/" + sr.context.environment.parameters.orderId;
        Sfdc.canvas.client.ajax(invoiceUri,{
            client : sr.client,
            method: 'PATCH',
            contentType: "application/json",
            data: JSON.stringify(""),
            success : localUpdateHandler
        });
    }

    function localUpdateHandler(data){
        console.log("Status from remote salesforce call:", data);
        if (data.status === 200 || data.status === 204){
            window.top.location.href = getRoot() + "/${order.id}";
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
        <h2 style="font-size: 14; font-weight: bold; font-family: Arial;">Invoice Statement Not Found</h2>
        <h2 style="font-size: 14; font-weight: bold; font-family: Arial;">Click the button to sync the records</h2>
        <button id="refreshButton">Refresh</button>
    </div>
    <div>
</body>
</html>

