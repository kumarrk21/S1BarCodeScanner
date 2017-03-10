({
	
	
	closeActionPanel : function(cmp,evt) {
		try{
			var dismissActionPanel = $A.get("e.force:closeQuickAction");
	    	dismissActionPanel.fire();	
		}catch(e){
			
		}
		
	},

	launchScanner: function(cmp,evt){
		 var url = "scan://scan?callback="+encodeURIComponent("salesforce1://sObject/SCANNED_DATA/view");
		 var urlEvent = $A.get("e.force:navigateToURL");
         urlEvent.setParams({
                "url": url
         });
	}
	
})