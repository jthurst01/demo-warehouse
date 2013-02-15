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
        alert(sr.context.environment.parameters.name);
        var invoiceUri=sr.context.links.sobjectUrl + "work_wef__Invoice_Statement__c/" + sr.context.environment.parameters.orderId;
        var body = {"Name":sr.context.environment.parameters.name};
        alert(JSON.stringify(body));
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
            window.top.location.href = getRoot() + "/" + sr.context.environment.parameters.orderId;
        }
        else{
            alert("Remote call to salesforce failed. Status: "+data.status+", Text: " + data.statusText);
        }
    }

    function getRoot() {
        return sr.client.instanceUrl;
    }

</script>
</head>
<body>
<div id="bodyDiv">
    <div class="container">
        <h2 style="font-size: 14; font-weight: bold; font-family: Arial;">Invoice Statement Not Found</h2>
        <h2 style="font-size: 14; font-weight: bold; font-family: Arial;">Click the button to sync with the fulfillment system.</h2>
        <button id="refreshButton">Sync</button>
    </div>
    <div>
</body>
</html>

