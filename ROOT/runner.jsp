<%@ page import="java.lang.reflect.Method" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="java.net.URISyntaxException" %>
<%@ page import="javax.tools.*" %>
<%@ page import="java.net.URI" %>
<%@ page import="java.io.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<%!

    public static void executeMain(String name, String content, PrintStream myOut){
        System.setProperty("file.encoding","UTF-8");
        //myOut.println("进入 executeMain");
        Class<?> claszz = compile(name,content, myOut);
        //myOut.println("compile结束;claszz=" + claszz);
        try {
            Method method = claszz.getMethod("main", PrintStream.class);
            method.invoke(null, new Object[] { myOut });
        } catch (Exception e) {
            myOut.println("方法执行失败;claszz=" + claszz);
            e.printStackTrace(myOut);
        }
    }
    private final static Class<?> compile(String name, String content, PrintStream myOut) {
        //myOut.println("进入 compile; ToolProvider=");
        JavaCompiler compiler = ToolProvider.getSystemJavaCompiler();
        //myOut.println("compiler=" + compiler);
        StandardJavaFileManager fileManager = compiler.getStandardFileManager(null, null, null);
        //myOut.println("fileManager=" + fileManager);
        StrSrcJavaObject srcObject = new StrSrcJavaObject(name, content);
        Iterable<? extends JavaFileObject> fileObjects = Arrays.asList(srcObject);
        String flag = "-d";
        String outDir = "";
        try {
            File classPath = new File(Thread.currentThread().getContextClassLoader().getResource("").toURI());
            //myOut.println("classPath=" + classPath.getAbsolutePath());
            outDir = classPath.getAbsolutePath() + File.separator;
        } catch (URISyntaxException e1) {
            myOut.println("异常: URISyntaxException");
            e1.printStackTrace(myOut);
        }
        Iterable<String> options = Arrays.asList(flag, outDir);
        JavaCompiler.CompilationTask task = compiler.getTask(null, fileManager, null, options, null, fileObjects);
        boolean result = task.call();
        if (result == true) {
            try {
                return Class.forName(name);
            } catch (ClassNotFoundException e) {
                e.printStackTrace(myOut);
            }
        }
        return null;
    }
    private static class StrSrcJavaObject extends SimpleJavaFileObject {
        private String content;
        public StrSrcJavaObject(String name, String content) {
            super(URI.create("string:///" + name.replace('.', '/') + Kind.SOURCE.extension), Kind.SOURCE);
            this.content = content;
        }
        public CharSequence getCharContent(boolean ignoreEncodingErrors) {
            return content;
        }
    }
%>
<%
String packageName = "cncrunner.test";
String className = "TestBAE" + System.currentTimeMillis(); // 来个随机数
String fullClassName = packageName +"."+ className;
String code = request.getParameter("code");
String classPrefix =
        "package " + packageName +";" + "\n" +
        "import java.io.*;" + "\n" +
        "import java.net.*;" + "\n" +
        "import java.util.*;" + "\n" +
        "" + "\n" +
        "public class " + className +" " +
        "{ " + "\n" +
        "public static void main(PrintStream out) throws Exception{" + "\n" +
        "" + code + "\n" +
        "}" + "\n" +
          "}";

    String classPostfix = "";
    String host = request.getServerName();

    if(null != code && !code.trim().isEmpty()){

        PrintStream oldOut = System.out;
        classPrefix = classPrefix.replace("System.out","out");
        classPrefix = classPrefix.replace("System.err","out");
        //
        if(host.contains("duapp")){
            // 参考 http://www.cnblogs.com/fangwenyu/archive/2011/10/12/2209051.html
            // hack - 处理jre找不到tools.jar 的问题
            System.setProperty("java.home","/usr/lib/jvm/java-7-openjdk-amd64");
        }
        //
        ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
        //
        PrintStream myOut = new PrintStream(outputStream);
        //System.setOut(myOut);
        try{
            executeMain(fullClassName, classPrefix.toString(), myOut);
            //
        } catch (Exception e){
            e.printStackTrace(myOut);
        } finally {
            // 把内容输出到 out
            //System.setOut(oldOut);
            byte[] outByte = outputStream.toByteArray();
            String content = new String(outByte);
            content = content.replace("\n", "<br/>");
            PrintWriter printWriter = response.getWriter();
            printWriter.print(content);
            printWriter.flush();
        }
        //
        return;
    }

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
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
