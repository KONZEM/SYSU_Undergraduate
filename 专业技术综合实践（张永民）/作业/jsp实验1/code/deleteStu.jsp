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
    try {
        Class.forName("com.mysql.jdbc.Driver");
        Connection con = DriverManager.getConnection(connectString, 
                        user, pwd);
        Statement stmt = con.createStatement();
        int cnt = stmt.executeUpdate(String.format("delete from stu where id = '%s'", id));
        if (cnt != 0) msg = "Delete Success!";
    }
    catch(Exception e) {
        msg = e.getMessage();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>删除学生记录</title>
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
        <h1>删除学生记录</h1>
        <%=msg%>
        <br><br>
        <a href="browseStu.jsp">返回</a>
    </div>
</body>
</html>