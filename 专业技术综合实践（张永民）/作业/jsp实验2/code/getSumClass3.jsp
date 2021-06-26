<%@ page contentType="text/html;charset=utf-8" %>
<html>
<head>
    <title>getAddClass3</title>
</head>
<body>
    <h1>getAddClass3</h1>
    <jsp:useBean id="add" scope="page" class="com.group.bean.Add3" />
    <form method="post" action="getSumClass3.jsp">
        <jsp:setProperty name="add" property="numA"/>
        <jsp:setProperty name="add" property="numB"/>
        <jsp:setProperty name="add" property="numC"/>
        <p>
            numA:<input type="text" name="numA"/>
            numB:<input type="text" name="numB"/>
            numC:<input type="text" name="numC"/>
        </p>
        <p>
            <jsp:getProperty name="add" property="numA"/>
            + <jsp:getProperty name="add" property="numB"/>
            + <jsp:getProperty name="add" property="numC"/>
            = <jsp:getProperty name="add" property="sum"/>
        </p>
        <input type="submit" name="submit" value="提交"/>
    </form>
</body>
</html>