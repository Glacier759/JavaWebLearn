<%--
  Created by IntelliJ IDEA.
  User: glacier
  Date: 14-10-20
  Time: 上午8:55
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
                <li class="nav-header"><h4>网络</h4></a></li>
                <li class="active"><a href="<%=request.getContextPath()%>/network/status.jsp">网络状态</a></li>
                <li><a href="#">上传</a></li>
                <li class="nav-divider"></li>
                <li class="nav-header"><h4>磁盘</h4></a></li>
                <li><a href="#">/home</a></li>
                <li><a href="#">/</a></li>
            </ul>
        </div>
        <div class="col-md-10">
            <div id="netport-div">
                <table class="table table-striped table-bordered table-hover" id="netport-table">
                    <thead>
                    <tr>
                        <th class="text-center">Type</th>
                        <th class="text-center">Address</th>
                        <th class="text-center">Pid/Program_Name</th>
                    </tr>
                    </thead>
                    <tbody id="netport-tbody"></tbody>
                </table>
            </div>
        </div>
    </div>
</div>
<script src="<%=request.getContextPath()%>/static/jQuery/jquery-2.1.1.min.js"></script>
<script src="<%=request.getContextPath()%>/static/js/bootstrap.min.js"></script>
<script>
    createTable();
    function createTable() {
        $.ajax({
            //url: "http://127.0.0.1:8000/get_port/",
            url: "<%=request.getContextPath()%>/network/network.json",
            type: "GET",
            dataType: "json",
            success: function(data) {
                var objson = eval(data);
                for ( var i = 0; i < objson.length; i ++ ) {
                    var row = document.createElement("tr");
                    row.setAttribute("class", "text-info");
                    var col1 = document.createElement("th");
                    col1.setAttribute("class", "text-center");
                    col1.appendChild(document.createTextNode(objson[i].type));
                    row.appendChild(col1);
                    var col2 = document.createElement("th");
                    col2.setAttribute("class", "text-center");
                    col2.appendChild(document.createTextNode(objson[i].address));
                    row.appendChild(col2);
                    var col3 = document.createElement("th");
                    col3.setAttribute("class", "text-center");
                    col3.appendChild(document.createTextNode(objson[i].pid_program_name));
                    row.appendChild(col3);
                    document.getElementById("netport-tbody").appendChild(row);
                }
            }
        });
    }
</script>
</body>
</html>
