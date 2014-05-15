<%@ page session="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<html>
<head>
    <title>Invoice Statement Not Found</title>
    <script type="text/javascript" src="<c:url value="/resources/jquery-1.4.min.js" /> "></script>
    <script type="text/javascript" src="<c:url value="/resources/json.min.js" /> "></script>
    <script type="text/javascript" src="<c:url value="/resources/canvas-all.js" /> "></script>
    <script>
        var sr =  JSON.parse('${not empty signedRequestJson?signedRequestJson:"{}"}');
        Sfdc.canvas(function() {
            Sfdc.canvas.client.resize(sr.client, {height: "100px"});
        });
    </script>
</head>
<body>
<div id="bodyDiv">
    <div class="container">
        <h2 style="font-size: 25; font-weight: bold; font-family: Arial;">Invoice Statement Not Found</h2>
        <h2 style="font-size: 16; font-weight: bold; font-family: Arial;">Edit/Save the Invoice Statement or associated Line Items to sync with the fulfillment system.</h2>
    </div>
</div>
</body>
</html>

