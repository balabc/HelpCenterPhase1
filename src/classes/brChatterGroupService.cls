public with sharing class brChatterGroupService {
	public static List<brChatterGroupModel> getChatterGroupByStringId(String ids) {
		Set<Id> groupIds = new Set<Id>();
		if(ids != null) {
			if(ids.contains(',')) {
				List<String> splitArray = ids.split(',');
				for(String str : splitArray) {
					groupIds.add(str);
				}
			} else {
				groupIds.add(ids);
			}
		}
		List<SObject> listGroups = brChatterGroupServiceSelector.getChatterGroup(groupIds, 4);
		List<brChatterGroupModel> chatterGroupModels = new List<brChatterGroupModel>();
		for(SObject gr : listGroups) {
			brChatterGroupModel cls = new brChatterGroupModel();
			cls.id = String.valueOf(gr.get('Id'));
			cls.name = String.valueOf(gr.get('Name'));
			chatterGroupModels.add(cls);
		}
		return chatterGroupModels;
	}
}