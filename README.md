Barcode Scanner Lightning Component
===================================
This project contains sample code for native barcode scanning in Salesforce1. It contains a custom Lightning component that can be attached to a custom quick action on account record. On tapping the quick action in Salesforce1, it will launch <a href="https://itunes.apple.com/us/app/qr-code-reader-by-scan/id698925807">this</a> QR Code Reader app on the device to scan a barcode. Once scanned, the control is returned to a Visualforce page for attaching the scanned barcode as an 'Asset' to the account record. Once successfully attached, the Visualforce page redirects the user to asset record in Salesforce1 for further updates.

Salesforce1 for iOS doesn't support URL deeplinking of Visualforce pages (yet). It currently (as of Mar'2017 / Version 12.0) only supports deeplinking to a specific record. Please check <a href="https://resources.docs.salesforce.com/sfdc/pdf/salesforce1_url_schemes.pdf">here</a> for more information.
In most cases, after scanning the barcode, you may want to pre-process before navigating the user to a record in Salesforce1. For e.g., in this sample, the user scans a barcode that is attached as an asset to the account. Since VF deeplinking is not supported in Salesforce1 (iOS), this component launches the VF page within the device browser before getting the user back to Salesforce1. Since Winter '17 release, Apex supports creating access tokens (aka Session IDs) using JWT flow. This component, uses the JWT flow to generate an accesstoken so that the user is not prompted to authenticate in the intermediate VF page. Please check <a href="https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_class_Auth_JWT.htm">here</a> for more information.

When (and if) Salesforce1 for iOS supports VF deeplinking, you won't need the JWT flow (and in Android, you won't need this JWT flow either as Salesforce1 in Android already supports VF deeplinking). The component can simply launch the Scan app and have it return the control back to Salesforce1. Until then, you can use this trick to enable pre-processing. Follow the below steps to install this in your Developer or Sandbox org

0. Click 'Deploy to Salsforce button at the end of this page'
1. Once deployed, go to Setup->Administer->Security Controls->Certificate and Key Management
2. Create a Self Signed Certificate. Note down the Unique Name and download the certificate to your desktop/laptop
3. Next, create a connected app (Setup->Create->Apps->Connected Apps->New)
4. Make sure 'Enable OAuth Settings' is checked; callback URL can be something like 'barcode:///mobilesdk/detect/oauth/done'
5. Choose required oAuth scopes (Full access is good for testing but for production you may want to choose the appropriate ones)
6. Make sure 'Use Digital Signatures' is checked. Click 'Choose File' and upload the certificate that you downloaded step 1
7. Save the connected app and note down Consumer Key
8. On the connected app page click 'Manage' and then click 'Edit Policies'
9. Under 'OAuth Policies' choose 'Admin approved users are pre-authorized'. Save
10. Click on 'Manage Profiles' or 'Manage Permission sets' and attach the profiles/permission sets of users that will be using this component
11. Now go to Setup->Administer->Security Controls->Remote site settings->New Remote site. Add an entry for "https://login.salesforce.com" (https://test.salesforce.com for sandbox)
12. Then go to Setup->Build->Develop->Custom metadata types->S1JWTAuth->ManageS1JWTAuth. Cick 'New'
13. Add an entry with label as below 
  * Label: Barcode Scanner
  * S1JWTAuth Name = Barcode_Scanner
  * Consumer key = Key from step 8
  * Certificate Name = Certificate name from step 3
14. Add a custom quick action to Accounts of type 'Lightning Component'. Choose the component 'c:S1BarcodeScanner'
15. Place this custom quick action in pagelayout (under Salesforce1 panel)
16. Download this QR code app from app store "https://itunes.apple.com/us/app/qr-code-reader-by-scan/id698925807" (Check google play store for Android version)
17. Launch the Salesforce1 app, tap on an account, tap on the quick action you create above, this should open up the scan app, scan a barcode and once done, will launch a VF page in Safari, create an asset record for the account and navigate you back to Salesforce1 to edit the created asset record.

Note: This project uses the free version of Scan app, however, for production code, you may want to invest in a commercially available barcode scanner app that allows URL deeplinking.

<a href="https://githubsfdeploy.herokuapp.com?">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/deploy.png">
</a>