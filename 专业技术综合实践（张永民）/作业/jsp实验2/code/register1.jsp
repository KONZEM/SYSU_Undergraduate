<%@ page language="java" 
    import="java.util.*"      
    contentType="text/html; charset=utf-8"
%>
<%request.setCharacterEncoding("utf-8");%>
<!DOCTYPE HTML>
<html>
    <head>
        <title>用户注册</title>
        <style> 
        </style>
    </head>  
    <body>
        <form action="register2.jsp" method="post">
            <input type="hidden" name="id" value="12345">
            <p>
                同学名：
                <input type="text" name="name" value="张三">
            </p>
            <p>
                密码：
                <input type="password" name="password" value="12345678">
            </p>
            <p>
                校区：
                南校区<input type="radio" name="campus" value="south">
                东校区<input type="radio" name="campus" value="east">
                北校区<input type="radio" name="campus" value="north" checked>
                珠海校区<input type="radio" name="campus" value="zhuhai
                ">
                深圳校区<input type="radio" name="campus" value="shenzhen">
            </p>
            <p>
                年级：
                <select name="grade">
                    <option value="freshman">大学一年级</option>
                    <option value="sophomore">大学三年级</option>
                    <option value="junior" selected>大学三年级</option>
                    <option value="senior">大学四年级</option>
                </select>
            </p>
            <p>
                社团：
                舞蹈<input type="checkbox" name="club" value="dance">
                摄影<input type="checkbox" name="club" value="photo" checked>
                篮球<input type="checkbox" name="club" value="basketball" checked>
            </p>
            <p>
                说明：
                <textarea name="instruction" rows="15" cols="40" style="vertical-align: top">我学过Web程序设计</textarea>
            </p>
            <input type="submit" name="submit1" value="提交">
            <input type="submit" name="submit2" value="退出">
        </form>
    </body>
</html>