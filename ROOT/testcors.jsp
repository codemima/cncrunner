<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    response.setHeader("Access-Control-Allow-Origin","*");
%>
{ 
	"message":"测试跨域支持",
	"meta":{},
	"status":1,
	"ts": <%=System.currentTimeMillis() %>
}