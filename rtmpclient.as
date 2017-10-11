import flash.text.TextField
import flash.events.MouseEvent
import fl.controls.Button
import flash.utils.Timer
import fl.motion.MotionEvent;

var MyVideo:Video = new Video();
MyVideo.height = this.stage.stageHeight
MyVideo.width = this.stage.stageWidth
addChild(MyVideo);


var log:TextField = new TextField()
log.type=TextFieldType.DYNAMIC
log.border = false
//log.text = ""
log.alpha = 0.7
log.borderColor = 0x32CD32
log.textColor = 0xEDEDED
log.y = 20
log.x = this.stage.stageHeight/2
log.height = 200
log.width = 100
addChild(log)



var MyUrl:TextField = new TextField()
MyUrl.type=TextFieldType.INPUT
MyUrl.border = true
MyUrl.text = "rtmp://:8888/live";
MyUrl.alpha = 0.8
MyUrl.borderColor = 0x32CD32
MyUrl.textColor = 0xEDEDED
MyUrl.y = this.stage.stageHeight - 30
MyUrl.x = 20
MyUrl.height = 20
MyUrl.width = 200
addChild(MyUrl)

var MyStream:TextField = new TextField()
MyStream.type=TextFieldType.INPUT
MyStream.border = true
MyStream.text = "livestream"
MyStream.alpha = 0.8
MyStream.borderColor = 0x32CD32
MyStream.textColor = 0xEDEDED
MyStream.y = this.stage.stageHeight - 30
MyStream.x = MyUrl.x + MyUrl.width + 5;
MyStream.height = 20
MyStream.width = 60
addChild(MyStream)

var MyBufferTime:TextField = new TextField()
MyBufferTime.type=TextFieldType.INPUT
MyBufferTime.border = true
MyBufferTime.text = "0"
MyBufferTime.alpha = 0.8
MyBufferTime.borderColor = 0x32CD32
MyBufferTime.textColor = 0xEDEDED
MyBufferTime.y = 20
MyBufferTime.x = 20
MyBufferTime.height = 20
MyBufferTime.width = 50
//MyBufferTime.addEventListener(FocusEvent.FOCUS_OUT, Out)
addChild(MyBufferTime)

function Out(event:FocusEvent){
	if(event.target == MyBufferTime){
		MyNS.bufferTime = 1000;
	}
}
///////
var MySeek:TextField = new TextField()
MySeek.type=TextFieldType.INPUT
MySeek.border = true
MySeek.text = "0"
MySeek.alpha = 0.8
MySeek.borderColor = 0x32CD32
MySeek.textColor = 0xEDEDED
MySeek.y = this.stage.stageHeight - 30
MySeek.x = MyStream.x + MyStream.width + 5;
MySeek.height = 20
MySeek.width = 60
addChild(MySeek)


var StartBtn = new Button()
StartBtn.label = "PLAY"
StartBtn.alpha = 0.5
StartBtn.width = 50
StartBtn.move(MySeek.x + MySeek.width + 10, MySeek.y - 1)
StartBtn.addEventListener(MouseEvent.CLICK, onMouseClick)
StartBtn.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver)
StartBtn.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut)
addChild(StartBtn)

var PauseBtn = new Button()
PauseBtn.label = "PAUSE"
PauseBtn.alpha = 0.5
PauseBtn.width = 50
PauseBtn.move(StartBtn.x + StartBtn.width + 10, StartBtn.y - 1)
PauseBtn.addEventListener(MouseEvent.CLICK, onPauseClick)
PauseBtn.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver)
PauseBtn.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut)
addChild(PauseBtn)

var SeekBtn = new Button()
SeekBtn.label = "SEEK"
SeekBtn.alpha = 0.5
SeekBtn.width = 50
SeekBtn.move(PauseBtn.x + PauseBtn.width + 10, PauseBtn.y - 1)
SeekBtn.addEventListener(MouseEvent.CLICK, onSeekClick)
SeekBtn.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver)
SeekBtn.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut)
addChild(SeekBtn)


var MyNC:NetConnection = new NetConnection()
MyNC.addEventListener(NetStatusEvent.NET_STATUS, asyncErrorHandler)
MyNC.client = this

var MyNS:NetStream
var MyStat:int = 0
function asyncErrorHandler(event:NetStatusEvent):void{ 
	if(event.info.code == "NetConnection.Connect.Success"){ 
		log.appendText("on Connect.Success\r\n")
		MyStat = 1;
		MyNS = new NetStream(MyNC)
		MyNS.bufferTime = parseInt(MyBufferTime.text)
		MyNS.client = {}
		MyVideo.attachNetStream(MyNS)
		MyNS.play(MyStream.text)
		
		ticker.start();
		log.appendText("start play\r\n")
	}
	
} 

function onMetaData(obj:Object):void{log.appendText("on metaData\r\n")}
function onBWDone(...para):void{log.appendText("on BWDone\r\n")}
function onXMPData(...para):void{}


function onMouseClick(event:MouseEvent){
	if(StartBtn.label == "PLAY"){
		log.text = ""
		log.appendText("on start\r\n")
		MyNC.connect(MyUrl.text)
		StartBtn.label = "STOP"
	}
	else if(StartBtn.label == "STOP"){
		log.appendText("on stop\r\n")
		if(MyStat == 1){
			MyNS.close()
			MyStat = 0
		}
		MyVideo.clear()
		StartBtn.label = "PLAY"
		
		ticker.stop();
	}
}

function onPauseClick(event:MouseEvent) {
	if(PauseBtn.label == "PAUSE"){
		log.text = ""
		log.appendText("on pause\r\n")
		if(MyStat == 1){
			MyNS.pause()
		}
		PauseBtn.label = "RESUME"
	}
	else if(PauseBtn.label == "RESUME") {
		log.appendText("on resume\r\n")
		if(MyStat == 1){
			MyNS.resume()
		}
		PauseBtn.label = "PAUSE"
	}
}

function onSeekClick(event:MouseEvent) {
	if(MyStat == 1) {
		MyNS.seek(Number(MySeek.text))
		log.text = ""
		log.appendText("seek value:" + MySeek.text + "\r\n")
	}
}


function onMouseOver(event:MouseEvent){
	event.target.alpha = 0.8
}
function onMouseOut(event:MouseEvent){
	event.target.alpha = 0.5
}
 


var MyInfo:TextField = new TextField()
MyInfo.border = true
MyInfo.multiline = true;
MyInfo.text = "FPS:\n\nBUF:\n\nBUFTIME:";
MyInfo.alpha = 1
MyInfo.borderColor = 0xEE4000
MyInfo.textColor = 0xEE4000
MyInfo.y = 20
MyInfo.x = this.stage.stageWidth - 150
MyInfo.height = 80
MyInfo.width = 100
addChild(MyInfo)

var ticker:Timer = new Timer(1000);
ticker.addEventListener(TimerEvent.TIMER, timeOut);


function timeOut(event:TimerEvent):void {
	if(StartBtn.label == "STOP"){
		var str:String = "FPS:  "
		str += MyNS.currentFPS.toString()
		str += "\n\nBUF:  "
		str += MyNS.bufferLength.toString()
		str += "S\n\nBUFFTIME:  "
		str += MyNS.bufferTime.toString()
		str += "S"
		MyInfo.text = str
	}
}


