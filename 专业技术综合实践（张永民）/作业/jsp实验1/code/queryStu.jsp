<%@ page language="java" import="java.util.*, java.sql.*" 
         contentType="text/html; charset=utf-8" %>
<%
	request.setCharacterEncoding("utf-8");
	String msg = "";
    String query = request.getParameter("query");
	String connectString = "jdbc:mysql://103.26.79.35:3306/teaching"
					+ "?autoReconnect=true&useUnicode=true"
					+ "&characterEncoding=UTF-8"; 
    StringBuilder table = new StringBuilder();
    if (query != null && !query.isEmpty()) {
        try{
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = DriverManager.getConnection(connectString, 
                            "user", "123");
            Statement stmt = con.createStatement();
            ResultSet rs = stmt.executeQuery("select * from stu where name like '%" + query + "%'");
            table.append("<table><tr><th>id</th><th>学号</th><th>姓名</th><th>-</th></tr>");
            while(rs.next()) {
                table.append(String.format("<tr><td>%s</td><td>%s</td><td>%s</td><td>%s %s</td></tr>", 
                            rs.getString("id"), rs.getString("num"), rs.getString("name"), 
                            "<a href='updateStu.jsp?pid=" + rs.getString("id") + "'>修改</a>", 
                            "<a href='deleteStu.jsp?pid=" + rs.getString("id") + "'>删除</a>")
                );
            }
            table.append("</table>");
            rs.close();
            stmt.close();
            con.close();
        }
        catch (Exception e){
            msg = e.getMessage();
        }
    }
    else
        query = "";
%>
<!DOCTYPE HTML>
<html>
<head>
    <title>查询学生名单</title>
    <style>
        table {
            border-collapse: collapse;
            border: none;
            width: 500px;
        }
        td, th {
            border: solid grey 1px;
            margin: 0;
            padding: 5px;
        }
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
	    <h1>查询学生名单</h1>  
        <form action="queryStu.jsp" method="post" name="form">
            输入查询<input id="query" name="query" type="text"  value="<%=query%>"/>
            <input id="submit" name="submit" type="submit" value="查询"/> 
        </form>
        <br><br>
	    <%=table%><br> 
        <div style="float: left">
            <a href="addStu.jsp">新增</a>
            <a href="browseStu.jsp">返回</a>
        </div>
        <br><br>
    </div>
</body>
</html>