public with sharing class S1BarcodeScannerController {
	@AuraEnabled
    public static String getAccessToken(String key) {
    	returnMessage ret = new returnMessage();
        ret.accessToken = '';
        ret.baseUrl = '';
        List < S1JWTAuth__mdt > keys = [SELECT Certificate_Name__c, Consumer_Key__c FROM S1JWTAuth__mdt WHERE DeveloperName = : key];
        if (keys.size() > 0) {
        	String consumerKey = keys[0].Consumer_Key__c;
            String certName = keys[0].Certificate_Name__c;
            JWTGenerator jwGen = new JWTGenerator();
            ret.accessToken = jwGen.getAccessToken(consumerKey,certName,600,getClaims());
            ret.baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        }
        return JSON.serialize(ret);
    }

    private static Map <String,Object> getClaims(){
    	Map <String,Object> claims = new Map < String, Object > ();
        claims.put('scope', 'full');
        return claims;
    }

    private class returnMessage {
        String accessToken {
            set;
            get;
        }
        String baseUrl {
            set;
            get;
        }
    }
}