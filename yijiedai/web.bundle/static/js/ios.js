;(function() {
    var root_entry="",
    keyData = {};
	 //login
    $("#member-input-login-button").bind("click",function(){
        login();
    });
    //register
    $("#member-input-register-button").bind("click",function(){
        register();
    });
    //login js start
    function successLogin(response)
    {
        var new_date = Date.parse(new Date())/1000;
        response = $.parseJSON(response);
        if(response.status == "success")
        {
            //缓存数据
            yjdMobi.user = response.user;
  
            //本地化数据
            keyData={
                "userId":response.id,
                "loginDate":new_date,
                "userToken":response.secrethash,
                "sudokuNumber":"",
                "userName":new_usnm
            };
  
            window.requestFileSystem(LocalFileSystem.PERSISTENT,2*1024*1024,
            function(filesystem){
                root_entry = filesystem.root;
                root_entry.getDirectory("files", {create: true, exclusive: false}, function(file_entry){
                    file_entry.getFile("yijiedai.kf", {create: true, exclusive: false}, function(entry){
                        entry.file(function(file){//成功
                            var reader = new FileReader();
                            reader.onloadend = function (evt) {
                                var oldKeyData = evt.target.result;
                                if(oldKeyData != null)
                                {
                                     try
                                     {
                                         oldKeyData = base64decode(oldKeyData);
                                         oldKeyData = JSON.parse(oldKeyData);
                                         if(keyData.userId == oldKeyData.userId && keyData.userName == oldKeyData.userName)
                                         {
                                              keyData.sudokuNumber = oldKeyData.sudokuNumber;
                                         }
                                         window.sessionStorage.setItem("SudokuTmpTimes",0);
                                     }
                                     catch(e)
                                     {
                                         ss.setItem("SudokuTmpTimes",0);
                                         location.href = "index.html#login";
                                     }
                                }
                                
                                //写入文件
                                entry.createWriter(function(writer){
                                    //写入文件
                                    var keyDataStr = JSON.stringify(keyData);
                                    var keyDataStr = base64encode(keyDataStr);
                                    writer.write(keyDataStr);
                                    writer.onwriteend = function(evt) {
                                        $.ui.hideMask();
                                        location.href = "password.html";
                                    };
                                });
                            };
                            reader.readAsText(file);
                        });
                    },function(err){
                        $.ui.hideMask();
                            $("#afui").popup({
                            title:"系统提示",
                            message:"系统错误",
                            cancelText:"确认",
                            cancelOnly:true
                        });
                    });
                },function(err){
                    $.ui.hideMask();
                    $("#afui").popup({
                        title:"系统提示",
                        message:"系统错误",
                        cancelText:"确认",
                        cancelOnly:true
                    });
                });
            },function(err){
                $.ui.hideMask();
                $("#afui").popup({
                    title:"系统提示",
                    message:"系统错误",
                    cancelText:"确认",
                    cancelOnly:true
                });
            },function(err){
                $.ui.hideMask();
                $("#afui").popup({
                    title:"系统提示",
                    message:"系统错误",
                    cancelText:"确认",
                    cancelOnly:true
                });
            });
        }
        else
        {
            $.ui.hideMask();
            $("#afui").popup({
                title:"系统提示",
                message:response.msg,
                cancelText:"确认",
                cancelOnly:true
            });
        }
    }
    function errorLogin(err)
    {
        $.ui.hideMask();
        $("#afui").popup({
            title:"系统提示",
            message:response.msg,
            cancelText:"确认",
            cancelOnly:true
        });
    }
    function login(lgusnm,lgpswd,lgchecked)
    {
  alert($("#loginSave").toggle("selected"));
        $.ui.showMask("登录中。。。");
        var usnm = (lgusnm == null)?$("#userNe").val():lgusnm;
        var pswd = (lgpswd == null)?$("#passWd").val():lgpswd;
        var checked = (lgchecked == null)?$("#loginSave").val():lgpswd;
        var new_pswd = md5(pswd);
        new_usnm = usnm.substr(0,2) + "****" + usnm.substr(-2,2);
 
        var postUrl = yjdMobi.config.baseUrl+"login";
        var postData = {
            "L_name":usnm,
            "L_pwd":new_pswd,
            "setmobile":true,
            "device":device.uuid,
            "devicetype":"ios"
        };
        var opts = {
            type:"post",
            success:successLogin,
            error:errorLogin,
            url:postUrl,
            data:postData,
           // dataType:"json",
            timeout:2000
        };
 
        try
        {
            $.ajax(opts);
        }
        catch(exception)
        {
            $.ui.hideMask();
            alert(exception);
        };
        return false;
    }
    //login js end
 
    //register js start
    function successRegister(response)
    {
    	alert(response);
        var new_date = Date.parse(new Date())/1000;
        response = $.parseJSON(response);
        if(response.status == "success")
        {
            //缓存数据
            yjdMobi.user = response.user;
  
            //本地化数据
            keyData={
                "userId":response.id,
                "loginDate":new_date,
                "userToken":response.secrethash,
                "sudokuNumber":"",
                "userName":new_usnm
            };
            window.requestFileSystem(LocalFileSystem.PERSISTENT,2*1024*1024,
            function(filesystem){
                root_entry = filesystem.root;
                root_entry.getDirectory("files", {create: true, exclusive: false}, function(file_entry){
                    file_entry.getFile("yijiedai.kf", {create: true, exclusive: false}, function(entry){
                        entry.file(function(file){//成功
                            //写入文件
                            entry.createWriter(function(writer){
                                //写入文件
                                var keyDataStr = JSON.stringify(keyData);
                                var keyDataStr = base64encode(keyDataStr);
                                writer.write(keyDataStr);
                                writer.onwriteend = function(evt) {
                                    $.ui.hideMask();
                                    location.href = "password.html";
                                };
                            });
                        });
                    },function(err){
                        $.ui.hideMask();
                            $("#afui").popup({
                            title:"系统提示",
                            message:"系统错误",
                            cancelText:"确认",
                            cancelOnly:true
                        });
                    });
                },function(err){
                    $.ui.hideMask();
                    $("#afui").popup({
                        title:"系统提示",
                        message:"系统错误",
                        cancelText:"确认",
                        cancelOnly:true
                    });
                });
            },function(err){
                $.ui.hideMask();
                $("#afui").popup({
                    title:"系统提示",
                    message:"系统错误",
                    cancelText:"确认",
                    cancelOnly:true
                });
            },function(){
                $.ui.hideMask();
                $("#afui").popup({
                    title:"系统提示",
                    message:"系统错误",
                    cancelText:"确认",
                    cancelOnly:true
                });
            });
        }
        else
        {
            $.ui.hideMask();
            $("#afui").popup({
                title:"系统提示",
                message:response.msg,
                cancelText:"确认",
                cancelOnly:true
            });
        }
    }
  
    function errorRegister()
    {
    	$.ui.hideMask();
        $("#afui").popup({
            title:"系统提示",
            message:"网络连接失败！",
            cancelText:"确认",
            cancelOnly:true
        });
    }
    
    function register()
    {
        $.ui.showMask("注册中。。。");
        var usnm = $("#reg_username").val();
        var usmb = $("#reg_telephone").val();
        var pswd = $("#reg_passWd").val();
        var repswd = $("#reg_rePassWd").val();
        var regidcode = $("#reg_id_code").val();
        var new_pswd = md5(pswd);
        var new_repswd = md5(repswd);
        new_usnm = usnm.substr(0,2) + "****" + usnm.substr(-2,2);
        var new_date = Date.parse(new Date())/1000;
        var postUrl = yjdMobi.config.baseUrl+"register";
        var postData = {
            "username":usnm,
            "password":new_pswd,
            "password2":new_repswd,
            "mobile":usmb,
			"idcode":regidcode,
            "setmobile":true,
            "device":window.device.uuid,
            "devicetype":"ios"
        };
        var opts = {
            type:"post",
            success:successRegister,
            error:errorRegister,
            url:postUrl,
            data:postData,
           // dataType:"json",
            timeout:2000
        };
        try
        {
            $.ajax(opts);
        }
        catch(exception)
        {
            $.ui.hideMask();
            alert(exception);
        };
        return false;
    }
    //register js end
})();