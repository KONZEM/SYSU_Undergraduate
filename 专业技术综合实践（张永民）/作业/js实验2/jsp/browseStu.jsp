<%@ page language="java" import="java.util.*,java.sql.*" 
         contentType="text/html; charset=utf-8"
%><%
	request.setCharacterEncoding("utf-8");
	String msg ="";
	Integer pgno = 0;   		//当前页号
	Integer pgcnt = 4; 	  	//每页行数
	String param = request.getParameter("pgno");
	if(param != null&&!param.isEmpty()){ 
	   pgno = Integer.parseInt(param);
	}
	
	param = request.getParameter("pgcnt");
	if(param != null&&!param.isEmpty()){
	   pgcnt = Integer.parseInt(param);
	}
	int pgprev = (pgno>0)?pgno-1:0;
	int pgnext = pgno+1;
	
	String connectString = "jdbc:mysql://localhost:3306/test"
					+ "?autoReconnect=true&useUnicode=true"
					+ "&characterEncoding=UTF-8"; 
	String user="user";
	String pwd="123456";
	StringBuilder table = new StringBuilder();
	try{
	  Class.forName("com.mysql.jdbc.Driver");
	  Connection con=DriverManager.getConnection(connectString, 
	                 user, pwd);
	  Statement stmt=con.createStatement();
	  String sql=String.format("select * from stu limit %d,%d",
	                           pgno*pgcnt,pgcnt);
	  ResultSet rs=stmt.executeQuery(sql);
	  table.append("<table>");
	  table.append("<tr><th class='c0'>id</th><th class='c1'>学号</th><th class='c2'>姓名</th>");
	  table.append("<th class='c3'>-</th></tr>");
	  
	  while(rs.next()) {
	     String id = rs.getString("id");
	     table.append("<tr><td>");
	     table.append(rs.getString("id"));
	     table.append("</td><td>");
	     table.append(rs.getString("num"));
	     table.append("</td><td>");
	     table.append(new String(rs.getString("name")));
	     table.append("</td><td>");
	     table.append("<a href='updateStu.jsp?pid="+id+"'>修改</a>&nbsp;");
	     table.append("<a href='deleteStu.jsp?pid="+id+"'>删除</a>");
	     table.append("</td></tr>");
	  }
	  table.append("</table>");
	  rs.close();
	  stmt.close();
	  con.close();
	}
	catch (Exception e){
	  msg = e.getMessage();
	}
%><!DOCTYPE HTML>
<html>
<head>
<title>浏览学生名单</title>
<style>
   table{
          border-collapse: collapse;
          border: none;
          width: 500px;
   }
   td,th{
          border: solid grey 1px;            
          margin: 0 0 0 0;
          padding: 5px 5px 5px 5px 
  }
  .c1 {
    width:100px
  }
  .c2 {
    width:200px
  }
  a:link,a:visited {
    color:blue
  }
  
  .container{  
    margin:0 auto;   
    width:500px;  
    text-align:center;  
  }  
  
</style>
</head>
<body>
  <div class="container">
	  <h1>浏览学生名单</h1>  
	  <%=table%><br><br>  
	  <div style="float:left">
	     <a href="addStu.jsp">新增</a>
	  </div>
	  <div style="float:right">
	    <a href="browseStu.jsp?pgno=<%=pgprev%>&pgcnt=<%=pgcnt%>">
	                    上一页</a>    &nbsp;	            
	    <a href="browseStu.jsp?pgno=<%=pgnext%>&pgcnt=<%=pgcnt%>">
	                   下一页</a>
	  </div>
	  <br><br>
	  <%=msg%><br><br>
  </div>
  <pre>
     数据库名为test，登录用户为"user"，密码为="123456". 
     表名为"stu"，字段:id int 自动递增 主键，num varchar(32)，name varchar(32)
     为stu建一个唯一性索引，字段为num，即要求num唯一
   </pre> 
</body>
</html>
