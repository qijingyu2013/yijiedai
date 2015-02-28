if(typeof FileBase !== 'object')
{
    FileBase = {};
}
(function(){
    'use strict';
 
    var demo;
    var root_entry,
        app_entry,
        key_entry,
        result,
        data,
        state;
 
    /* init start */
    //取得文件系统
    function init()
    {
        document.addEventListener("deviceready", myDeviceReadyListener, false);
 
    }
 
 function myDeviceReadyListener(){
 //	请求一个文件系统
 window.requestFileSystem(LocalFileSystem.PERSISTENT, 1024*1024, successCallFileSystem, errorCallFileSystem);
 }
 
    function successCallFileSystem(fileSystem)
    {
        root_entry = fileSystem.root;
        //android
        if(navigator.userAgent.match(/Android/i))
        {
            root_entry.getDirectory("Android/data/com.yijiedai.YijiedaiMobileWeb/files",{create: true, exclusive: false}, successCallDirectory, failedCallDirectory);
        }
        //ios
        if(navigator.userAgent.match(/iPhone|iPad|iPod/i))
        {
            root_entry.getDirectory("files", {create: true, exclusive: false}, successCallDirectory, failedCallDirectory);
        }
        //其他
    }

    //失败
    function errorCallFileSystem()
    {
        console.log("无法取得文件信息");
    }

    //目录文件取得成功
    function successCallDirectory(entry)
    {
        app_entry = entry;
        app_entry.getFile("yijiedai.kf",{create:true, exclusive:false}, successCallFile, failedCallFile);
    }

    //目录文件取得失败
    function failedCallDirectory()
    {
        console.log("无法取得文件信息");
    }

    //key文件读取成功
    function successCallFile(entry)
    {
        key_entry = entry;
    //检查key文件是否有值
    //_checkkeyFile_entry(entry);
    }

    //key文件读取失败
    function failedCallFile()
    {
        console.log("failedCallFile 失败");
    }
/* init end */

/* read start */
    FileBase.read = function()
    {
        result='';
        state = 0;
        init();
        runFile("read");

        return result;
    }
 
 
 
 
 
    function runFile(cmd)
    {
        if(cmd=="read")
        {
            key_entry.file(successReadFile, failedReadFile);
            return;
        }
        else if(cmd=="write")
        {
            key_entry.file(successReadWriteFile, failedReadFile);
            return;
        }
        else if(cmd == "init")
        {
            key_entry.file(successInitWriteFile, failedReadFile);
            return;
        }
 
    }
 
    function checkReader()
    {
        if(state == 2)
        {
            return;
        }
        else
        {
            window.setTimeout(function () {
                                checkReader();
                              }, 100);
        }
    }
 
    //key文件读取成功
    function successReadFile(file)
    {
// alert("successReadFile");
        var reader = new FileReader();
// reader.onload = function(evt)
// {
//    if(reader.state == 2)
//    {
// alert(evt.target.result);
//    }
// }
// reader.onprogress = function(p)
// {
// console.log(p.loaded);
// }
        reader.onloadend = function(evt)
        {
// alert(evt.target.result);
            result = evt.target.result;
//            state = reader.readyState;
//
// onDeviceReady();
 return result;
        };
 
        reader.readAsText(file);
//        checkReader();
//        return result;
    }
    function getReadResult()
    {
        return result;
    }
    //key文件读取失败
    function failedReadFile()
    {
        console.log("failedReadFile 失败");
    }
 
/* read end */

 /* write start */
 
    FileBase.write = function($paramData)
    {
        result='';
        state = 0;
        data = paramData;
        init();
        runFile("write");
        return result;
    }
 
    //key文件读取成功
    function successReadWriteFile(file)
    {
        reader = new FileReader();

        reader.onloadend = function(evt)
        {
            result = evt.target.result;

            key_entry.createWriter(successCallWriter, failedCallWriter);
        };
        reader.readAsText(file);
        checkReader();
    }
        //key文件读取失败
    function failedReadFile()
    {
        console.log("failedReadFile 失败");
    }

    function successCallWriter(writer)
    {
        //var a={"username":"tom1","token":"6546s5ad4f6a5sd4f6a5sd","nine":"123123123"};
        result = base64decode(result);
        result = JSON.parse(result);
        if(data.userId!=null)
        {
            result.userId = data.userId;
        }
 
        if(data.loginDate!=null)
        {
            result.loginDate = data.loginDate;
        }
 
        if(data.userToken!=null)
        {
            result.userToken = data.userToken;
        }

        if(data.sudokuNumber!=null)
        {
            result.sudokuNumber = data.sudokuNumber;
        }
 
        a = JSON.stringify(result);

        var sA = base64encode(a);
        writer.onwrite = function(evt)
        {
            location.href="index.html";
        }
        writer.write(sA);
    }

    function failedCallWriter()
    {
        console.log("failedCallWriter 失败");
    }
 
/* write end */
 
 
 
 
 /* write start */

    FileBase.write = function($paramData)
    {
        result='';
        state = 0;
        data = paramData;
        init();
        runFile("init");
        return result;
    }

    //key文件读取成功
    function successReadWriteFile(file)
    {
    reader = new FileReader();

    reader.onloadend = function(evt)
    {
    result = evt.target.result;

    key_entry.createWriter(successCallWriter, failedCallWriter);
    };
    reader.readAsText(file);
    checkReader();
    }
    //key文件读取失败
    function failedReadFile()
    {
    console.log("failedReadFile 失败");
    }

    function successCallWriter(writer)
    {
    //var a={"username":"tom1","token":"6546s5ad4f6a5sd4f6a5sd","nine":"123123123"};
    result = base64decode(result);
    result = JSON.parse(result);
    if(data.userId!=null)
    {
    result.userId = data.userId;
    }

    if(data.loginDate!=null)
    {
    result.loginDate = data.loginDate;
    }

    if(data.userToken!=null)
    {
    result.userToken = data.userToken;
    }

    if(data.sudokuNumber!=null)
    {
    result.sudokuNumber = data.sudokuNumber;
    }

    a = JSON.stringify(result);

    var sA = base64encode(a);
    writer.onwrite = function(evt)
    {
    location.href="index.html";
    }
    writer.write(sA);
    }

    function failedCallWriter()
    {
    console.log("failedCallWriter 失败");
    }
 
/* write end */
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
}());