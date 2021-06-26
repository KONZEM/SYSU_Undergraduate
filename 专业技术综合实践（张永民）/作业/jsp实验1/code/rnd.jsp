<%@ page language="java" 
    import="java.util.Random" 
    contentType="text/html;charset=utf-8" %>
<% Random rnd = new Random(50); %>
<html>
<head>
    <title>40个随机数</title>
</head>
<body>
    <h1>40个随机数</h1>
    <p>
        <%  for(int i=0; i<12; ++i) {
                out.print(rnd.nextInt(1000)); 
                out.print(" ");
            }
        %> 
    </p>
    <p>
        <%  for(int i=0; i<12; ++i){
                out.print(rnd.nextInt(1000));  
                out.print(" ");
            }
        %> 
    </p>
    <p>
        <%  for(int i=0; i<12; ++i) {
                out.print(rnd.nextInt(1000));  
                out.print(" ");
            }
        %> 
    </p>
    <p>
        <%  for(int i=0; i<4; ++i) {
                out.print(rnd.nextInt(1000)); 
                out.print(" "); 
            }
        %> 
    </p>
</body>
</html>