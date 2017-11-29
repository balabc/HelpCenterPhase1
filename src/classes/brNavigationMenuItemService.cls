public with sharing class brNavigationMenuItemService {
	
	public static List<brNavigationMenuItemModel> getNavigationMenu() {
		List<brNavigationMenuItemModel> itemList = new List<brNavigationMenuItemModel>();
		List<NavigationMenuItem> items = brNavigationMenuItemServiceSelector.getNavigationMenuItem();
		
		for (NavigationMenuItem item : items) {
			
			if (item.ParentId == null) {
				
				brNavigationMenuItemModel model = new brNavigationMenuItemModel();
				model.id = item.id;
				model.label = item.label; 
				model.position = item.position;
				model.target = item.target;
				model.type = item.type;
				List<brNavigationMenuItemModel> subMenuLevel1 = new List<brNavigationMenuItemModel>();
				
				for (NavigationMenuItem item2 : items) {	
									
					if (item2.ParentId != null && item2.ParentId == item.id) {
						brNavigationMenuItemModel modelSub = new brNavigationMenuItemModel();
						modelSub.id = item2.id;
						modelSub.label = item2.label; 
						modelSub.position = item2.position;
						modelSub.target = item2.target;
						modelSub.type = item2.type;		
						modelSub.parentId = item.id;
						subMenuLevel1.add(modelSub);						
					}
					
				}	
				
				model.subMenu = subMenuLevel1;
				
				if(subMenuLevel1.size() > 0) {
					model.hasSubMenu = true;
				} else {
					model.hasSubMenu = false;
				}
				
				itemList.add(model);
							
			}
			
		}
		
		return itemList;
	}
    
}