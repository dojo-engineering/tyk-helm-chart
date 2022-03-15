    // ---- A Middleware based IP Rate limiter -----
    var ipRateLimiter = new TykJS.TykMiddleware.NewMiddleware({});

    ipRateLimiter.NewProcessRequest(function(request, session, spec) {
        // Get the IP address
        var thisIPChain = request.Headers["X-Forwarded-For"][0];
        var ips = thisIPChain.split(",")
        var thisIP = ips[ips.length - 2]
    
        // Set auth header
        request.SetHeaders["x-tyk-authorization"] = thisIP;
    
        var thisSession = JSON.parse(TykGetKeyData(thisIP ,spec.APIID))
        log(JSON.stringify(thisSession))

        if (thisSession.status != "error"){
            var keyDetails = {
                "allowance": 5,
                "rate": 5,
                "per": 5,
                "expires": 0,
                "quota_max": -1,
                "quota_renews": 0,
                "quota_remaining": -1,
                "quota_renewal_rate": 0,
                "access_rights": {},
                "apply_policies": spec.config_data.ipRateLimiter.policies,
                "org_id": "62210785d0929d0001b113b1"
            }
            keyDetails.access_rights[spec.config_data.ipRateLimiter.api_id] = {
                "api_id": spec.config_data.ipRateLimiter.api_id,
                "versions": spec.config_data.ipRateLimiter.versions,
            }
            
            TykSetKeyData(thisIP, JSON.stringify(keyDetails), 1)
        }

        return ipRateLimiter.ReturnData(request);
    });
    
// Ensure init with a post-declaration log message
log("IP rate limiter JS initialised");