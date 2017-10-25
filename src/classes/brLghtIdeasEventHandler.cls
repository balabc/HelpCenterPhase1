//TODO: move funtionality to extension package and remove this class
public without sharing class brLghtIdeasEventHandler {

    public static void statusUpdate(Idea voteIdea) {
        Map<String, String> updateSettings = brLghtIdeasHelper.getStatusUpdateSettings();

        if (updateSettings == null) return;

        Boolean isEnabled = Boolean.valueOf(updateSettings.get('active'));

        if (!isEnabled || voteIdea.VoteTotal < Decimal.valueOf(updateSettings.get('threshold'))
                || voteIdea.Status != updateSettings.get('original_status')) {
            return;
        }

        voteIdea.Status = updateSettings.get('new_status');

        try {
            update voteIdea;
        } catch (Exception e) {
            System.debug('LghtIdeasEventHandler::statusUpdate: ' + e.getMessage());
        }
    }
}