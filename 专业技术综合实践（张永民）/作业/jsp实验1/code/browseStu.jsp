<%@ page language="java" import="java.util.*, java.sql.*" 
         contentType="text/html; charset=utf-8" %>
<%
	request.setCharacterEncoding("utf-8");
	String msg = "";
	Integer pgno = 0;
    Integer pgcnt = 4;
    String param = request.getParameter("pgno");
    if (param != null && !param.isEmpty()) pgno = Integer.parseInt(param);
    param = request.getParameter("pgcnt");
    if (param != null && !param.isEmpty()) pgcnt = Integer.parseInt(param);
    int pgprev = pgno > 0? pgno - 1: 0;
    int pgnext;
    int r_cnt = 0;
    String connectString = "jdbc:mysql://103.26.79.35:3306/teaching"
					+ "?autoReconnect=true&useUnicode=true"
					+ "&characterEncoding=UTF-8"; 
    StringBuilder table = new StringBuilder();
	try{
        Class.forName("com.mysql.jdbc.Driver");
        Connection con = DriverManager.getConnection(connectString, 
                        "user", "123");
        Statement stmt = con.createStatement();
        ResultSet rs = stmt.executeQuery(String.format("select * from stu limit %d, %d", pgno * pgcnt, pgcnt));
        table.append("<table><tr><th>id</th><th>学号</th><th>姓名</th><th>-</th></tr>");
        while(rs.next()) {
            r_cnt += 1;
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
    pgnext = r_cnt == pgcnt? pgno + 1: pgno;
%>
<!DOCTYPE HTML>
<html>
<head>
    <title>浏览学生名单</title>
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
	    <h1>浏览学生名单</h1>  
	    <%=table%>
        <br><br> 
        <div style="float: left">
            <a href="addStu.jsp">新增</a>
        </div>
        <div style="float: right">
            <a href="browseStu.jsp?pgno=<%=pgprev%>&pgcnt=<%=pgcnt%>">上一页</a>
            <a href="browseStu.jsp?pgno=<%=pgnext%>&pgcnt=<%=pgcnt%>">下一页</a>
        </div>
        <br><br>
        <%=msg%>
    </div>
</body>
</html>
