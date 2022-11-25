<%@page import="org.apache.jasper.tagplugins.jstl.core.ForEach" %>
  <%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8" %>
    <%@ page import="java.net.Inet4Address,java.net.URLConnection" %>

      <%@ page
        import="java.io.*,java.util.Map,java.util.ArrayList,java.util.regex.*,java.net.URL,java.nio.charset.Charset" %>
        <%@ page import="org.springframework.context.ApplicationContext,
          org.springframework.web.context.WebApplicationContext,
          com.red5pro.example.ExampleApplication,
          java.util.List, java.util.ArrayList" %>
          <% ApplicationContext appCtx=(ApplicationContext)
            application.getAttribute(WebApplicationContext.ROOT_WEB_APPLICATION_CONTEXT_ATTRIBUTE); ExampleApplication
            service=(ExampleApplication)appCtx.getBean("web.handler"); List<String> names = service.getLiveStreams();

            // is_stream_manager determined in jsp_header.


            %>
            <!doctype html>
            <html>

            <head>
              <!-- *Recommended WebRTC Shim -->
              <script src="https://webrtchacks.github.io/adapter/adapter-latest.js"></script>
            </head>

            <body>
              <!-- video containers -->
              <%-- <h1>List stream: ${names.size()}</h1> --%>
                <!-- publisher -->
                <div style="display: flex">
                  <video id="red5pro-publisher" width="640" height="480" muted autoplay controls></video>
                  <div>
                    <input type="text" id="streamName">
                    <button onclick="start()">Start</button>
                    <button onclick="stop()">Stop</button>
                    <h4 style="color: blue;margin-top: 20px;">Event log:</h4>
                    <button onclick="clearLog()">Clear</button>

                    <div id="event-log" style="color: blue;margin-top: 20px;">

                      <!-- div clear log -->
                    </div>

                  </div>
                </div>
                <!-- Red5 Pro SDK -->
                <!--     <script src="https://cdn.jsdelivr.net/npm/red5pro-webrtc-sdk"></script> -->
                <script src="https://cdn.jsdelivr.net/npm/red5pro-webrtc-sdk"></script>
                <!-- Create Pub/Sub -->
                <script src="./lib/scripts/main.js"></script>
                <script type="text/javascript">

                  const video = document.getElementById("red5pro-publisher");

                  async function getMedia() {
                    navigator.getUserMedia = navigator.getUserMedia || navigator.mozgetUserMedia

                    try {
                      if (typeof navigator.getUserMedia) {
                        console.log(111111);
                        console.log("video", video);
                        const stream = await navigator.mediaDevices.getUserMedia({ video: true });
                        console.log('stream', stream);
                        video.srcObject = stream;
                        stream.getTracks().forEach(track => peerConnection.addTrack(track, stream));
                        
                      } else {
                        alert('vui longf baatj camera')
                      }
                      // console.log(stream);
                      /* use the stream */
                    } catch (err) {
                      /* handle the error */
                    }
                  }

                  var canvas = document.createElement('canvas');
                  var rtcPublisher = new window.red5prosdk.RTCPublisher();
                  var host = window.location.host.split(":")[0];
                  var config = {
                    protocol: 'ws',
                    host: host,
                    port: 5080,
                    app: 'example',
                    streamName: streamName,
                    rtcConfiguration: {
                      iceServers: [{ urls: 'stun:stun2.l.google.com:19302' }],
                      iceCandidatePoolSize: 2,
                      bundlePolicy: 'max-bundle'
                    } // See https://developer.mozilla.org/en-US/docs/Web/API/RTCPeerConnection/RTCPeerConnection#RTCConfiguration_dictionary
                  };
                  console.log(host);
                  function start() {
                    let streamName = document.getElementById("streamName").value;
                    'use strict';


                    rtcPublisher.init({
                      ...config,
                      streamName: streamName,
                    })
                      .then(function () {
                        rtcPublisher.publish();
                        rtcPublisher.on('*', onPublisherEvent);
                      })
                      .then(function () {
                        console.log('Publishing!');
                      })
                      .catch(function (err) {
                        console.error('Could not publish: ' + err);
                      });
                  }
                  function stop() {
                    rtcPublisher.unpublish()
                      .then(() => {
                        console.log('Stopped publisher stream!')
                        rtcPublisher.off('*', onPublisherEvent);
                      })
                      .catch(() => console.log('Failed to stop publisher stream!'));
                  }

                  //render event log
                  function onPublisherEvent(event) {
                    var eventLog = '[Red5ProPublisher] ' + event.type + '.';
                    document.getElementById("event-log").innerHTML += "<p> " + eventLog + " </p> ";

                  }

                  function clearLog() {
                    console.log("123");
                    document.getElementById("event-log").innerHTML = "";
                  }

                </script>
            </body>

            </html>