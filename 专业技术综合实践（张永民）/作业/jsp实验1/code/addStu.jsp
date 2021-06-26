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
    String name = request.getParameter("name");
    String num = request.getParameter("num");
    if (request.getMethod().equalsIgnoreCase("post")) {
        Class.forName("com.mysql.jdbc.Driver");
        Connection con = DriverManager.getConnection(connectString, 
                        user, pwd);
        Statement stmt = con.createStatement();
        try {
            int cnt = stmt.executeUpdate(String.format("insert into stu(num, name) values('%s', '%s')", num, name));
            if (cnt > 0) msg = "插入成功";
            stmt.close();
            con.close();
        }
        catch(Exception e) {
            msg = e.getMessage();
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>新增学生记录</title>
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
        <h1>新增学生记录</h1>
        <form action="addStu.jsp" method="post" name="form">
            学号：<input id="num" name="num" type="text"/>
            <br><br>
            姓名：<input id="name" name="name" type="text"/>
            <br><br>
            <input type="submit" name="sub" value="保存">
        </form>
        <br><br>
        <%=msg%>
        <a href="browseStu.jsp">返回</a>
    </div>
</body>
</html>