({
    getApiKey: function(component) {
        var action = component.get("c.getApiKey");
        action.setCallback(this, function(response) {
            var state = response.getState(),
                data, client
            if (state === "SUCCESS") {
                data = response.getReturnValue();
                client = algoliasearch("QUTLQTIH9V", data);
                client.listIndexes(function(err, content) {
                    var availableIndexes = [];
                    if (content.items) {
                        for (var i in content.items) {
                            availableIndexes.push(content.items[i].name);
                        }
                    }
                    component.set("v.availableIndexes", availableIndexes)
                });
                
                component.set("v.apiKey", data);
            }
        });
        $A.enqueueAction(action);
    },
    getSearchResult: function(component) {
        var query = component.get("v.searchText"),
            filter = component.get("v.brFilter"),
            client = algoliasearch("QUTLQTIH9V", component.get("v.apiKey")),
            availableIndexes = component.get("v.availableIndexes"),
            queries = [],
            facetFilters = [],
            facetFilter = [],
            strFilter = '',
            indexName = '';
        
        switch (filter.type) {
            case 'kb': {
                indexName = 'Knowledge_Community';
                if (availableIndexes.indexOf(indexName) > -1) {
                    for (var key in filter.values.article_type) {
                        if (filter.values.article_type[key])
                            facetFilter.push("type__c:" + key);
                    }
                    facetFilters.push(facetFilter);
                    queries.push({
                        indexName: indexName, 
                        query: query,
                        params: {
                            attributesToRetrieve: "*",
                            facets: ["type__c"],
                            facetFilters: facetFilters
                        }
                    });
                    this.getOtherIndexes(
                        availableIndexes, 
                        [
                            'FeedItem_Community',
                            'Ideas_Community'
                        ], 
                        queries, 
                        query
                    );
                }
                break;
            }
            case 'cm': {
                indexName = 'FeedItem_Community';
                if (availableIndexes.indexOf(indexName) > -1) {
                    if (filter.values.posted_in != 'All')
                        facetFilter.push('PostedIn:' + filter.values.posted_in);
                    
                    if (facetFilter.length > 0)
                        facetFilters.push(facetFilter);
                    facetFilter = [];
                    for (var key in filter.values.record_type) {
                        if (filter.values.record_type[key])
                            facetFilter.push('RecordType:' + key);
                    }
                    if (facetFilter.length > 0)
                        facetFilters.push(facetFilter);
                    facetFilter = [];
                    
                    
                    if (filter.values.is_answer) {
                        facetFilters.push(['IsAnswered:Answered']);
                    }
                    
                    if (filter.values.sorting_index != 'FeedItem_Community') {
                        indexName = filter.values.sorting_index;
                    }
                    queries.push({
                        indexName: indexName, 
                        query: query,
                        params: {
                            attributesToRetrieve: '*',
                            facets: ['RecordType', 'PostedIn', 'IsAnswered'],
                            facetFilters: facetFilters
                        }
                    });
                    this.getOtherIndexes(
                        availableIndexes, 
                        [
                            'Knowledge_Community',
                            'Ideas_Community'
                        ], 
                        queries, 
                        query
                    );
                    filter.type = indexName;
                }
                break;
            } 
            case 'ideas': { 
                indexName = 'Ideas_Community';
                if (availableIndexes.indexOf(indexName) > -1) {
                    if (filter.values.record_type != 'All')
                        facetFilter.push('RecordType:' + filter.values.record_type);
                    
                    if (facetFilter.length > 0)
                        facetFilters.push(facetFilter);
                    facetFilter = [];
                    for (var key in filter.values.status) {
                        if (filter.values.status[key]) {
                            facetFilter.push('Status:' + component.find('algolia_search_filter').find('ideas_' + key).get("v.value"));
                        }
                    }
                    if (facetFilter.length > 0)
                        facetFilters.push(facetFilter);
                    facetFilter = [];
                    
                    
                    if (filter.values.is_merged) {
                        facetFilters.push(['IsMerged:Merged']);
                    }
                    
                    if (filter.values.sorting_index != 'Ideas_Community') {
                        indexName = filter.values.sorting_index;
                    }
                    queries.push({
                        indexName: indexName, 
                        query: query,
                        params: {
                            attributesToRetrieve: '*',
                            facets: ['RecordType', 'IsMerged', 'Status'],
                            facetFilters: facetFilters
                        }
                    });
                    this.getOtherIndexes(
                        availableIndexes, 
                        [
                            'Knowledge_Community',
                            'FeedItem_Community'
                        ], 
                        queries, 
                        query
                    );
                    filter.type = indexName;
                }
                break;
            }
            default: {
                this.getOtherIndexes(
                    availableIndexes, 
                    [
                        'Knowledge_Community',
                        'FeedItem_Community',
                        'Ideas_Community'
                    ], 
                    queries, 
                    query
                );
                indexName = 'All';
                break;
             }
        }
        
        filter.type = indexName;
        
        //index.search({ query: query }, function searchDone(err, content) {
        client.search(queries, function searchDone(err, content) {    
            
            var objData = [],
                tmpListData = [],
                categories = content.results,
                k = 0,
                hasData = false,
                name_index = '',
                filterCounts = {},
            	availableIndexes = component.get("v.availableIndexes");
            
            for (var i = 0; i < categories.length; ++i) {
                var category = categories[i], 
                    hits = category.hits,
                    tmpListData = [],
                    item = {};
                
                filterCounts[category.index.toLowerCase()] = ' (' + category.nbHits + ')';
                component.set('v.filterCounts', filterCounts);
                
                if ((hits.length > 0) && ((filter.type == category.index) || (filter.type == 'All'))) {
                    if (availableIndexes.indexOf(category.index) > -1) {
                        switch (category.index) {
                            case 'Knowledge_Community': {
                                name_index = $A.get('$Label.c.hAlgoliaSearchKnowledgeBase');
                                for (var key in hits) { 
                                    item = {
                                        left: '',
                                        right: [],
                                        source: hits[key]
                                    };
                                    if (!!item.source.Data_Category)
                                        item.left = '<p class="serp__item-left-text">' + item.source.Data_Category[0] + '</p>';
                                    item.right = [
                                        '<p class="serp__item-category truncated">' + item.source.type__c + '</p>',
                                        '<p class="serp__item-title truncated">' + item.source.title + '</span>' + 
                                        ((!!item.source.Section)?' <span class="serp__item-title-chevron icon-svg-arrow-angular-sm-right-grey"></span> ' + item.source.Section: '') + 
                                        '</p>',
                                        '<p class="serp__item-description truncated">' + item.source._snippetResult.Section_Content.value + '</p>'
                                    ];
                                    tmpListData.push(item);
                                }
                                break;
                            } 
                            case 'FeedItem_Community':
                            case 'FeedItem_Community_Latest_Post':
                            case 'FeedItem_Community_Recent_Activity': {
                                name_index = $A.get('$Label.c.hAlgoliaSearchCommunity');
                                for (var key in hits) { 
                                    item = {
                                        left: '',
                                        right: [],
                                        source: hits[key]
                                    };
                                    item.left = '<p class="serp__item-left-text">' + item.source.PostedTo + '</p>';
                                    item.right = [
                                        '<p class="serp__item-title truncated">' + item.source.Title + '</p>',
                                        '<p class="serp__item-description truncated">' + item.source._snippetResult.Body.value + '</p>',
                                        '<p class="serp__item-description truncated">' + 
                                        (item.source.IsAnswered? ('<span class="text-status text-status--success"><span class="icon-svg-check-success pos-top-2"></span>&nbsp;<span class="relative">' + item.source.IsAnswered + '</span></span>&nbsp;&nbsp;&nbsp;<span class="middot">&middot;</span>'): '') +
                                        (item.source.IsAnswered?'&nbsp;&nbsp;&nbsp;' + item.source.CreatedDate: item.source.CreatedDate) + '&nbsp;&nbsp;&nbsp;<span class="middot">&middot;</span>' +
                                        '&nbsp;&nbsp;&nbsp;<span class="icon-svg-like-sm-grey"></span>&nbsp;' + item.source.LikeCount + 
                                        '&nbsp;&nbsp;&nbsp;<span class="icon-svg-comments-sm-grey pos-top-2"></span>&nbsp;' + item.source.CommentCount + 
                                        '</p>'
                                    ];
                                    tmpListData.push(item);
                                }
                                break;
                            } 
                            case 'Ideas_Community':
                            case 'Ideas_Community_Trending':
                            case 'Ideas_Community_Popular':
                            case 'Ideas_Community_Recent': {
                                name_index = $A.get('$Label.c.hAlgoliaSearchIdeas');
                                for (var key in hits) { 
                                    item = {
                                        left: '',
                                        right: [],
                                        source: hits[key]
                                    };
                                    item.left = '<p class="serp__item-left-text">' + item.source.Categories + '</p>';
                                    item.right = [
                                        '<p class="serp__item-title truncated">' + item.source.Title + '</p>',
                                        '<p class="serp__item-description truncated">' + item.source._snippetResult.Body.value + '</p>',
                                        '<p class="serp__item-description truncated">' + 
                                        (item.source.Status? (item.source.Status + '&nbsp;&nbsp;&nbsp;<span class="middot">&middot;</span>'): '') +
                                        (item.source.Status?'&nbsp;&nbsp;&nbsp;' + item.source.CreatedDate: item.source.CreatedDate) + '&nbsp;&nbsp;&nbsp;<span class="middot">&middot;</span>' +
                                        '&nbsp;&nbsp;&nbsp;<span class="icon-svg-comments-sm-grey pos-top-2"></span>&nbsp;' + item.source.CommentCount + 
                                        '&nbsp;&nbsp;&nbsp;<span class="icon-svg-star-sm-grey"></span>&nbsp;' + item.source.Votes + 
                                        '</p>'
                                    ];
                                    tmpListData.push(item);
                                }
                                break;
                            }            
                        }
                    }
                    objData.push({
                        name: name_index,
                        items: tmpListData
                    });
                    component.set('v.availableIndexes', availableIndexes); 
                    
                }           
            }
            
            if (objData.length > 0) {
                hasData = true;
            }
            component.set('v.hasData', hasData); 
            component.set('v.categories', objData);
        });
    },
    getOtherIndexes: function(availableIndexes, indexes, queries, query) {
        for (var i in indexes) {
            if (availableIndexes.indexOf(indexes[i]) > -1) {
                queries.push({
                    indexName: indexes[i], 
                    query: query,
                    params: {
                        hitsPerPage: 3,
                        attributesToRetrieve: '*'
                    }
                });
            }
        }
    },
    changeLocation: function(component, type, data) {
        var urlEvent;

        switch (type) {
            case 'ExternalLink': {
                if (data) {
                    urlEvent = $A.get('e.force:navigateToURL');
                    urlEvent.setParams({
                        'url': data
                    });
                    urlEvent.fire();
                }
                break;
            }
            case 'InternalLink': {
                if (data) {
                    urlEvent = $A.get('e.force:navigateToURL');
                    urlEvent.setParams({
                        'url': data
                    });
                    urlEvent.fire();
                }
                break;
            }
            case 'SalesforceObject': {
                if (data) {
                    urlEvent = $A.get('e.force:navigateToSObject');
                    urlEvent.setParams({
                        'recordId': data
                    });
                    urlEvent.fire();
                }
                break;
            }
        }
    }
})