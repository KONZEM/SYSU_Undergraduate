<%@ page language="java" import="java.util.*,java.io.*"
contentType="text/html;
charset=utf-8"%><%
request.setCharacterEncoding("utf-8");
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
String absPath = application.getRealPath("/"); StringBuilder href= new StringBuilder("");
File root = new File(absPath); // 取得根文件夹 
/*
 for (File file:root.listFiles()) {
 // 取得根文件夹中的所有文件 和文件夹 
 if (!file.isDirectory()) {
    href.append("<a href=\"");
    href.append(file.getName());
    href.append("\">");
    href.append(file.getName());
    href.append("</a><br />"); 
 }
}
*/
%><!DOCTYPE html>
<html>
<head>

<title>HTML&CSS在线测试工具</title>
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<!--
   <base href="<%=basePath%>">
   <link rel="stylesheet" type="text/css" href="styles.css">
   -->
<style>
#TestCode {
   width: 100%;
   font-size: 18px;
   white-space: pre;
   overflow: auto;
}

#submit1 {
   font-size: 18px;
}
</style>
</head>
<body>
  <p>评论:<% out.print(request.getParameter("cominput"));%></p>
</body>
</html>