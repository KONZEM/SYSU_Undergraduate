<%@ page language="java" import="java.util.*,java.io.*" 
         contentType="text/html; charset=utf-8"%><%
request.setCharacterEncoding("utf-8");
%><%
out.print("<h1>你提交的内容如下:</h1>");
Enumeration<String> enums=request.getParameterNames(); 
     while(enums.hasMoreElements()){ 
        String name=(String)enums.nextElement(); 
        if (name.equals("group")){
           String[] groups=request.getParameterValues("group");
           out.println(name+":"+Arrays.toString(groups)+"<br />"); 
        }
        else
          out.println(name+":"+request.getParameter(name)+"<br />"); 
     } 

%>