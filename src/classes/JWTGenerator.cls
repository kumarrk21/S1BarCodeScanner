public with sharing class JWTGenerator {
	transient String loginUrl = 'https://login.salesforce.com';

	public String getJWTToken(String consumerKey, String certName, Integer tokenValidity, Map <String,Object> claims){
    	Auth.JWS jws = getJWTTokenInternal(consumerKey,certName,tokenValidity,claims);
    	return jws.getCompactSerialization();
    }

    public String getAccessToken(String consumerKey, String certName, Integer tokenValidity, Map <String,Object> claims) {
        Auth.JWS jws = getJWTTokenInternal(consumerKey,certName,tokenValidity,claims);
        Auth.JWTBearerTokenExchange bearer = new Auth.JWTBearerTokenExchange(loginUrl + '/services/oauth2/token', jws);
        return bearer.getAccessToken();
    }


    private Auth.JWS getJWTTokenInternal(String consumerKey, String certName, Integer tokenValidity, Map < String, Object > claims) {
    	setLoginUrl();
        Auth.JWT jwt = new Auth.JWT();
        jwt.setSub(UserInfo.getUserName());
        jwt.setAud(loginUrl);
        jwt.setValidityLength(tokenValidity);
        jwt.setIss(consumerKey);
        jwt.setAdditionalClaims(claims);
        return new Auth.JWS(jwt, certName);
    }

	private void setLoginUrl(){
		List < Organization > org = [Select Id, IsSandbox FROM Organization];
        if (org.size() > 0) {
            if (org[0].IsSandbox) {
                loginUrl = 'https://test.salesforce.com';
            }
        }
	}

}