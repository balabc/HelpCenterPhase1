/**
 * Helper class to work with Networks(Communities)
 */

public without sharing class brNetwork {

    /**
     * Wrapper for getting NetworkId
     *
     * @return String
     */
    public static String getNetworkId(){
        if (!Test.isRunningTest()) {
            return Network.getNetworkId();
        } else {
            return '';
        }
    }
}