<%--
  Created by IntelliJ IDEA.
  User: glacier
  Date: 14-10-20
  Time: 上午8:17
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>System-Monitor</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link href="<%=request.getContextPath()%>/static/css/bootstrap.min.css" rel="stylesheet" />
    <link href="<%=request.getContextPath()%>/static/css/bootstrap.css" rel="stylesheet" />
    <link href="<%=request.getContextPath()%>/static/css/d3-bing.css" rel="stylesheet" />
    <link href="<%=request.getContextPath()%>/static/css/style.css" rel="stylesheet" />
</head>
<body>
<div>
    <nav class="navbar navbar-inverse" role="navigation">
        <div class="container-fluid">
            <div class="navbar-header">
                <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
                    <span class="sr-only">Toggle navigation</span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>
                <a class="navbar-brand" href="<%=request.getContextPath()%>/index.jsp">System-Monitor</a>
            </div>
            <div id="navbar" class="navbar-collapse collapse">
                <ul class="nav navbar-nav navbar-right">
                    <li><a href="#">主页</a></li>
                    <li><a href="#">设置</a></li>
                    <li><a href="#">说明</a></li>
                    <li><a href="#">帮助</a></li>
                </ul>
                <form class="navbar-form navbar-right">
                    <input type="text" class="form-control" placeholder="检索...">
                </form>
            </div>
        </div>
    </nav>
</div>
<div class="container-fluid">
    <div class="row">
        <div class="col-md-2 sidebar-nav">
            <ul class="nav nav-pills nav-stacked">
                <li class="nav-divider"></li>
                <li class"nav-header"><h4>空间</h4></li>
                <li><a href="<%=request.getContextPath()%>/cpu/cpu.jsp">CPU占用率</a></li>
                <li><a href="#">内存占用率</a></li>
                <li><a href="#">交换空间</a></li>
                <li class="nav-divider"></li>
                <li class="nav-header"><h4>网络</h4></li>
                <li><a href="<%=request.getContextPath()%>/network/status.jsp">网络状态</a></li>
                <!--<li><a href="localhost:8000/netstat">网络状态</a></li>-->
                <li><a href="#">上传</a></li>
                <li class="nav-divider"></li>
                <li class="nav-header"><h4>磁盘</h4></a></li>
                <li><a href="#">/home</a></li>
                <li><a href="#">/</a></li>
            </ul>
        </div>
        <div class="col-md-10">

        </div>
    </div>
</div>
<script src="<%=request.getContextPath()%>/static/jQuery/jquery-2.1.1.js"></script>
<script src="<%=request.getContextPath()%>/static/jQuery/jquery-2.1.1.min.js"></script>
<script src="<%=request.getContextPath()%>/static/js/bootstrap.min.js"></script>
</body>
</html>
