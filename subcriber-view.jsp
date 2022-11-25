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
                            buffer.append("<li><a href="+ url +"> Streamname: "+streamName+ "</a></li>");
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
                            <!-- <h1>Danh sách streamer</h1> -->
                            <h1 id="name">List stream: <%=buffer.toString()%>
                            </h1>
                            <div>
                                <input type="text" id="streamName">
                                <button onclick="start()">Start</button>
                                <button onclick="stop()">Stop</button>
                            </div>
                            <div>
                                <video id="red5pro-subscriber" width="640" height="480" controls autoplay></video>
                            </div>
                            <!-- Red5 Pro SDK -->
                            <script src="https://cdn.jsdelivr.net/npm/red5pro-webrtc-sdk"></script>
                            <!-- Create Pub/Sub -->
                            <script src="./lib/scripts/main.js"></script>
                            <script type="text/javascript">
                                var host = window.location.host.split(":")[0];
                                console.log(host);
                                const config = {
                                    protocol: 'ws',
                                    port: 5080,
                                    host: host,
                                    app: 'example',
                                    streamName: streamName,
                                    rtcConfiguration: {
                                        iceServers: [{ urls: 'stun:stun2.l.google.com:19302' }],
                                        iceCandidatePoolSize: 2,
                                        bundlePolicy: 'max-bundle'
                                    }, // See https://developer.mozilla.org/en-US/docs/Web/API/RTCPeerConnection/RTCPeerConnection#RTCConfiguration_dictionary
                                    mediaElementId: 'red5pro-subscriber',
                                    subscriptionId: streamName,
                                }

                                let url_string = window.location.href;
                                let url = new URL(url_string);
                                let streamNameURL = url.searchParams.get("stream");
                                console.log(streamNameURL);
                                const subscriber = new window.red5prosdk.RTCSubscriber();
                                const start = async () => {
                                    try {
                                        let streamName = streamNameURL;
                                        await subscriber.init({
                                            ...config,
                                            streamName: streamNameURL
                                        })
                                        await subscriber.subscribe()
                                        console.log(111)
                                    } catch (e) {
                                        // An error occured in establishing a subscriber session.
                                        console.log(e)
                                    }
                                }
                                start();
                            </script>
                        </body>

                        </html>