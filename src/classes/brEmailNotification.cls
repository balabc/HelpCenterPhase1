global class brEmailNotification {
    private List<Messaging.SingleEmailMessage> mails;
    private List<brTestEmail__c> elog;

    global brEmailNotification() {
        this.mails = new List<Messaging.SingleEmailMessage>();
        this.elog = new List<brTestEmail__c>();
    }

    global void addIdeaCreatedNotification(String address, Idea idea, String templateName){
        String ideaUrl = '';

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {address});
        EmailTemplate em = this.getEmailTemplate(templateName);

        Map<String, String> tplVars = this.parseTemplateSettingsVars(em.HtmlValue);

        if (tplVars.get('TargetURL') != NULL && tplVars.get('TargetURL') != '') {
            ideaUrl = tplVars.get('TargetURL') + '#' + idea.Id;
        }

        String emailBody = this.cleanTemplateBody(em.HtmlValue);
        emailBody = emailBody.replace('{!authorName}', UserInfo.getName());
        emailBody = emailBody.replace('{!ideaTitle}', idea.Title);
        emailBody = emailBody.replace('{!ideaTitleLink}', '<a href="' + ideaUrl + '">' + idea.Title + '</a>');
        emailBody = emailBody.replace('{!ideaBody}', idea.Body);

        mail.subject = em.Subject.replace('{!ideaTitle}', idea.Title);
        mail.setHtmlBody(emailBody);

        String orgWideEmailAddressId = brLghtIdeasHelper.getConfigValue('orgwide_email_id');
        if (orgWideEmailAddressId != NULL && String.isNotBlank(orgWideEmailAddressId)) {
            mail.setOrgWideEmailAddressId(brLghtIdeasHelper.getConfigValue('orgwide_email_id'));
        }

        this.mails.add(mail);

        this.elog.add(new brTestEmail__c(
                ToAddresses__c = address,
                Subject__c = mail.subject,
                EmailBody__c = emailBody,
                EmailTemplate__c = templateName
            ));
    }

    global void addNewCommentNotification1(String address, IdeaComment comment, String templateName) {
        String ideaUrl = '';

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {address});
        EmailTemplate em = this.getEmailTemplate(templateName);

        Map<String, String> tplVars = this.parseTemplateSettingsVars(em.HtmlValue);

        if (tplVars.get('TargetURL') != NULL && tplVars.get('TargetURL') != '') {
            ideaUrl = tplVars.get('TargetURL') + '#' + comment.Idea.Id;
        }

        String emailBody = this.cleanTemplateBody(em.HtmlValue);
        emailBody = emailBody.replace('{!ideaTitle}', comment.Idea.Title);
        emailBody = emailBody.replace('{!ideaTitleLink}', '<a href="' + ideaUrl + '">' + comment.Idea.Title + '</a>');
        emailBody = emailBody.replace('{!authorName}', UserInfo.getName());
        emailBody = emailBody.replace('{!commentBody}', comment.CommentBody);

        mail.subject = em.Subject.replace('{!authorName}', UserInfo.getName());
        mail.setHtmlBody(emailBody);

        String orgWideEmailAddressId = brLghtIdeasHelper.getConfigValue('orgwide_email_id');
        if (orgWideEmailAddressId != NULL && String.isNotBlank(orgWideEmailAddressId)) {
            mail.setOrgWideEmailAddressId(brLghtIdeasHelper.getConfigValue('orgwide_email_id'));
        }

        this.mails.add(mail);

        this.elog.add(new brTestEmail__c(
                ToAddresses__c = address,
                Subject__c = mail.subject,
                EmailBody__c = emailBody,
                EmailTemplate__c = templateName
            ));
    }

    global void addStatusChangeNotification1(String address, Idea idea, String oldStatus, String templateName) {
        String ideaUrl = '';

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[] {address});
        EmailTemplate em = this.getEmailTemplate(templateName);

        Map<String, String> tplVars = this.parseTemplateSettingsVars(em.HtmlValue);

        if (tplVars.get('TargetURL') != NULL && tplVars.get('TargetURL') != '') {
            ideaUrl = tplVars.get('TargetURL') + '#' + idea.Id;
        }

        String emailBody = this.cleanTemplateBody(em.HtmlValue);
        emailBody = emailBody.replace('{!oldStatus}', oldStatus);
        emailBody = emailBody.replace('{!newStatus}', idea.Status);
        emailBody = emailBody.replace('{!ideaTitle}', idea.Title);
        emailBody = emailBody.replace('{!ideaTitleLink}', '<a href="' + ideaUrl + '">' + idea.Title + '</a>');
        emailBody = emailBody.replace('{!ideaBody}', idea.Body);

        mail.subject = em.Subject.replace('{!ideaTitle}', idea.Title).replace('{!newStatus}', idea.Status);
        mail.setHtmlBody(emailBody);

        String orgWideEmailAddressId = brLghtIdeasHelper.getConfigValue('orgwide_email_id');
        if (orgWideEmailAddressId != NULL && String.isNotBlank(orgWideEmailAddressId)) {
            mail.setOrgWideEmailAddressId(brLghtIdeasHelper.getConfigValue('orgwide_email_id'));
        }

        this.mails.add(mail);

        this.elog.add(new brTestEmail__c(
                ToAddresses__c = address,
                Subject__c = mail.subject,
                EmailBody__c = emailBody,
                EmailTemplate__c = templateName
            ));
    }

    global Messaging.SendEmailResult[] sendEmails() {
        if (Test.isRunningTest()) {
            insert this.elog;
        }

        return Messaging.sendEmail(this.mails, false);
    }

    private EmailTemplate getEmailTemplate(String name) {
        return [SELECT HtmlValue, Subject FROM EmailTemplate WHERE Name = :name LIMIT 1];
    }

    private String cleanTemplateBody(String emailBody) {
        return emailBody.replaceAll('<!--.*-->', '');
    }

    private Map<String, String> parseTemplateSettingsVars(String text){
        Map<String, String> vars = new Map<String, String>();
        List<String> splittedText = text.split('<!--');
        String varLine;
        List<String> varLineParts;

        if (splittedText.size() < 2) return vars;

        for (Integer i = 1; i < splittedText.size(); i++) {
            varLine = splittedText[i].replace('-->', '');
            varLineParts = varLine.split(':', 2);

            if (varLineParts.size() != 2) continue;

            vars.put(varLineParts[0], varLineParts[1]);
        }

        return vars;
    }

    //undeletable old methods
    global void addNewCommentNotification(String address, IdeaComment comment) {}
    global void addStatusChangeNotification(String address, Idea idea, String oldStatus) {}
}