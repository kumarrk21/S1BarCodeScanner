({
    init: function(cmp, evt, helper) {
        var apexMethod = cmp.get('c.getAccessToken');
        apexMethod.setParams({
            key: 'Barcode_Scanner'
        });
        apexMethod.setCallback(this, function(response) {
            var state = response.getState();
            if (state == 'SUCCESS') {
                var resp = JSON.parse(response.getReturnValue());
                var returnURL = resp.baseUrl + '/secur/frontdoor.jsp?sid=' + resp.accessToken + '&retURL=/apex/S1BarCodeScannerVF?scannedData=SCANNED_DATA_' + cmp.get('v.recordId');
                cmp.set('v.gotToken', true);
                if (cmp.get('v.rendered')) {
                    helper.closeActionPanel(cmp, evt)
                }

                try {
                    var urlEvent = $A.get("e.force:navigateToURL");
                    var url = "scan://scan?callback=" + encodeURIComponent(returnURL);
                    urlEvent.setParams({
                        "url": url
                    });
                    urlEvent.fire();
                } catch (e) {

                }

            } else {
                console.log('Error Response is ', response);
                cmp.set('v.message', 'Error in getting access token! Check Console Log');
            }
        });
        $A.enqueueAction(apexMethod);
    },

    doneRendering: function(cmp, evt, helper) {
        cmp.set('v.rendered', true);
        if (cmp.get('v.gotToken')) {
            helper.closeActionPanel(cmp, evt);
        }
    }
})