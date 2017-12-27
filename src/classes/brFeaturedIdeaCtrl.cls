
public with sharing class brFeaturedIdeaCtrl {

    public class featuredIdeaData{
        @AuraEnabled
        public String userId {get; set;}
        @AuraEnabled
        public String itemTitle {get; set;}
        @AuraEnabled
        public String itemText {get; set;}
        @AuraEnabled
        public Integer points {get; set;}
        @AuraEnabled
        public String debugString {get; set;}
    }

    @AuraEnabled
    public static featuredIdeaData getFeaturedIdeaData(String ideaId) {
        featuredIdeaData fData = new featuredIdeaData();
        fData.itemTitle = '';
        fData.debugString = 'ideaId:'+ideaId;
        fData.itemText = '';
        fData.userId = '';
        fData.points = 0;
        if(UserInfo.getUserType() != 'Guest'){
            fData.userId = UserInfo.getUserId();//UserType
            if(fData.userId != null && ideaId != null){
                fData.debugString += 'if-ok|';
                //String communityId = Network.getNetworkId();
                //fData.debugString += 'communityId:'+communityId+'|';
                Idea item = getIdeaData(ideaId);//communityId
                if(item != null){
                    fData.debugString += 'if2-ok|';
                    fData.itemTitle = item.Title;
                    fData.itemText = cutText(item.Body);
                    fData.points = (Integer) item.VoteTotal;
                }

            }
        }
        return fData;
    }

    public static String cutText(String inputText) {
        String outText = '';
        if(inputText != null) {
            String plainText = inputText.stripHtmlTags();
            if (plainText.length() > 200) {
                outText = plainText.left(200) + '...';
            } else {
                outText = plainText;
            }
        }
        return  outText;
    }

    public static Idea getIdeaData(String ideaId) {//, String communityId
        brSecurityService.performAccessCheck('read', 'Idea', new List<String>{'Body','CreatorName','IsHtml','Title','VoteScore','VoteTotal'});

        Idea ideaItem = new Idea();
        try {
            ideaItem = [SELECT Body,CreatorName,IsHtml,Title,VoteScore,VoteTotal FROM Idea WHERE Id = :ideaId];//AND CommunityId = :communityId
        }catch (Exception e){
            //ooops
        }
        return ideaItem;
    }

}