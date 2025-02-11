function vkInit() {
    vkBridge.send("VKWebAppInit", {});
}

function vkGetAppParams(callback) {
    _vkGetAppParams((appParams) => {
        if (appParams.success) {
            _vkGetUserInfo(appParams.vk_user_id, (userInfo) => {
                if (userInfo.success) {
                    console.log('userInfo');
                    console.log(userInfo.data);

                    if (callback != null) {
                        callback({
                            vkLaunchParams: appParams.data,
                            first_name: userInfo.data.first_name,
                            last_name: userInfo.data.last_name,
                        });
                    }
                } else {
                    console.log(userInfo.error);
                }
            });
        } else {
            console.log(appParams.error);
        }
    });

}

function _vkGetAppParams(callback) {
    vkBridge.send('VKWebAppGetLaunchParams')
        .then((data) => { 
            callback({success: true, data});
        })
        .catch((error) => {
            callback({success: false, error});
        });
}

function _vkGetUserInfo(user_id, callback) {
    vkBridge.send('VKWebAppGetUserInfo', { user_id })
        .then((data) => { 
            callback({success: true, data});
        })
        .catch((error) => {
            callback({success: false, error});
        });
}