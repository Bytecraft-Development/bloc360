{
    "clientId": "bloc360",
    "name": "bloc360",
    "description": "",
    "rootUrl": "https://bloc360.ro:8443/app",
    "adminUrl": "",
    "baseUrl": "",
    "surrogateAuthRequired": false,
    "enabled": true,
    "alwaysDisplayInConsole": false,
    "clientAuthenticatorType": "client-secret",
    "redirectUris": [
    "",
    "*"
],
    "webOrigins": [
    "*",
    ""
],
    "notBefore": 0,
    "bearerOnly": false,
    "consentRequired": false,
    "standardFlowEnabled": true,
    "implicitFlowEnabled": false,
    "directAccessGrantsEnabled": true,
    "serviceAccountsEnabled": false,
    "publicClient": true,
    "frontchannelLogout": true,
    "protocol": "openid-connect",
    "attributes": {
    "oidc.ciba.grant.enabled": "false",
        "oauth2.device.authorization.grant.enabled": "false",
        "display.on.consent.screen": "false",
        "backchannel.logout.session.required": "true",
        "backchannel.logout.revoke.offline.tokens": "false",
        "request.uris": "",
        "consent.screen.text": "",
        "frontchannel.logout.url": "",
        "backchannel.logout.url": "",
        "post.logout.redirect.uris": "*",
        "login_theme": ""
},
    "authenticationFlowBindingOverrides": {},
    "fullScopeAllowed": true,
    "nodeReRegistrationTimeout": -1,
    "defaultClientScopes": [
    "web-origins",
    "acr",
    "profile",
    "roles",
    "email"
],
    "optionalClientScopes": [
    "address",
    "phone",
    "offline_access",
    "microprofile-jwt"
],
    "access": {
    "view": true,
        "configure": true,
        "manage": true
},
    "authorizationServicesEnabled": false
}