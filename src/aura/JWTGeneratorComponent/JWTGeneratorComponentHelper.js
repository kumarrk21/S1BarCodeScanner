({
	callApex : function(cmp,evt,methodName) {
		var apexMethod = cmp.get(methodName);
		
		apexMethod.setParams({ consumerKey:cmp.get('v.ckey'),
                               certName:cmp.get('v.certName'),
                               tokenValidity:cmp.get('v.tokenValidity')});
		apexMethod.setCallback(this,function(response){
            var state = response.getState();
            if(state == 'SUCCESS'){
                cmp.set('v.token',response.getReturnValue());
            }else{
                var errMessage = 'Error in Apex: Check Apex Debug Logs';
                var errors = response.getError();
                if (errors){
                    if (errors[0] && errors[0].message){
                        errMessage = 'Error in Apex: ' + errors[0].message;
                    }
                }
                console.log(errMessage);
                cmp.set('v.token',errMessage);
            }
        });
        $A.enqueueAction(apexMethod);
	}
})