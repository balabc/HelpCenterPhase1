public with sharing class brCategoryModel {

    public class CategoryWrapper {

        /**
         * category id
         */
        @AuraEnabled    
        public String id {get;set;}

        /**
         * parent category id
         */
        @AuraEnabled
        public String parent {get;set;}

        /**
         * text category
         */
        @AuraEnabled
        public String text {get;set;}

        /**
         * Constructor
         *
         * {@inheritDoc}
         *
         * @param       id          String
         * @param       name        String
         * @param       parentid    String
         * @return      this object
         * @see         CategoryWrapper
         */
        public CategoryWrapper(String id, String name, String parentid) {
            this.id=id ;//+ '__c';
            this.parent = (parentid == null) ? '#' : parentid;// + '__c';
            this.text = name;
        }

    }

}