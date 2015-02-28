(function() {
	var yjdMobi = {};
    yjdMobi.user = {authed: false};

    var config = {};
    var new_usnm = "",
        ls = window.localStorage,
        ss = window.sessionStorage,
        isguide = ls.getItem("isguide"),
        carousel,indexAutoPlay;
    config.appVersion = "0.6";
    config.baseUrl = "http://api.yijiedai.org/";
    config.borrowlistTemplate = '\
        <div class="yjd-list-tb <% if (status.value == 40 && servertime > starttime) {%>yjd-list-zztb<% } %>"> \
            <a href="#borrowdetails" onclick="yjdMobi.presetBorrowIdView(<%= borrow_id %>)"> \
                <h3> \
                    <span class="tb-title-yg <% if (status.value == 40) {%>">新标预告<% } else if (status.value == 60) { %>bc-719dbe">正在还款<% } else if (status.value == 50) {%>">满标待审<% } else if (status.value == 40) {%>bc-d9000f">正在投标<% } else {%>">还款结束<% } %></span><%= title %> \
                    <span class="tb-title-zun"><% if (al_class.value == 1) { %>精<% } else if (al_class.value == 2) { %>发<% } else { %>尊<% } %></span> \
                </h3> \
                <div class="yjd-box"> <% if (status.value == 40) {%> \
                    <div class="yjd-box-grid2"> \
                        <ul class="yjd-grid2-ul fn-clear"> \
                            <li class="font-12"><span class="font-20 c-df5858"><%= price/10000 %></span>万</li> \
                            <li class="font-12"><span class="font-20 c-df5858"><%= limit.value %></span>个月</li> \
                            <li class="font-12"><span class="font-20 c-df5858"><%= apr %>%</span>年化率</li> \
                        </ul> \
                        <div><span class="yjd-tip-bao">保</span><%= safe.name %><span class="c-df5858">100%</span>本息保障</div> <% if (servertime > starttime) { %> \
                        <div class="fn-re-countdown font-12">满标剩余时间：<time class="font-12"><%= timestr %></time></div> <% } else { %> \
                        <div class="fn-countdown font-12"><%= timestr %>开始</div> <% } %> \
                    </div> \
                    <div class="yjd-box-grid1"> <% if (servertime > starttime) { %> \
                        <div class="fn-toubiao"><%= rate %></div> \
                        <div class="font-12 fn-num"><span class="font-20 c-df5858"><%= unum %></span>人已投标</div> <% } else { %> \
                        <div class="fn-tixing"><div class="btn-tixing">提醒</div></div> <% } %> \
                    </div> <% } else { %> \
                    <div class="font-14 yjd-box-list1">已满标，<span class="font-35 c-df5858"><%= unum %></span>人已投标</div> \
                    <ul class="yjd-hk-grid"> \
                        <li class="font-12"><span class="font-20 c-df5858"><%= price/10000 %></span>万<div class="font-12">信用金额</div></li> \
                        <li class="font-12"><span class="font-20 c-df5858"><%= limit.value %></span>个月<div class="font-12">项目期限</div></li> \
                        <li class="font-12"><span class="font-20 c-df5858"><%= apr %>%</span><div class="font-12">年化利率</div></li> \
                        <li class="yjd-hk-grid-end font-12"><span class="yjd-tip-bao">保</span><%= safe.name %><div class="font-12" style="margin-top:7px">担保方式</div></li> \
                    </ul> <% } %> \
                </div> \
            </a> \
        </div>';

    config.borrowdetailTemplate = '\
        <div class="view-box" data-load-id="<%= borrow.borrow_id %>"> \
            <div class="view-box-list1"> \
                <h2 class="view-box-title1"><span class="tb-title-zun"><% if (borrow.al_class.value == 1) { %>精<% } else if (borrow.al_class.value == 2) { %>发<% } else { %>尊<% } %></span><%= borrow.title %></h2> \
                <ul class="view-com-grid2"> \
                    <li class="view-greid2-l"> \
                        <div class="progress"><div class="progress-line" style="width:<%= borrow.rate %>%;"></div></div> \
                        <span class="c-df5858"><%= borrow.rate %>%</span> \
                    </li> \
                    <li class="view-greid2-r"><span class="c-df5858 font-20"><%= borrow.unum %></span>人投标</li> \
                </ul> \
                <ul class="view-com-grid3"> \
                    <li class="view-greid3-l">借款金额<div><span class="c-df5858 font-14"><%= borrow.price/10000 %></span>万</div></li> \
                    <li>借款期限<div><span class="c-df5858 font-14"><%= borrow.limit.value %></span>个月</div></li> \
                    <li class="view-greid3-r">年化率<div><span class="c-df5858 font-14"><%= borrow.apr %>%</span></div></li> \
                </ul> \
                <ul class="view-com-grid3"> \
                    <li class="view-greid3-l">金额限制<div>最低<span class="c-df5858">100</span>元</div><div>最高<span class="c-df5858">20</span>万</div></li> \
                    <li>还款方式<div><%= borrow.mode.name %></div></li> \
                    <li class="view-greid3-r">担保方式<div><span class="yjd-tip-bao">保</span><%= borrow.safe.name %></div><span class="c-df5858">100%</span>本息保障</li> \
                </ul> \
                <ul class="view-com-grid2"> \
                    <li class="view-greid2-l">发布时间<div><%= yjdMobi.formatDate(borrow.starttime) %></div></li> \
                    <% if (borrow.status.value == 40) { %><li class="view-greid2-r">剩余时间<div><%= yjdMobi.formatTimeDifference(borrow.servertime, borrow.endtime) %></li><% } else { %><li class="view-greid2-r">满标时间<div><%= yjdMobi.formatTimeDifference(borrow.starttime, borrow.endtime) %></li><% } %> \
                </ul> \
            </div> \
            <div class="view-box-list1"> \
                <h2 class="view-box-title2"><i class="iconfont">&#xe617</i>借款详情</h2> \
                <div class="view-list2-contant"><%= borrow.assess %></div> \
            </div> \
            <div class="view-box-list1"> \
                <h2 class="view-box-title2"><i class="iconfont">&#xe603</i>投标记录</h2> \
                <dl class="view-record"> \
                    <dt><ul><li class="view-greid3-1">投标人</li><li class="view-greid3-2">投标时间</li><li class="view-greid3-3">投标金额</li></ul></dt> \
                    <% _.each(invest, function(p) { %><dd><ul><li class="view-greid3-1"><%= p.username.charAt(0) %>*****<%= p.username.charAt(p.username.length-1) %></li><li class="view-greid3-2"><%= p.addtime %></li><li class="view-greid3-3"><%= p.price %></li></ul></dd><% }); %> \
                </dl> \
            </div> \
            <div class="view-box-list1" style=" margin-top:20px;"> \
                <h2 class="view-box-title2"><i class="iconfont">&#xe60a</i>还款表现</h2> \
                <dl class="view-pay"> \
                    <dt><ul><li class="view-pay-grid2">还款日</li><li class="view-pay-grid3">应还本息(元)</li><li class="view-pay-grid4">实际还款日</li><li class="view-pay-grid5">状态</li></ul></dt> \
                    <% _.each(repay, function(p) { %><dd><ul><li class="view-pay-grid2"><%= p.reday %></li><li class="view-pay-grid3"><%= p.price %></li><li class="view-pay-grid4"><% if (p.uptime == 0) { %>-<% } else { %><%= yjdMobi.formatDate(p.uptime) %><% } %></li><li class="view-pay-grid5"><% if (p.status == 1) { %><i class="iconfont">&#xe60c</i><% } else { %>未还<% } %></li></ul></dd><% }); %> \
                </dl> \
            </div> \
        </div>';

    config.accountTemplate = '\
        <div class="account-main"> \
            <ul> \
                <li><i class="iconfont">&#xe608</i></li> \
                <li class="account-main-inf"> \
                    <div><%= username %></div> \
                    <div>可用金额：<%= fund.available.value %>元</div> \
                    <div>冻结金额：<%= fund.frozen.value %>元</div> \
                </li> \
                <li class="account-recharge"><a href="#recharge">充值</a></li> \
            </ul> \
        </div> \
        <div class="account-main-huishou">待回收(元)</br><span><%= fund.recovery.value %></span></div> \
        <div class="account-main-shouyi">累计收益(元)</br><span><%= fund.profit.value %></span></div> \
        <div class="account-content"> <% if (creditor.data) { %>\
            <div class="account-content-list"> \
                <h3><i class="iconfont">&#xe614</i>最新收益</h3> \
                <div class="account-prev"><i class="iconfont">&#xe60f</i></div> \
                <ul class="shouyi-list"> \
                    <% _.each(creditor.data, function(c) { %><li><dl><dt><%= c.title %></dt><dd>投入：<span class="c-df5858"><%= c.invest %></span>元</dd><dd><div class="shouyi-list-l">收益：<span class="c-df5858"><%= c.recovery %></span>元</div><div class="shouyi-list-r">日期：<%= yjdMobi.formatDate(c.repayday, true) %></div></dd></dl></li><% }); %> \
                </ul> \
                <div class="account-next"><i class="iconfont">&#xe610</i></div> \
            </div> <% } %>\
            <div class="account-content-list"> \
                <h3><a href="#mymoney"><i class="iconfont">&#xe607</i><i class="iconfont iconright">&#xe610</i>我的理财</a></h3> \
                <h3><a href="#myassets"><i class="iconfont">&#xe60b</i><i class="iconfont iconright">&#xe610</i>我的资金</a></h3> \
                <h3><a href="#security"><i class="iconfont">&#xe60d</i><i class="iconfont iconright">&#xe610</i>账户安全</a></h3> \
                <h3><a href="#set"><i class="iconfont">&#xe612</i><i class="iconfont iconright">&#xe610</i>设置</a></h3> \
            </div> \
            <div class="actionbutton"><a class="account-sign-in button" onclick="yjdMobi.logout()">退出登录</a></div> \
        </div>';

    config.securityTemplate = '\
        <div class="account-content"><div class="account-content-list security-content-list"> \
            <ul> \
                <li>账户名：<%= username %></li> \
                <li>实名认证：<% if (idCardData) { %>已认证<% } else { %>未认证<a href="#upload">认证</a></li><% } %> \
                <li>登录密码：已设置<a href="#change">修改</a></li> \
                <li>绑定手机：<% if (mobileData) { %>已绑定<% } else { %>未绑定<% } %><a href="#unbundling"><% if (mobileData) { %>解绑<% } else { %>绑定<% } %></a></li> \
                <li>交易密码：<%= payPasswd %><a href="">修改</a></li> \
            </ul> \
        </div></div>';

    config.myfundTemplate = '<% _.each(data, function(d) { %><h3><a href=""><i></i><span class="iconright font-14 right-8" ><span class="c-df5858 font-16"><%= d.value %></span>元</span><%= d.name %></a></h3><% }); %>';

    config.mymoneyTemplate = '\
        <div class="mymoney-main"> \
            <div class="mymoney-main-huishou">累计投资(元)</br><span><%= fund.invest.value %></span></div> \
            <div class="mymoney-main-shouyi">累计收益(元)</br><span><%= fund.profit.value %></span></div> \
        </div> \
        <div class="yjd-btn-list"> \
            <a class="atagbox yjd-btn-on">待收益的标</a> \
            <a class="atagbox">已收益的标</a> \
        </div> \
        <div class="mymoney-content"> \
            <ul class="mymoney-conten-title"><li class="mymoney-list-title1">项目</li><li class="mymoney-list-title2">投资金额</li><li class="mymoney-list-title2">债权价值</li><li class="mymoney-list-title3">回款进度</li></ul> \
            <% _.each(creditor.data, function(c, k) { %><a class="mymoney-conten-list atagbox" onclick="yjdMobi.presetInvestDetails(<%= k %>)" href="#investdetails"><ul><li class="mymoney-list-title1"><%= c.title %></li><li class="mymoney-list-title2 c-df5858"><%= c.invest %></li><li class="mymoney-list-title2 c-df5858"><%= c.recovery %></li><li class="mymoney-list-title3"><span class="c-df5858"><%= c.limit_re %></span>/<%= c.limit %></li></ul></a><% }); %> \
            <a class="load-more atagbox">下拉加载更多</a> \
        </div>';

    config.investdetailTemplate = '\
        <div class="investdetails-content"> \
            <dl> \
                <dt><%= title %></dt> \
                <dd>投入金额：<div><span class="font-20 c-df5858"><%= invest %></span>元</div></dd> \
                <dd>债权价值：<div><span class="font-20 c-df5858"><%= recovery %></span>元</div></dd> \
                <dd>下期回款日：<div><span><%= yjdMobi.formatDate(repayday) %></span></div</dd> \
                <dd>已回收利息：<div><span class="c-df5858"><%= profit %></span>元</div></dd> \
                <dd>回款进度：<span class="c-df5858"><%= limit_re %></span>/<%= limit %></dd> \
                <dd>最近到账日期：<div><% if (starttime == uptime) { %>-<% } else { %><%= yjdMobi.formatDate(uptime) %><% } %></div></dd> \
            </dl> \
        </div> \
        <a class="account-sign-in" style="width:94%" href="#backreport" data-load="yjdMobi.loadRepaymentdetails">查看回款报表</a>';

    config.backreportTemplate = '\
        <div class="backreport-content"> \
            <ul class="backreport-list-title"><li class="backreport-list-1">回款日</li><li class="backreport-list-2">回收本金(元)</li><li class="backreport-list-2">回收利息(元)</li><li class="backreport-list-3">进度</li><li class="backreport-list-3">状态</li></ul> \
            <ul class="backreport-list"> \
                <li class="backreport-list-1">2014/08/08</li> \
                <li class="backreport-list-2"><span class="c-df5858">20,0000.00</span></li> \
                <li class="backreport-list-2"><span class="c-df5858">2916.67<span></li> \
                <li class="backreport-list-3"><span class="c-df5858">1</span>/6</li> \
                <li class="backreport-list-3"><i class="iconfont font-16 gou">&#xe60c</i></li> \
            </ul> \
        </div>';

    yjdMobi.config = config;

    // pc端浏览器支持
    if (!((window.DocumentTouch && document instanceof DocumentTouch) || 'ontouchstart' in window)) {
        var script = document.createElement("script");
        script.src = "static/js/jqmobi/af.desktopBrowsers.js";
        var tag = $("head").append(script);
        $.os.desktop=true;
    }

    // 旧浏览器 JSON 支持
    if (window.JSON === undefined) {
        var script = document.createElement("script");
        script.src = "static/js/lib/json/json2.js";
        var tag = $("head").append(script);
        $.os.desktop=true;
    }
 
    //当前设备为ios
    if ($.os.ios) {
        var urlArr = new Array("cordova.js",
                               "static/js/lib/jpush/JPushPlugin.js",
                               "static/js/ios.js");
    	for(var i=0;i<urlArr.length;i++)
    	{
            var script = document.createElement("script");
            script.src = urlArr[i];
            var tag = $("head").append(script);
        }
    }
 
    yjdMobi.formatDate = function (seconds, dateOnly) {
        var date = new Date(seconds * 1000);
        if (dateOnly) {
            return date.getFullYear() + '-' +
               (date.getMonth() + 1) + '-' +
               date.getDate();
        }
        return date.getFullYear() + '-' +
               (date.getMonth() + 1) + '-' +
               date.getDate() + ' ' +
               date.getHours() + ':' +
               date.getMinutes() + ':' +
               date.getSeconds();
    }

    yjdMobi.formatTimeDifference = function (start, end) {
        if (start > end) {
            return '0分0秒';
        } else {
            return (end-start) > (24*60*60) ? (Math.floor((end-start)/(24*60*60)) + '天'):'' +
                   (end-start) > (60*60) ? (Math.floor((end-start)/(60*60)) + '小时'):'' +
                   Math.floor((end-start)/60) + '分' +
                   (end-start)%60 + '秒';
        }
    }

    yjdMobi.showHide = function (obj, objToHide) {
        var el = $("#" + objToHide)[0];

        if (obj.className == "expanded") {
            obj.className = "collapsed";
        } else {
            obj.className = "expanded";
        }
        $(el).toggle();
    }

    yjdMobi.clearPrevHistory = function(e) {
        var predefinedPanels = ['#recharge','#kaquan'];
        var needle = $.ui.history[$.ui.history.length - 1].target;
        if (predefinedPanels.indexOf(needle) != -1) {
            $.ui.history.pop();
        }
    }

    yjdMobi.presetBorrowIdView = function(id) {
        $('#borrowdetails').attr('borrow-ref', id);
    }

    yjdMobi.loadedBorrowDetails = function() {
        var borrow_id = $('#borrowdetails').attr('borrow-ref');
        var container = $('#borrowdetails');
        if (container.html().trim() == '' || borrow_id != $('#borrowdetails .view-box').attr('data-load-id')) {
            var listUrl = config.baseUrl + "invest/view?id=" + borrow_id;

            $.ajax({
                url: listUrl,
                success: function(resp) {
                    var data = JSON.parse(resp);
                    console.log(data);
                    container.html(_.template(config.borrowdetailTemplate)(data));
                },
                error: function() {
                    showHintMsg('获取列表失败，请稍后重试');
                }
            });
        }
    }

    yjdMobi.login = function() {
        var name = $('#loginUsername').val();
        var pass = $('#loginPassWd').val();
        var save = $('#loginSave').attr('checked');
        console.log(name, pass, save);

        var loginUrl = config.baseUrl + "login";
        $.ajax({
            url: loginUrl,
            type: 'POST',
            data: {'L_name':name, 'L_pwd':md5(pass)},
            success: function(resp) {
                resp = JSON.parse(resp);
                if (resp.status != 'success') {
                    showHintMsg(resp.msg);
                } else {
                    showHintMsg(resp.msg);
                    // 本地化用户信息
                    yjdMobi.user = resp.user;
                    renderLoginTemplate();
                    redirectLoginView();
                }
            },
            error: function() {
                showHintMsg('网络原因，请稍后重试');
            }
        });
    }

    yjdMobi.logout = function() {
        yjdMobi.user = {authed: false};
        $.ui.loadContent('#index', true, true);
    }

    yjdMobi.loadMymoneyDetails = function() {
        var container = $('#mymoney');
        if (container.html().trim() == '') {
            container.html(_.template(config.mymoneyTemplate)(yjdMobi.user));
        }
    }

    yjdMobi.presetInvestDetails = function(key) {
        $('#investdetails').attr('invest-ref', key);
    }

    yjdMobi.loadInvestdetails = function() {
        var container = $('#investdetails');
        var creditorKey = container.attr('invest-ref');
        container.html(_.template(config.investdetailTemplate)(yjdMobi.user.creditor.data[creditorKey]));
    }

    yjdMobi.loadRepaymentdetails = function() {
        var container = $('#backreport');
        var creditorKey = $('#investdetails').attr('invest-ref');
        var creditorData = yjdMobi.user.creditor.data[creditorKey];
        console.log(creditorData);
    }
 
    yjdMobi.findBackPassword = function(){
        $.ui.showMask("密码找回中。。。");
        var usmb = $("#forgot_telephone").val();
        var pswd = $("#forgot_password").val();
        var repswd = $("#forgot_repassword").val();
        var regidcode = $("#forgot_id_code").val();
        var new_pswd = md5(pswd);
        var new_repswd = md5(repswd);
        var postUrl = yjdMobi.config.baseUrl+"zpwd";
        var postData = {
            "password":new_pswd,
            "password2":new_repswd,
            "mobile":usmb,
            "sms":regidcode
        };
        var opts = {
            type:"post",
            success:function(response){
                $.ui.hideMask();
                response = JSON.parse(response);
                if(response.status=="error")
                {
                    $("#afui").popup({
                        title:"系统提示",
                        message:response.msg,
                        cancelText:"确认",
                        cancelOnly:true
                    });
                }
                else if(response.status=="success")
                {
                    $("#afui").popup({
                        title:"系统提示",
                        message:response.msg,
                        cancelText:"确认",
                        cancelOnly:true
                    });
                    $.ui.loadContent('#login', true, true,"up");
                }
                else
                {
                    $.ui.hideMask();
                    $("#afui").popup("网络连接失败！");
                }
            },
            error:function(){
                $.ui.hideMask();
                $("#afui").popup("网络连接失败！");
            },
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
 
    window.yjdMobi = yjdMobi;

    // static functions
    function borrowListLoad(offset) {
        var p = Math.floor(offset / 10 + 1);
        var container = $('#index .yj``d-list');
        var listUrl = config.baseUrl + "invest/viewlist?p=" + p;

        $.ajax({
            url: listUrl,
            success: function(resp) {
                var data = JSON.parse(resp);
                var list = data.list;
                console.log(list);
                for (var i = 0; i < list.length; i++) {
                    container.append(_.template(config.borrowlistTemplate)(list[i]));
                }
            },
            error: function() {
                showHintMsg('获取信息失败，请稍后重试');
            }
        });
    }

    function saveAuthStack(dest) {
        yjdMobi.authStack = dest;
    }

    function getAuthStack() {
        return yjdMobi.authStack;
    }

    function showHintMsg(msg) {
        if ($.os.webkit == true) {
            // 未将来网页端页面消息显示预留定制显示
            alert(msg);
        } else {
            alert(msg);
        }
    }

    function redirectLoginView() {
        $.ui.goBack();
        $.ui.loadContent(getAuthStack(), false, false);
        if (getAuthStack() == '#account') {
            $('#index-footer a').removeClass('pressed');
            $('#index-footer .need_auth').addClass('pressed');
        }
    }

    function renderLoginTemplate() {
        if (yjdMobi.user.authed == false) {
            showHintMsg('登陆信息错误，请重新登陆');
            return;
        }
        var accountContainer = $('#account');
        accountContainer.html(_.template(config.accountTemplate)(yjdMobi.user));

        var securityContainer = $('#security');
        securityContainer.html(_.template(config.securityTemplate)(yjdMobi.user));

        var myfundContainer = $('#myfundsummary');
        var myfund = {data:[yjdMobi.user.fund.total, yjdMobi.user.fund.available, yjdMobi.user.fund.frozen, yjdMobi.user.fund.recovery]};
        myfundContainer.append(_.template(config.myfundTemplate)(myfund));

        $('.bid-available-fund').html(yjdMobi.user.fund.available.value);
    }

    var tmpTime=5000;
    //index js start
    function indexAutoPlay()
    {
        indexAutoPlay=$("#index-banner-auto-play").carousel({
            vertical:false,
            horizontal:true,
            pagingDiv: "index-banner-auto-play-dots",
            pagingCssName: "carousel_paging2",
            pagingCssNameSelected: "carousel_paging2_selected",
            preventDefaults:false,
            wrap:true //Set to false to disable the wrap around
        });
        window.setInterval(autoPlayPlus,tmpTime);
 
    }

    function autoPlayPlus()
    {
        var currIndex = indexAutoPlay.carouselIndex+1;
        if( currIndex == indexAutoPlay.childrenCount)
        {
            currIndex=0;
        }
        indexAutoPlay.onMoveIndex(currIndex,2000);
        tmpTime = 7000;
    }
 
    //index js end
 
    
	
	//id code js start
	function requertIdCode()
	{
		$.ui.showMask("请求短信验证中。。。");
		var tele = $("#reg_telephone").val();
		var url = config.baseUrl+"mobile/submit_verify";
        var postData = {
            "mobile":tele
        };
		$.post(
            url,
            postData,
            function(response)
            {
				$.ui.hideMask();
                response = JSON.parse(response);
                if(response.status=="error")
                {
                    $("#afui").popup({
                        title:"系统提示",
                        message:response.msg,
                        cancelText:"确认",
                        cancelOnly:true
                    });
                }
                else if(response.status=="success")
                {
                    $("#afui").popup({
                        title:"系统提示",
                        message:"请稍后,消息马上送到",
                        cancelText:"确认",
                        cancelOnly:true
                    });

                }
			},
            function()
            {
                $.ui.hideMask();
                $("#afui").popup("网络连接失败！");
            },
            "json"
        );
        return false;
	}
 
    function requestForgotIdCode()
    {
        $.ui.showMask("请求短信验证中。。。");
        var tele = $("#forgot_telephone").val();
        var url = config.baseUrl+"mobile/submit_verify";
        var postData = {
            "mobile":tele
        };
        $.post(
            url,
            postData,
            function(response)
            {
                $.ui.hideMask();
                response = JSON.parse(response);
                if(response.status=="error")
                {
                    $("#afui").popup({
                        title:"系统提示",
                        message:response.msg,
                        cancelText:"确认",
                        cancelOnly:true
                    });
                }
                else if(response.status=="success")
                {
                    $("#afui").popup({
                        title:"系统提示",
                        message:"请稍后,消息马上送到",
                        cancelText:"确认",
                        cancelOnly:true
                    });
                }
            },
            function()
            {
                $.ui.hideMask();
                $("#afui").popup("网络连接失败！");
            },
            "json"
        );
        return false;
    }
	//id code js end

    //guide js start
    function init_carousel() {
        carousel=$("#carousel").carousel({
            pagingDiv: "carousel_dots",
            pagingCssName: "carousel_paging2",
            pagingCssNameSelected: "carousel_paging2_selected",
            preventDefaults:false,
            wrap:false //Set to false to disable the wrap around
        });
    }
    //guide js end
 
    //news js start
    function newsPullFromServer()
    {
        var listUrl = config.baseUrl + "invest/view?id=" + borrow_id;

        $.ajax({
            url: listUrl,
            success: function(resp) {
                var data = JSON.parse(resp);
                console.log(data);
                container.html(_.template(config.investdetailTemplate)(data));
            }
        });
 
    }
    //news js end
 
    //version js start
    function checkVersion()
    {
//        var url = config.baseUrl+"mobile/submit_verify";
//        var postData = {
//            "mobile":tele
//        };
        $("#afui").popup({
            title: "系统提示",
            message: "医界贷提供了一个最新的版本,请更新一下试试.",
            cancelText: "下次更新",
            cancelCallback: function () {
                console.log("cancelled");
            },
            doneText: "立即更新",
            doneCallback: function () {
                window.open("http://www.baidu.com","_system","location=yes");
            },
            cancelOnly: false
        });
 /*
        $.post(
            url,
            postData,
            function(response)
            {
                $.ui.hideMask();
                response = JSON.parse(response);
                if(response.status=="error")
                {
                    $("#afui").popup({
                        title:"系统提示",
                        message:response.msg,
                        cancelText:"确认",
                        cancelOnly:true
                    });
                }
                else if(response.status=="success")
                {
                    $("#afui").popup({
                        title:"系统提示",
                        message:"请稍后,消息马上送到",
                        cancelText:"确认",
                        cancelOnly:true
                    });

                }
            },
            function()
            {
                $.ui.hideMask();
                $("#afui").popup("网络连接失败！");
            },
            "json"
        );
 */
    }
    //version js end
 
    //clear js start
    function clearHistoryCache()
    {
        $.ui.showMask("清除缓存中。。。");
        ls.clear();
        ss.clear();
        setTimeout(function(){$.ui.hideMask();},3000);
    }
    //clear js end
 
    //jpush js start
    function initJpush(iData)
    {
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
 
    function switchPush(stat)
    {
        if(stat == "pressed")
        {
            window.plugins.jPushPlugin.resumePush();
        }
        else
        {
            window.plugins.jPushPlugin.stopPush();
        }
    }
    //jpush js end
 
    //跳转到修改手势密码页面
    function changeGesturePassword()
    {
        ss.setItem("SudokuTmpKeyChange","yes");
        location.href = "password.html";
    }
 
    $(document).ready(function () {
        window.addEventListener("load", init_carousel, false);
        $.ui.launch();
    });
 
    $.ui.ready(function() {
        // after ui launched
        indexAutoPlay();
        borrowListLoad(0);

		$('.need_auth').bind('click', function(e) {
            var dest = $(this).attr('dest');
            if (yjdMobi.user.authed === false) {
                if (e && e.preventDefault) {
                    e.preventDefault();
                }else{
                    window.event.returnValue = false;
                }
                saveAuthStack(dest);
                $.ui.loadContent('#login', false, false, 'up');
            } else {
                $.ui.loadContent(dest, false, false);
            }
        });

		$.passwordBox().getOldPasswords();
       
        //1idcode
        $("#get-id-code-button").bind("click",function(){
            requertIdCode();
        });
        //forgot idcode
        $("#ask_forgot_id_code").bind("click",function(){
            requestForgotIdCode();
        });
        //forgot
        $("#change_password").bind("click",function(){
            yjdMobi.findBackPassword();
        });
        //version
        $("#check-new-version").bind("click",function(){
            checkVersion();
        });
        //clear
        $("#clear-cache-history").bind("click",function(){
            clearHistoryCache();
        });
        //push
        $("#notice-switch").bind("change",function(){
            switchPush($("#notice-switch-val").attr("class"));
        });
        //gesture password
        $("#change-gesture-password").bind("click",function(){
            changeGesturePassword();
        });
        ss.setItem("SudokuTmpKeyChange","no");
        // guide
        if(isguide != "true")
        {
            $.ui.loadContent("#guide",false,false,"fade");
            $("#guide").attr("selected","true");
            $("#guide_page_last").bind("tap",function(){
                ls.setItem("isguide",true);
                $.ui.loadContent("#index",false,false,"fade");
            });
        }
        // login
//               $("#loginSave").click();
//               $("#loginSave").bind("change",function(){
//                                    alert($(this).attr("selected"));
//                                                    });
    });

    $.ui.blockPageScroll();
	$.ui.isAjaxApp=true;

})()