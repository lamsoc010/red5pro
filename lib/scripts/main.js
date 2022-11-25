let streamName = "";

function setStreamName(newStreamName) {
	console.log("newStreamName in main.js" + newStreamName);
	streamName = newStreamName;
	console.log("streamname in main.js" + streamName);
}

function getStramName() {
	return streamName;
}

console.log("Get Stream name"  + getStramName());