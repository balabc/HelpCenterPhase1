({
	getSearchResult: function(component) {
		var query = component.get("v.searchText"),
            filter = component.get("v.brFilter"),
            client = algoliasearch("QUTLQTIH9V", "1c0e6fe333993632fcb545ca781bd6bd"),
            queries = [],
            facetFilters = [],
            facetFilter = [],
            strFilter = '';
        
        console.log(filter);
        switch (filter.type) {
            case 'kb': {
                for (var key in filter.values.article_type) {
                    if (filter.values.article_type[key])
                		facetFilter.push("type__c:" + key);
                }
                facetFilters.push(facetFilter);
                queries.push({
                    indexName: 'Knowledge_Community', 
                    query: query,
                    params: {
                        attributesToRetrieve: "*",
                        facets: ["type__c"],
 						facetFilters: facetFilters
                    }
                });
                break;
            }
            case 'cm': {
                var indexName = 'FeedItem_Community';
                if (filter.values.posted_in != 'All')
                    facetFilter.push('PostedIn:' + filter.values.posted_in);
                
                if (facetFilter.length > 0)
                	facetFilters.push(facetFilter);
                facetFilter = [];
                for (var key in filter.values.record_type) {
                    if (filter.values.record_type[key])
                		facetFilter.push("RecordType:" + key);
                }
                if (facetFilter.length > 0)
                	facetFilters.push(facetFilter);
                facetFilter = [];
                
                
                if (filter.values.is_answer) {
                    facetFilters.push(["IsAnswered:Answered"]);
                }
                
                if (filter.values.sorting_index != 'FeedItem_Community') {
                    indexName = filter.values.sorting_index;
                }
                queries.push({
                    indexName: indexName, 
                    query: query,
                    params: {
                        attributesToRetrieve: "*",
                        facets: ["RecordType", "PostedIn", "IsAnswered"],
                        facetFilters: facetFilters
                    }
                });
                break;
            }
            default: {
                queries.push({
                    indexName: 'Knowledge_Community', 
                    query: query,
                    params: {
                        hitsPerPage: 3,
                        attributesToRetrieve: "*"
                    }
                });
                queries.push({
                    indexName: 'FeedItem_Community', 
                    query: query,
                    params: {
                        hitsPerPage: 3,
                    	attributesToRetrieve: "*"
                    }
                });
                break;
            }
        }
        
        //index.search({ query: query }, function searchDone(err, content) {
        client.search(queries, function searchDone(err, content) {    
            
            var objData = [],
                tmpListData = [],
                categories = content.results,
                k = 0,
                hasData = false,
                name_index = '';
            
            for (var i = 0; i < categories.length; ++i) {
                var category = categories[i],
                    hits = category.hits,
                    tmpListData = [],
                    item = {};
                
                
                if (hits.length > 0) {
                    switch (category.index) {
                        case 'Knowledge_Community': {
                            name_index = 'Knowledge Community';
                            for (var key in hits) { 
                                item = {
                                    left: '',
                                    right: [],
                                    source: hits[key]
                                };
                                if (!!item.source.Data_Category)
                                    item.left = '<span>' + item.source.Data_Category[0] + '</span>';
                                item.right = [
                                    '<div class="item_type">' + item.source.type__c + '</div>',
                                    '<div class="item_line">' +
                                    '<span class="item_line_title">' + item.source.title + '</span>' + 
                                    ((!!item.source.Section)?'<span class="sep">></span><span class="item_line_section">' + item.source.Section + '</span>': '') + 
                                    '</div>',
                                    '<div class="item_body">' + item.source._snippetResult.Section_Content.value + '</div>'
                                ];
                                tmpListData.push(item);
                            }
                            break;
                        } 
                        case 'FeedItem_Community':
                        case 'FeedItem_Community_Latest_Post':
                        case 'FeedItem_Community_Recent_Activity': {
                            name_index = 'Community';
                            for (var key in hits) { 
                                item = {
                                    left: '',
                                    right: [],
                                    source: hits[key]
                                };
                                item.left = '<span>' + item.source.PostedTo + '</span>';
                                item.right = [
                                    '<div class="item_title">' + item.source.Title + '</div>',
                                    '<div class="item_body">' + item.source.Body + '</div>',
                                    '<div class="item_line">' + 
                                    (item.source.IsAnswered? ('<span class="item_line_title item_line_answer">' + item.source.IsAnswered + '</span>'): '') +
                                    '<span class="item_line_title item_line_date">' + item.source.CreatedDate + '</span>' + 
                                    '<span class="item_line_title item_line_like_count">' + item.source.LikeCount + '</span>' + 
                                    '<span class="item_line_section item_line_comment_count">' + item.source.CommentCount + '</span>' + 
                                    '</div>',
                                ];
                                    tmpListData.push(item);
                        	}
                            break;
      					} 
         			}
                    objData.push({
                    	name: name_index,
                   		items: tmpListData
                    });
        		}           
    		}
            
            if (objData.length > 0) {
                hasData = true;
            }
            component.set("v.hasData", (hasData? 'on': 'off')); 
            component.set("v.categories", objData);
        });
	}
})