// ---- A Middleware based IP Rate limiter -----
var ipRateLimiter = new TykJS.TykMiddleware.NewMiddleware({});

ipRateLimiter.NewProcessRequest(function(request, session, spec) {
    // Get the IP address
    var thisIPChain = request.Headers["X-Forwarded-For"][0];
    var ips = thisIPChain.split(",");
    var thisIP = ips[ips.length - 2];

    var thisKey = thisIP + "-" + spec.APIID
    // Set auth header
    request.SetHeaders["x-tyk-authorization"] = thisKey;

    var thisSession = JSON.parse(TykGetKeyData(thisKey, spec.APIID));
    
    var keyDetails = {
        "allowance": 5,
        "rate": 5,
        "per": 5,
        "expires": 0, //Math.round(_.now()/1000 + (60 * 60 * 24)),
        "quota_max": -1,
        "quota_renews": 0,
        "quota_remaining": -1,
        "quota_renewal_rate": 0,
        "access_rights": {},
        "apply_policies": spec.config_data.ipRateLimiter.policies,
        "org_id": spec.OrgID,
        "alias": thisIP,
        "tags": ["IP"]
    };
    keyDetails.access_rights[spec.APIID] = {
        "api_id": spec.APIID,
        "versions": spec.config_data.ipRateLimiter.versions
    };
    
    TykSetKeyData(thisKey, JSON.stringify(keyDetails), 1);
    
    return ipRateLimiter.ReturnData(request);
});

// Ensure init with a post-declaration log message
log("IP rate limiter JS initialised");
