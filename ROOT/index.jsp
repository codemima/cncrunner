<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
String code = request.getParameter("code");

    if(null != code && !code.trim().isEmpty()){
        request.getRequestDispatcher("runner.jsp").forward(request, response);
		return;
    }

%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <title>测试-CNC-Runner</title>
    <meta http-equiv="pragma" content="no-cache">
    <meta http-equiv="cache-control" content="no-cache">
    <meta http-equiv="expires" content="0">    
    <meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
    <meta http-equiv="description" content="This is my page">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <!--
    <link rel="stylesheet" type="text/css" href="styles.css">
    -->
  </head>
<html>
<body style="width: 98%;">

<div>
    <form action="" method="post" target="_result">
        代码: <br/>
        <textarea name="code" rows="20" cols="140" style="width: 95%;"
>
System.out.println("OKOK");
</textarea>
        <br/>
        <button type="submit">提交</button>
    </form>
</div>

<div>
    <iframe id="_result" name="_result" width="95%"></iframe>
</div>

</body>
</html>
