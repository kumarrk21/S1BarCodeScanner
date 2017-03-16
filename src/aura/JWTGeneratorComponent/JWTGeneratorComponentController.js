({
	getAccToken : function(cmp, evt, helper) {
		helper.callApex(cmp,event,'c.getAccessToken');        
	},

    getJToken : function(cmp, evt, helper) {
        helper.callApex(cmp,event,'c.getJWTToken');
    }
})