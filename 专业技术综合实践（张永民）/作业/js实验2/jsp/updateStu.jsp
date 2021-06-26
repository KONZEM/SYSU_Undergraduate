<%@ page language="java" import="java.util.*,java.sql.*" 
         contentType="text/html; charset=utf-8"
%><%request.setCharacterEncoding("utf-8");
String msg="";

String id = request.getParameter("pid");
String num="";
String name="";

if(id==null){
  msg = "id is required!";
}
else{
	String connectString = "jdbc:mysql://localhost:3306/test"
				+ "?autoReconnect=true&useUnicode=true"
				+ "&characterEncoding=UTF-8"; 
	String user="user";
	String pwd="123456";
    Class.forName("com.mysql.jdbc.Driver");
    Connection con=DriverManager.getConnection(connectString, 
                   user, pwd);
    Statement stmt=con.createStatement();
    
	if(!request.getMethod().equalsIgnoreCase("POST")){
	   try{
	        String sql="select * from stu where id='"+ id + "'";
	        ResultSet rs=stmt.executeQuery(sql);
	 	    if(rs.next()){
	           name=rs.getString("name");
			   num=rs.getString("num");
	        }  
	        else {
	           msg = "The user does not exist!";
	        }
	        rs.close();
	   }catch (Exception e){
	        msg = e.getMessage();
	   }
	}
	else
	{
	   num = request.getParameter("num");
	   name = request.getParameter("name"); 	 
	   try{
	        String sql="update stu set num='"+num + "'," + "name='" + name + "' where id='"+id+"'";
	        int cnt=stmt.executeUpdate(sql);
	        if (cnt>0)
	           msg="Update Success!";
	        else
	           msg="Update Failure!";
	
	   }catch (Exception e){
	      msg = e.getMessage();
	   }
	}
    stmt.close();
    con.close();
}
%><!DOCTYPE HTML>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
   <title>修改学生记录</title>
   <style>
      a:link,a:visited {color:blue}
      .container{  
    	margin:0 auto; 
    	width:500px;  
    	text-align:center;  
      } 
   </style>
</head> 
<body>
 <div class="container">
	<h1>修改学生记录</h1>
	<form action="updateStu.jsp?pid=<%=id%>" 
	      method="post" name="f">
		学号:<input name="num" type="text" 
		            value="<%=num%>" />
		                             <br/><br/>
		姓名:<input name="name" type="text" value="<%=name%>" />
		                             <br/><br/>
		<input type="submit" name="sub" value="修改"/>
		<input type="reset" name="rset" value="清空"/>
		                             <br/><br/>
	</form>
	<%=msg%><br/><br/>
	<a href='browseStu.jsp'>返回</a>
  </div>
</body>
</html>

