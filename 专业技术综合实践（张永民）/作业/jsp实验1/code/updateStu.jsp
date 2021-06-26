<%@ page language="java" 
    import="java.utils.*, java.sql.*" 
    contentType="text/html; charset=utf-8"
%>
<%  request.setCharacterEncoding("utf-8");
    String msg = "";
    String connectString = "jdbc:mysql://103.26.79.35:3306/teaching"
					+ "?autoReconnect=true&useUnicode=true"
					+ "&characterEncoding=UTF-8"; 
    String user = "user";
    String pwd = "123";
    String id = request.getParameter("pid");
    String num = request.getParameter("num");
    String name = request.getParameter("name");
    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection con = DriverManager.getConnection(connectString, 
                        user, pwd);
        Statement stmt = con.createStatement();
        if (num == null || num.isEmpty()) {
            ResultSet rs = stmt.executeQuery(String.format("select * from stu where id = '%s'", id));
            if (rs.next()) {
                num = rs.getString("num");
                name = rs.getString("name");
            }
        }
        else {
            int cnt = stmt.executeUpdate(String.format("update stu set num = '%s', name = '%s' where id = '%s'", num, name, id));
            if (cnt != 0) msg = "Update Success!";
        }
    }
    catch(Exception e) {
        msg = e.getMessage();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>修改学生记录</title>
    <style>
        a:link, a:visited {color: blue}
        .container {
            margin: 0 auto;
            width: 500px;
            text-align: center; 
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>修改学生记录</h1>
        <form action="updateStu.jsp" method="post" name="form">
            学号：<input id="num" name="num" type="text" value="<%=num%>"/>
            <br><br>
            姓名：<input id="name" name="name" type="text" value="<%=name%>"/>
            <br><br>
            <input id="pid" name="pid" type="hidden" value="<%=id%>">
            <input type="submit" name="save" value="保存">
            <input type="reset" name="reset" value="清空">
        </form>
        <br>
        <%=msg%>
        <br><br>
        <a href="browseStu.jsp">返回</a>
    </div>
</body>
</html>