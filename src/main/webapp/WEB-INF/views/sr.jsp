<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<html>
<head>
	<title>Home</title>
</head>
<body>
<h1>
	Signed Request Test
</h1>

<P>Enter the Signed Request</P>
<form id="srPost" action="/orderui" method="POST">
    <textarea rows="4" cols="50" name="signed_request"></textarea>
    <input type="submit" value="Submit"/>
</form>

</body>
</html>
