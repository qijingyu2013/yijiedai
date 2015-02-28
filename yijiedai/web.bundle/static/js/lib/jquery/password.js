// PhoneGap加载完毕
$(document).ready(function(){
    document.addEventListener("deviceready", myDeviceReadyListener, false);
//    document.addEventListener("jpush.setTagsWithAlias", onTagsWithAlias, false);
});

function myDeviceReadyListener(){
    //	请求一个文件系统
    window.requestFileSystem(LocalFileSystem.PERSISTENT,2*1024*1024,successCallback,errorCallback);
}
var root_entry="";
var keyData = "";
var ss = window.sessionStorage;
var SudokuTmpKey = ss.getItem("SudokuTmpKey");
var SudokuTmpTimes = ss.getItem("SudokuTmpTimes");
var keyChange = ss.getItem("SudokuTmpKeyChange");

if(SudokuTmpTimes == null)
{
    SudokuTmpTimes = 0;
}

if(SudokuTmpTimes<5)
{
    $(".squared-tips > i").html(5-SudokuTmpTimes);
}
else
{
    location.href = "index.html#login";
}
//成功的回到函数
function successCallback(filesystem)
{
    root_entry=filesystem.root;
    root_entry.getDirectory("files", {create: true, exclusive: false}, function(entry){
        entry.getFile("yijiedai.kf", {create: true, exclusive: false}, function(entry){
            //document.write(entry.name+"目录路径"+entry.fullPath);
            entry.file(function(file){//成功
                var reader = new FileReader();
                reader.onloadstart = function (evt) {
//                    $.ui.showMask("读取中。。。");
                };
                reader.onloadend = function (evt) {
                    keyData = evt.target.result;
                       if(keyData == null)
                       {
                            ss.setItem("SudokuTmpTimes",0);
                            location.href = "index.html#login";
                       }
                       try
                       {
                            keyData = base64decode(keyData);
                            keyData = JSON.parse(keyData);
                       }
                       catch(e)
                       {
                            ss.setItem("SudokuTmpTimes",0);
                            location.href = "index.html#login";
                       }
                    $(".password-title > span").html(keyData.userName);
                    
                    //initiateUI(keyData.userId);
                    //判断key文件
                    if(keyData.userToken.length!=0&&keyData.userName.length!=0)
                    {
                        $(".password-title > span").html(keyData.userName);
                        //判断手势
                        if(keyData.sudokuNumber.length!=0)
                        {
                            //判断session中是否存有手势密码
                            if(SudokuTmpKey == keyData.sudokuNumber && keyChange != "yes")
                            {//进入首页
                                location.href="index.html";
                            }
                            else
                            {//输入手势密码
                       
                                $(".squared-tips > span").html("请输入手势密码");
                                var lock = new PatternLock("#patternContainer",
                                {
                                    mapper:function(idx){
                                        return (idx%9) + 1;
                                    },
                                    onDraw:function(e){
                                        lock.checkForPattern(keyData.sudokuNumber,function(){
//                                                             ss.setItem("SudokuTmpKey",null);
//                                                             ss.setItem("SudokuTmpTimes",0);
//                                                             ss.setItem("keyChange","no");
//                                                             ss.setItem("SudokuTmpKeyRight","no");
                                            
                                            if(keyChange == "yes")
                                            {//修改手势密码
                                                ss.setItem("SudokuTmpKeyChange","no");
                                                ss.removeItem("SudokuTmpKey");
                                                 //写入文件
                                                 entry.createWriter(function(writer){
                                                    //writer.seek(writer.length);  //指针移动到指定的位置
                                                    keyData.sudokuNumber = "";
                                                    var wData = JSON.stringify(keyData);
                                                    
                                                    var wData = base64encode(wData);
                                                    //写入文件
                                                    writer.write(wData);
                                                    
                                                    writer.onwriteend = function(evt) {
                                                        location.href = "password.html";
                                                    };
                                                    
                                                },function(err){
                                                    console.log("创建失败"+err.code);
                                                });
                                            }
                                            else
                                            {
                                                ss.setItem("SudokuTmpKey",e);
                                                ss.setItem("SudokuTmpTimes",0);
                                                             
                                                location.href = "index.html";
                                             }
                                        },
                                        function(){
                                            if(SudokuTmpTimes>4)
                                            {
                                                location.href = "index.html#login";
                                            }
                                            $(".squared-tips > span").html("输入错误，请再输入一次手势密码！");
                                            SudokuTmpTimes++;
                                            ss.setItem("SudokuTmpTimes",SudokuTmpTimes+1);
                                            $(".squared-tips > i").html(5-SudokuTmpTimes);
                                            lock.initPattern();
                                        });
                                    }
                                });
                            }
                        }
                        else
                        {
                            //判断手势密码是否为空
                            if(SudokuTmpKey==null)
                            {
                                //创建手势密码
                                $(".squared-tips > span").html("您还没有设置过手势密码，请输入手势密码！");

                                var lock = new PatternLock("#patternContainer",
                                {
                                    mapper:function(idx){
                                        return (idx%9) + 1;
                                    },
                                    onDraw:function(e){

                                        if(e<9999)
                                        {
                                            $(".squared-tips > span").html("请至少连接5个点，请输入手势密码！");
                                            lock.initPattern();
                                        }
                                        else
                                        {
                                            ss.setItem("SudokuTmpKey",e);
                                            ss.setItem("SudokuTmpTimes",0);
                                            location.href = "password.html";
                                        }
                                    }
                                });
                            }
                            else
                            {
                                $(".squared-tips > span").html("为了您的账户安全，请再输入一遍手势密码！");
                                var lock = new PatternLock("#patternContainer",
                                {
                                    mapper:function(idx){
                                        return (idx%9) + 1;
                                    },
                                    onDraw:function(e){
                                        lock.checkForPattern(SudokuTmpKey,function(){

                                            //写入文件
                                            entry.createWriter(function(writer){
                                                //writer.seek(writer.length);  //指针移动到指定的位置
                                                keyData.sudokuNumber = SudokuTmpKey;
                                                var wData = JSON.stringify(keyData);

                                                var wData = base64encode(wData);
                                                //写入文件
                                                writer.write(wData);

                                                writer.onwriteend = function(evt) {
                                                    location.href = "index.html";
                                                };

                                            },function(err){
                                                console.log("创建失败"+err.code);
                                            });
                                        },
                                        function(){
                                            $(".squared-tips > span").html("输入错误，请再输入一次手势密码！");
                                            ss.setItem("SudokuTmpTimes",SudokuTmpTimes+1);
                                            $(".squared-tips > i").html(5-SudokuTmpTimes);
                                            lock.initPattern();
                                        });
                                    }
                               });
                            }
                        }
                    }
                    else
                    {//重新登入
                        location.href="login.html";
                    }
                };
                reader.readAsText(file);
            }, function(err){//失败
                    console.log("失败");
            });
        },function(err){
            console.log("创建文件失败"+err.code);
        });
    },function(err){
        console.log("创建文件失败"+err.code);
    });
}
//失败的回调函数
function errorCallback(err){
	console.log("请求文件系统失败"+err.code);
}

//jpush start
//var onTagsWithAlias = function(event){
//    try{
//        console.log("onTagsWithAlias");
//        var result="result code:"+event.resultCode+" ";
//        result+="tags:"+event.tags+" ";
//        result+="alias:"+event.alias+" ";
//        $("#tagAliasResult").html(result);
//    }
//    catch(exception){
//        console.log(exception)
//    }
//}
var initiateUI = function(iData){
    //window.plugins.jPushPlugin.getRegistrationID(onGetRegistradionID);
    //test android interface
    //window.plugins.jPushPlugin.stopPush()
//    window.plugins.jPushPlugin.resumePush();
    window.plugins.jPushPlugin.clearAllNoticication();
    window.plugins.jPushPlugin.setLatestNotificationNum(0);
    //window.plugins.jPushPlugin.stopPush();
    //window.plugins.jPushPlugin.isPushStopped(onIsPushStopped);
    window.plugins.jPushPlugin.init();
    //window.plugins.jPushPlugin.setDebugMode(true);
    //window.plugins.jPushPlugin.startLogPageView("mianPage");
    try
    {
        var tag1 = "yijiedaiTag"+iData;
        var tag2 = "";
        var tag3 = "";
        var alias = "yijiedaiAlias"+iData;
        var dd = [];
        if(tag1==""&&tag2==""&&tag3=="")
        {

        }
        else
        {
            if(tag1 != ""){
                dd.push(tag1);
            }
            if(tag2 != ""){
                dd.push(tag2);
            }
            if(tag3 != ""){
                dd.push(tag3);
            }
        }
        window.plugins.jPushPlugin.setTagsWithAlias(dd,alias);
        //alert(iData);
    }
    catch(exception){
        console.log(exception);
    }
}
//jpush end

