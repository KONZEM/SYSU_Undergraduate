<%@ page language="java" 
    import="java.util.*" 
    contentType="text/html; charset=utf-8"
%>
<%
    request.setCharacterEncoding("utf-8");
    if (request.getParameter("submit2") != null)
        response.sendRedirect("http://172.18.187.6/");
    String id = request.getParameter("id");
    String name = request.getParameter("name");
    String password = request.getParameter("password");
    String campus = request.getParameter("campus");
    String grade = request.getParameter("grade");
    String[] club = request.getParameterValues("club");
    String instruction = request.getParameter("instruction");
    String submit1 = request.getParameter("submit1");
    String submit2 = request.getParameter("submit2");
%>
<!DOCTYPE HTML>
<html>
    <head>
        <title>用户注册输入显示</title>
    </head>  
    <body>
        <p> id: <%=id%></p>
        <p> 同学名: <%=name%></p>
        <p> 密码: <%=password%></p>
        <p> 校区: <%=campus%></p>
        <p> 社团: 
            <%  out.print("[");
                if (club != null) out.print(club[0]);
                for (int i=1; i<club.length; ++i) out.print(", " + club[i]);
                out.print("]");
            %>
        </p>
        <p> 年级: <%=grade%></p>
        <p> 说明: <%=instruction%></p>
        <p> submit1: <%=submit1%></p>
        <p> submit2: <%=submit2%></p>
    </body>
</html>