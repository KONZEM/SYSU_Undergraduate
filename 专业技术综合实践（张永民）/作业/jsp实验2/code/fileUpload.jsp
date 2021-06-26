<%@ page pageEncoding="utf-8" contentType="text/html; charset=utf-8"%>
<%@ page import="java.io.*, java.util.*, org.apache.commons.io.*"%>
<%@ page import="org.apache.commons.fileupload.*"%>
<%@ page import="org.apache.commons.fileupload.disk.*"%>
<%@ page import="org.apache.commons.fileupload.servlet.*"%>
<html>
<head>
    <title>文件传输例子</title>
</head>
<body>
    <% request.setCharacterEncoding("utf-8");%>
    <% boolean isMultipart =    ServletFileUpload.isMultipartContent(request);
       String id = "";
       String filename = "";
       String path = "";
       if (isMultipart) {
           FileItemFactory factory = new DiskFileItemFactory();
           ServletFileUpload upload = new ServletFileUpload(factory);
           List items = upload.parseRequest(request);
           for (int i=0; i<items.size(); ++i) {
               FileItem fi = (FileItem)items.get(i);
               if (fi.isFormField())
                   id = fi.getString("utf-8");
                   // out.print(fi.getFieldName() + ":" + fi.getString("utf-8"));
               else {
                   DiskFileItem dfi = (DiskFileItem)fi;
                   if (!dfi.getName().trim().equals("")) {
                       filename = id + "_" + FilenameUtils.getName(dfi.getName());
                       String filePath = application.getRealPath("/file") + System.getProperty("file.separator") +  filename;
                       path = "./file/" + filename;
                       out.print("文件被上传到服务器上的实际位置：");
                       out.print(new File(filePath).getAbsolutePath());
                       dfi.write(new File(filePath));
                   }
               }
           }
       }
    %>
    <br/><br/>
    <a href="<%=path%>"><%=filename%></a>
</body>
</html