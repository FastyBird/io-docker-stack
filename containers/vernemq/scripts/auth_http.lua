require "auth/auth_commons"

URL = "http://__APP_HOST/api/vernemq/authenticate"

function auth_on_register(reg)
    if reg.username ~= nil and reg.password ~= nil then
        key = json.encode({
            mountpoint = reg.mountpoint,
            client_id = reg.client_id,
            username = reg.username,
            password = reg.password
        })

        headers = {}
        headers["x_post_header"] = "X-POST-HEADER"
        headers['Accept'] = "application/json"
        headers["Content-Type"] = "application/json"
        headers["X-Api-Key"] = "__APP_API_KEY"

        ret = http.post(pool, URL, key, headers)

        if ret.status == 200 and ret.ref then
            body = http.body(ret.ref)
            json = json.decode(body)
            cache_insert(
                reg.mountpoint,
                reg.client_id,
                reg.username,
                json.publish_acl,
                json.subscribe_acl
            )
            return true
        else
            return false
        end
    end
    return false
end

pool = "auth_http"

config = {
    pool_id = pool
}

http.ensure_pool(config)

hooks = {
    auth_on_register = auth_on_register,
    auth_on_publish = auth_on_publish,
    auth_on_subscribe = auth_on_subscribe,

    on_unsubscribe = on_unsubscribe,
    on_client_gone = on_client_gone,
    on_client_offline = on_client_offline,

    auth_on_register_m5 = auth_on_register_m5,
    auth_on_publish_m5 = auth_on_publish_m5,
    auth_on_subscribe_m5 = auth_on_subscribe_m5,
}
