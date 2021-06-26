<%@ page language="java"
    import="java.util.*"
    contentType="text/html; charset=utf-8"    
%>
<html>
<head>
    <title>实现文件上传</title>
</head>
<body>
    <form name="fileupload" action="fileUpload.jsp" method="post" enctype="multipart/form-data">
        <p>
            id：<input type="text" name="id" value="888">
        </p>
        <p>
            文件名：<input type="file" name="file" size="50">
        </p>
        <p>
            <input type="submit" name="submit" value="ok">
        </p>
    </form>
</body>
</html