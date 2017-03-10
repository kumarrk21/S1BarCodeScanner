public with sharing class JWTGenerator {
	
	@AuraEnabled
	public static String getAccessToken(String key){
		returnMessage ret = new returnMessage();
		ret.accessToken = '';
		ret.baseUrl = '';

		List<S1JWTAuth__mdt> keys = [SELECT Certificate_Name__c, Consumer_Key__c FROM S1JWTAuth__mdt WHERE DeveloperName=:key];
		if(keys.size()>0){
			String consumerKey = keys[0].Consumer_Key__c;
			String certName = keys[0].Certificate_Name__c;
			String userName = UserInfo.getUserName();
			String baseUrl = 'https://login.salesforce.com';

			Auth.JWT jwt = new Auth.JWT();
			jwt.setSub(userName);
			List<Organization> org = [Select Id, IsSandbox FROM Organization];
			if(org.size()>0){
				if(org[0].IsSandbox){
					baseUrl = 'https://test.salesforce.com';
				}
			}
			jwt.setAud(baseUrl);
			jwt.setValidityLength(600);
			jwt.setIss(consumerKey);
			Map<String, Object> claims = new Map<String, Object>();
			claims.put('scope','full');
			jwt.setAdditionalClaims(claims);
		
			Auth.JWS jws = new Auth.JWS(jwt, certName);
			String token = jws.getCompactSerialization();
			String tokenEndPoint = baseUrl + '/services/oauth2/token';
			Auth.JWTBearerTokenExchange bearer = new Auth.JWTBearerTokenExchange(tokenEndpoint, jws);
			ret.accessToken = bearer.getAccessToken();
			ret.baseUrl = URL.getSalesforceBaseUrl().toExternalForm();

		}
		return JSON.serialize(ret);
	}

	private class returnMessage{
		String accessToken {set;get;}
		String baseUrl {set;get;}
	}
}