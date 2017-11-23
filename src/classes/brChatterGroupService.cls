public with sharing class brChatterGroupService {
	public static List<brChatterGroupModel> getChatterGroupByStringId(String ids) {
		List<Id> groupIds = new List<Id>();
		if(ids != null) {
			if(ids.contains(',')) {
				List<String> splitArray = ids.split(',');
				if(splitArray.size() > 4) {
					for(Integer i = 0; i < 4; i++) {
						groupIds.add(splitArray[i].trim());
					}
				}
				for(String str : splitArray) {
					groupIds.add(str.trim());
				}
			} else {
				groupIds.add(ids);
			}
		}
		if(groupIds.size() > 0) {
			List<SObject> listGroups = brChatterGroupServiceSelector.getChatterGroup(groupIds);
			List<brChatterGroupModel> chatterGroupModels = new List<brChatterGroupModel>();
			for(SObject gr : listGroups) {
				brChatterGroupModel cls = new brChatterGroupModel();
				cls.id = String.valueOf(gr.get('Id'));
				cls.name = String.valueOf(gr.get('Name'));
				chatterGroupModels.add(cls);
			}
			return chatterGroupModels;			
		} else {
			return null;		        	
		}

	}
	public static Id getListId() {
		return brChatterGroupServiceSelector.getListId();
	}
}