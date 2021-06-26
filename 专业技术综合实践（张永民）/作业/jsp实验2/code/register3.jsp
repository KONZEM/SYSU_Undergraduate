<%@ page language="java" 
    import="java.util.*" 
    contentType="text/html; charset=utf-8"
%>
<%  request.setCharacterEncoding("utf-8");
    
    String name = request.getParameter("name");
    if (name == null || name.equals("")) name = "";
    else name += "*";

    String password = request.getParameter("password");
    if (password == null || password.equals("")) password = "";

    String campus = request.getParameter("campus");
    String[] campus_checked = {"", "", "", "", ""};
    if (campus != null) {
        if (campus.equals("south")) campus_checked[0] = "checked";
        else if (campus.equals("east")) campus_checked[1] = "checked";
        else if (campus.equals("north")) campus_checked[2] = "checked";
        else if (campus.equals("zhuhai")) campus_checked[3] = "checked";
        else if (campus.equals("shenzhen")) campus_checked[4] = "checked";
    }

    String grade = request.getParameter("grade");
    String[] grade_selected = {"", "", "", ""};
    if (grade != null) {
        if (grade.equals("freshman")) grade_selected[0] = "selected";
        else if (grade.equals("sophomore")) grade_selected[1] = "selected";
        else if (grade.equals("junior")) grade_selected[2] = "selected";
        else if (grade.equals("senior")) grade_selected[3] = "selected";
    }
    
    String[] club = request.getParameterValues("club");
    String[] club_checked = {"", "", ""};
    if (club != null)
        for (int i=0; i<club.length; ++i) {
            if (club[i].equals("dance")) club_checked[0] = "checked";
            else if (club[i].equals("photo")) club_checked[1] = "checked";
            else if (club[i].equals("basketball")) club_checked[2] = "checked";
        }

    String instruction = request.getParameter("instruction");
    if (instruction == null || instruction.equals("")) instruction = "";
    else instruction += "*";
%>
<!DOCTYPE HTML>
<html>
    <head>
        <title>用户注册</title>
        <style> 
        </style>
    </head>  
    <body>
        <form action="register3.jsp" method="post">
            <input type="hidden" name="id" value="12345">
            <p>
                同学名：
                <input type="text" name="name" value="<%=name%>">
            </p>
            <p>
                密码：
                <input type="password" name="password" value="<%=password%>">
            </p>
            <p>
                校区：
                南校区<input type="radio" name="campus" value="south" <%=campus_checked[0]%>>
                东校区<input type="radio" name="campus" value="east" <%=campus_checked[1]%>>
                北校区<input type="radio" name="campus" value="north" <%=campus_checked[2]%>>
                珠海校区<input type="radio" name="campus" value="zhuhai
                " <%=campus_checked[3]%>>
                深圳校区<input type="radio" name="campus" value="shenzhen" <%=campus_checked[4]%>>
            </p>
            <p>
                年级：
                <select name="grade">
                    <option value="freshman" <%=grade_selected[0]%>>大学一年级</option>
                    <option value="sophomore" <%=grade_selected[1]%>>大学三年级</option>
                    <option value="junior" <%=grade_selected[2]%>>大学三年级</option>
                    <option value="senior" <%=grade_selected[3]%>>大学四年级</option>
                </select>
            </p>
            <p>
                社团：
                舞蹈 <input type="checkbox" name="club" value="dance" <%=club_checked[0]%>>
                摄影 <input type="checkbox" name="club" value="photo" <%=club_checked[1]%>>
                篮球 <input type="checkbox" name="club" value="basketball" <%=club_checked[0]%>>
            </p>
            <p>
                说明：
                <textarea name="instruction" rows="15" cols="40" style="vertical-align: top"><%=instruction%></textarea>
            </p>
            <input type="submit" name="submit1" value="提交">
            <input type="submit" name="submit2" value="退出">
        </form>
    </body>
</html>