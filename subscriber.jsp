<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8" %>
	<%@ page import="java.net.Inet4Address,java.net.URLConnection" %>
		<%@ page import="com.red5pro.server.secondscreen.net.NetworkUtil" %>

			<%@ page
				import="java.io.*,java.util.Map,java.util.ArrayList,java.util.regex.*,java.net.URL,java.nio.charset.Charset"
				%>
				<%@ page import="org.springframework.context.ApplicationContext,
          org.springframework.web.context.WebApplicationContext,
          com.red5pro.example.ExampleApplication,
          java.util.List, java.util.ArrayList" %>
					<% ApplicationContext appCtx=(ApplicationContext)
						application.getAttribute(WebApplicationContext.ROOT_WEB_APPLICATION_CONTEXT_ATTRIBUTE);
						ExampleApplication service=(ExampleApplication)appCtx.getBean("web.handler"); List<String>
						streamNames = service.getLiveStreams();
						String localIp = NetworkUtil.getLocalIpAddress();
						StringBuffer buffer = new StringBuffer();

						if(streamNames.size() == 0) {
						buffer.append("No streams found. Refresh if needed.");
						}
						else {
						buffer.append("<ul>\n");

							for (String streamName : streamNames) {
							String url = "http://"+localIp+":5080/example/subcriber-view.jsp?stream=" + streamName;
							buffer.append("<li><a href="+ url +"> Streamname: "+streamName+ " On Ip: " + localIp + "</a></li>");
							}
							buffer.append("</ul>\n");
						}
						%>

						<!doctype html>
						<html>

						<head>
							<meta charset="UTF-8">
							<!-- *Recommended WebRTC Shim -->
							<script src="https://webrtchacks.github.io/adapter/adapter-latest.js"></script>
						</head>

						<body>
							<h1>Danh sách streamer</h1>
							<h1 id="name">List stream: <%=buffer.toString()%>
							</h1>

							<!-- Red5 Pro SDK -->
							<script src="https://cdn.jsdelivr.net/npm/red5pro-webrtc-sdk"></script>
							<!-- Create Pub/Sub -->
							<script src="./lib/scripts/main.js"></script>
							<script type="text/javascript">
								let host = window.location.host.split(":")[0] || 'localhost';
								const url = `http://localhost:5080/example/subscriber-view.jsp?stream=123`

								function viewStream(streamName) {
									console.log(streamName);
									window.location = url;
								}
							</script>
						</body>

						</html>