global class BrEventsInstallHandler implements InstallHandler {
    global void onInstall(InstallContext context) {
        if(context.previousVersion() == null) {
            this.setImageSourceSettings('files');
        }
        else {
            this.setImageSourceSettings('attachments');
        }
    }

    private void setImageSourceSettings(String imageSource) {
        if (!BrEventsHelper.performAccessCheck('read', 'BrEvents_Settings__c', null))
            return;

        List<BrEvents_Settings__c> settings = [SELECT Id FROM BrEvents_Settings__c WHERE Name = 'image source'];

        if (settings.size() == 0 && BrEventsHelper.performAccessCheck('create', 'BrEvents_Settings__c', null)) {
            insert new BrEvents_Settings__c(Name='image source', Label__c = 'Image Source', Value__c = imageSource);
        }
    }
}