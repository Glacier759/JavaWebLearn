<%--
  Created by IntelliJ IDEA.
  User: glacier
  Date: 14-10-20
  Time: 上午9:23
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
                <li class="active"><a href="<%=request.getContextPath()%>/cpu/cpu.jsp">CPU占用率</a></li>
                <li><a href="#">内存占用率</a></li>
                <li><a href="#">交换空间</a></li>
                <li class="nav-divider"></li>
                <li class="nav-header"><h4>网络</h4></li>
                <li><a href="<%=request.getContextPath()%>/network/status.jsp">网络状态</a></li>
                <li><a href="#">上传</a></li>
                <li class="nav-divider"></li>
                <li class="nav-header"><h4>磁盘</h4></a></li>
                <li><a href="#">/home</a></li>
                <li><a href="#">/</a></li>
            </ul>
        </div>
        <div class="col-md-10 col-md-push-2">
            <div id="cpu-div-1"></div>
        </div>
        <div id="cpu-div-2"></div>
        <div id="cpu-div-2"></div>

    </div>
</div>
<script src="<%=request.getContextPath()%>/static/jQuery/jquery-2.1.1.min.js"></script>
<script src="<%=request.getContextPath()%>/static/js/bootstrap.min.js"></script>
<script src="<%=request.getContextPath()%>/static/js/d3.min.js"></script>
<script>
function drawPie(div, printstr){
    var w = 450;
    var h = 300;
    var r = 100;
    var ir = 45;
    var textOffset = 14;
    var tweenDuration = 250;

    //OBJECTS TO BE POPULATED WITH DATA LATER
    var lines, valueLabels, nameLabels;
    var pieData = [];
    var oldPieData = [];
    var filteredPieData = [];

    //D3 helper function to populate pie slice parameters from array data
    var donut = d3.layout.pie().value(function(d){
        return d.octetTotalCount;
    });

    //D3 helper function to create colors from an ordinal scale
    var color = d3.scale.category20();

    //D3 helper function to draw arcs, populates parameter "d" in path object
    var arc = d3.svg.arc()
            .startAngle(function(d){ return d.startAngle; })
            .endAngle(function(d){ return d.endAngle; })
            .innerRadius(ir)
            .outerRadius(r);

    ///////////////////////////////////////////////////////////
    // GENERATE FAKE DATA /////////////////////////////////////
    ///////////////////////////////////////////////////////////

    var arrayRange = 100000; //range of potential values for each item
    var arraySize;
    var streakerDataAdded;

    function fillArray() {
        return {
            port: "port",
            octetTotalCount: 2
        };
    }

    ///////////////////////////////////////////////////////////
    // CREATE VIS & GROUPS ////////////////////////////////////
    ///////////////////////////////////////////////////////////

    var vis = d3.select(div).append("svg:svg")
            .attr("width", w)
            .attr("height", h);

    //GROUP FOR ARCS/PATHS
    var arc_group = vis.append("svg:g")
            .attr("class", "arc")
            .attr("transform", "translate(" + (w/2) + "," + (h/2) + ")");

    //GROUP FOR LABELS
    var label_group = vis.append("svg:g")
            .attr("class", "label_group")
            .attr("transform", "translate(" + (w/2) + "," + (h/2) + ")");

    //GROUP FOR CENTER TEXT
    var center_group = vis.append("svg:g")
            .attr("class", "center_group")
            .attr("transform", "translate(" + (w/2) + "," + (h/2) + ")");

    //PLACEHOLDER GRAY CIRCLE
    var paths = arc_group.append("svg:circle")
            .attr("fill", "#EFEFEF")
            .attr("r", r);

    ///////////////////////////////////////////////////////////
    // CENTER TEXT ////////////////////////////////////////////
    ///////////////////////////////////////////////////////////

    //WHITE CIRCLE BEHIND LABELS
    var whiteCircle = center_group.append("svg:circle")
            .attr("fill", "#efefef")
            .attr("r", ir);

    // "TOTAL" LABEL
    var totalLabel = center_group.append("svg:text")
            .attr("class", "label")
            .attr("dy", -15)
            .attr("text-anchor", "middle") // text-align: right
            .text(printstr);

    //TOTAL TRAFFIC VALUE
    var totalValue = center_group.append("svg:text")
            .attr("class", "total")
            .attr("dy", 7)
            .attr("text-anchor", "middle") // text-align: right
            .text("Waiting...");

    //UNITS LABEL
    var totalUnits = center_group.append("svg:text")
            .attr("class", "units")
            .attr("dy", 21)
            .attr("text-anchor", "middle") // text-align: right
            .text("%");

    var updateInterval = window.setInterval(update, 1000);

    // to run each time data is generated
    function update() {
        arraySize = 2;
        streakerDataAdded = d3.range(arraySize).map(fillArray);
        streakerDataAdded[0].octetTotalCount = 3;
        $.ajax({
            //url: "http://127.0.0.1:8000/get_cpu",
            //url: ajaxurl,
            url: "<%=request.getContextPath()%>/cpu.do",
            type: "GET",
            dataType: "JSON",
            success: function(data) {
                var value = 3.14;
                if ( printstr == 'user' )
                    value = data.user;
                else if ( printstr == 'system' )
                    value = data.system;
                else if ( printstr == 'all' )
                    value = data.all_use;
                streakerDataAdded[0].octetTotalCount = value * 100;
                streakerDataAdded[1].octetTotalCount = (1 - value) * 100;
                //			alert("in value = " + value);
                //alert("out value = " + value);
                streakerDataAdded[0].port = "busy";
                streakerDataAdded[1].port = "free";

                oldPieData = filteredPieData;
                pieData = donut(streakerDataAdded);

                var freeCount = streakerDataAdded[0].octetTotalCount;
                var busyCount = streakerDataAdded[1].octetTotalCount;

                var totalOctets = 0;
                filteredPieData = pieData.filter(filterData);
                function filterData(element, index, array) {
                    element.name = streakerDataAdded[index].port;
                    element.value = streakerDataAdded[index].octetTotalCount;
                    totalOctets += element.value;
                    return (element.value > 0);
                }
                if(filteredPieData.length > 0 && oldPieData.length > 0){

                    //REMOVE PLACEHOLDER CIRCLE
                    arc_group.selectAll("circle").remove();

                    totalValue.text(function(){
                        var kb = (freeCount/totalOctets)*100;
                        return kb.toFixed(1);
                        //return bchart.label.abbreviated(totalOctets*8);
                    });

                    //DRAW ARC PATHS
                    paths = arc_group.selectAll("path").data(filteredPieData);
                    paths.enter().append("svg:path")
                            .attr("stroke", "white")
                            .attr("stroke-width", 0.5)
                            .attr("fill", function(d, i) {  return color(i); })
                            .transition()
                            .duration(tweenDuration)
                            .attrTween("d", pieTween);
                    paths
                            .transition()
                            .duration(tweenDuration)
                            .attrTween("d", pieTween);
                    paths.exit()
                            .transition()
                            .duration(tweenDuration)
                            .attrTween("d", removePieTween)
                            .remove();

                    //DRAW TICK MARK LINES FOR LABELS
                    lines = label_group.selectAll("line").data(filteredPieData);
                    lines.enter().append("svg:line")
                            .attr("x1", 0)
                            .attr("x2", 0)
                            .attr("y1", -r-3)
                            .attr("y2", -r-8)
                            .attr("stroke", "gray")
                            .attr("transform", function(d) {
                                return "rotate(" + (d.startAngle+d.endAngle)/2 * (180/Math.PI) + ")";
                            });
                    lines.transition()
                            .duration(tweenDuration)
                            .attr("transform", function(d) {
                                return "rotate(" + (d.startAngle+d.endAngle)/2 * (180/Math.PI) + ")";
                            });
                    lines.exit().remove();

                    //DRAW LABELS WITH PERCENTAGE VALUES
                    valueLabels = label_group.selectAll("text.value").data(filteredPieData)
                            .attr("dy", function(d){
                                if ((d.startAngle+d.endAngle)/2 > Math.PI/2 && (d.startAngle+d.endAngle)/2 < Math.PI*1.5 ) {
                                    return 5;
                                } else {
                                    return -7;
                                }
                            })
                            .attr("text-anchor", function(d){
                                if ( (d.startAngle+d.endAngle)/2 < Math.PI ){
                                    return "beginning";
                                } else {
                                    return "end";
                                }
                            })
                            .text(function(d){
                                var percentage = (d.value/totalOctets)*100;
                                return percentage.toFixed(1) + "%";
                            });

                    valueLabels.enter().append("svg:text")
                            .attr("class", "value")
                            .attr("transform", function(d) {
                                return "translate(" + Math.cos(((d.startAngle+d.endAngle - Math.PI)/2)) * (r+textOffset) + "," + Math.sin((d.startAngle+d.endAngle - Math.PI)/2) * (r+textOffset) + ")";
                            })
                            .attr("dy", function(d){
                                if ((d.startAngle+d.endAngle)/2 > Math.PI/2 && (d.startAngle+d.endAngle)/2 < Math.PI*1.5 ) {
                                    return 5;
                                } else {
                                    return -7;
                                }
                            })
                            .attr("text-anchor", function(d){
                                if ( (d.startAngle+d.endAngle)/2 < Math.PI ){
                                    return "beginning";
                                } else {
                                    return "end";
                                }
                            }).text(function(d){
                                var percentage = (d.value/totalOctets)*100;
                                return percentage.toFixed(1) + "%";
                            });

                    valueLabels.transition().duration(tweenDuration).attrTween("transform", textTween);

                    valueLabels.exit().remove();


                    //DRAW LABELS WITH ENTITY NAMES
                    nameLabels = label_group.selectAll("text.units").data(filteredPieData)
                            .attr("dy", function(d){
                                if ((d.startAngle+d.endAngle)/2 > Math.PI/2 && (d.startAngle+d.endAngle)/2 < Math.PI*1.5 ) {
                                    return 17;
                                } else {
                                    return 5;
                                }
                            })
                            .attr("text-anchor", function(d){
                                if ((d.startAngle+d.endAngle)/2 < Math.PI ) {
                                    return "beginning";
                                } else {
                                    return "end";
                                }
                            }).text(function(d){
                                return d.name;
                            });

                    nameLabels.enter().append("svg:text")
                            .attr("class", "units")
                            .attr("transform", function(d) {
                                return "translate(" + Math.cos(((d.startAngle+d.endAngle - Math.PI)/2)) * (r+textOffset) + "," + Math.sin((d.startAngle+d.endAngle - Math.PI)/2) * (r+textOffset) + ")";
                            })
                            .attr("dy", function(d){
                                if ((d.startAngle+d.endAngle)/2 > Math.PI/2 && (d.startAngle+d.endAngle)/2 < Math.PI*1.5 ) {
                                    return 17;
                                } else {
                                    return 5;
                                }
                            })
                            .attr("text-anchor", function(d){
                                if ((d.startAngle+d.endAngle)/2 < Math.PI ) {
                                    return "beginning";
                                } else {
                                    return "end";
                                }
                            }).text(function(d){
                                return d.name;
                            });

                    nameLabels.transition().duration(tweenDuration).attrTween("transform", textTween);

                    nameLabels.exit().remove();
                }
            }
        });
    }

    ///////////////////////////////////////////////////////////
    // FUNCTIONS //////////////////////////////////////////////
    ///////////////////////////////////////////////////////////

    // Interpolate the arcs in data space.
    function pieTween(d, i) {
        var s0;
        var e0;
        if(oldPieData[i]){
            s0 = oldPieData[i].startAngle;
            e0 = oldPieData[i].endAngle;
        } else if (!(oldPieData[i]) && oldPieData[i-1]) {
            s0 = oldPieData[i-1].endAngle;
            e0 = oldPieData[i-1].endAngle;
        } else if(!(oldPieData[i-1]) && oldPieData.length > 0){
            s0 = oldPieData[oldPieData.length-1].endAngle;
            e0 = oldPieData[oldPieData.length-1].endAngle;
        } else {
            s0 = 0;
            e0 = 0;
        }
        var i = d3.interpolate({startAngle: s0, endAngle: e0}, {startAngle: d.startAngle, endAngle: d.endAngle});
        return function(t) {
            var b = i(t);
            return arc(b);
        };
    }

    function removePieTween(d, i) {
        s0 = 2 * Math.PI;
        e0 = 2 * Math.PI;
        var i = d3.interpolate({startAngle: d.startAngle, endAngle: d.endAngle}, {startAngle: s0, endAngle: e0});
        return function(t) {
            var b = i(t);
            return arc(b);
        };
    }

    function textTween(d, i) {
        var a;
        if(oldPieData[i]){
            a = (oldPieData[i].startAngle + oldPieData[i].endAngle - Math.PI)/2;
        } else if (!(oldPieData[i]) && oldPieData[i-1]) {
            a = (oldPieData[i-1].startAngle + oldPieData[i-1].endAngle - Math.PI)/2;
        } else if(!(oldPieData[i-1]) && oldPieData.length > 0) {
            a = (oldPieData[oldPieData.length-1].startAngle + oldPieData[oldPieData.length-1].endAngle - Math.PI)/2;
        } else {
            a = 0;
        }
        var b = (d.startAngle + d.endAngle - Math.PI)/2;

        var fn = d3.interpolateNumber(a, b);
        return function(t) {
            var val = fn(t);
            return "translate(" + Math.cos(val) * (r+textOffset) + "," + Math.sin(val) * (r+textOffset) + ")";
        };
    }
}
</script>
<script type="text/javascript">window.onload = drawPie("#cpu-div-1", "user");</script>
<script type="text/javascript">window.onload = drawPie("#cpu-div-2", "system");</script>
<script type="text/javascript">window.onload = drawPie("#cpu-div-2", "all");</script>
</body>
</html>
