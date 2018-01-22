({
    getApiKey: function(component) {
        var action = component.get("c.getApiKey");
        action.setStorable();

        action.setCallback(this, function(response) {
            var state = response.getState(),
                data, client
            if (state === "SUCCESS") {
                data = response.getReturnValue();
                component.set("v.apiKey", data);

                client = algoliasearch("QUTLQTIH9V", data);
                client.listIndexes(function(err, content) {
                    var availableIndexes = [];
                    if (content.items) {
                        for (var i in content.items) {
                            availableIndexes.push(content.items[i].name);
                        }
                    }
                    component.set("v.availableIndexes", availableIndexes);
                    var query = component.get("v.searchText");
                    if (!!query) {
                        component.searchChange();
                    }
                });


            }else if (state === "ERROR") {
                var errors = response.getError();
                var error_msg = '';
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        if(errors[0].message === 'access_error'){
                            error_msg = $A.get("$Label.c.hCommunityFLSAccess");
                        }else{
                            error_msg = errors[0].message;
                        }
                    }
                }
                if(error_msg.length === 0){
                    error_msg = $A.get("$Label.c.hUnknownError");
                }
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    mode: "sticky",
                    message: error_msg
                });
                toastEvent.fire();
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
            queries_params = {},
            facetFilters = [],
            facetFilter = [],
            strFilter = '',
            indexName = '',
            filter_type = filter.type;

        //console.log(filter);

        switch (filter_type) {
            case 'kb': {
                indexName = 'KnowledgeStaging';
                if (availableIndexes.indexOf(indexName) > -1) {
                    for (var key in filter.values.article_type) {
                        if (filter.values.article_type[key]) {
                            var article_types = {
                                user_docs: 'Public__kav',
                                video: 'University__kav',
                                guides: 'Learning__kav'
                            };
                            facetFilter.push("articletype:" + article_types[key]);
                        }
                    }
                    facetFilters.push(facetFilter);
                    queries_params = {
                            attributesToRetrieve: "*",
                            facets: ["type__c"],
                            facetFilters: facetFilters,
                            hitsPerPage: component.get('v.countClickViewMore')*20
                        };
                    queries.push({
                        indexName: indexName, 
                        query: query,
                        params: queries_params
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
                    for (var key2 in filter.values.record_type) {
                        if (filter.values.record_type[key2])
                            facetFilter.push('RecordType:' + key2);
                    }
                    if (facetFilter.length > 0)
                        facetFilters.push(facetFilter);
                    facetFilter = [];

                    if (!((!!filter.values.is_answer) && (!!filter.values.is_null_answer))) {
                        if (filter.values.is_answer) {
                            facetFilters.push(['IsAnswered:Answered']);
                        }

                        if (filter.values.is_null_answer) {
                            facetFilters.push(['IsAnswered:noBest']);
                        }
                    }

                    if (filter.values.sorting_index !== 'FeedItem_Community') {
                        indexName = filter.values.sorting_index;
                    }
                    
                    queries_params = {
                            attributesToRetrieve: '*',
                            facets: ['RecordType', 'PostedIn', 'IsAnswered'],
                            facetFilters: facetFilters,
                            hitsPerPage: component.get('v.countClickViewMore')*20
                        };
                    
                    if (indexName === 'FeedItem_Community_Recent_Activity') {
                        queries_params.filters = '(CommentCount > 0)';
                    } else if (indexName === 'FeedItem_Community_Latest_Post') {
                        queries_params.filters = '(RecordType:"Question" OR RecordType:"Post")';
                    }

                    if (!((!!filter.values.with_comments) && (!!filter.values.without_comments))) {
                        if (filter.values.with_comments) {
                            if (!!queries_params.filters && (queries_params.filters !== ''))
                                queries_params.filters += ' AND ';
                            else
                                queries_params.filters = '';

                            queries_params.filters = queries_params.filters + 'CommentCount > 0';
                        }

                        if (filter.values.without_comments) {
                            if (!!queries_params.filters && (queries_params.filters !== ''))
                                queries_params.filters += ' AND ';
                            else
                                queries_params.filters = '';

                            queries_params.filters = queries_params.filters + 'CommentCount = 0';
                        }
                    }
                    
                    queries.push({
                        indexName: indexName, 
                        query: query,
                        params: queries_params
                    });
                    this.getOtherIndexes(
                        availableIndexes, 
                        [
                            'KnowledgeStaging',
                            'Ideas_Community'
                        ], 
                        queries, 
                        query
                    );
                    filter_type = indexName;
                }
                break;
            } 
            case 'ideas': { 
                indexName = 'Ideas_Community';
                if (availableIndexes.indexOf(indexName) > -1) {
                    if (filter.values.record_type !== 'All')
                        facetFilter.push('RecordType:' + filter.values.record_type);
                    
                    if (facetFilter.length > 0)
                        facetFilters.push(facetFilter);
                    facetFilter = [];

                    for (var key3 in filter.values.status) {
                        if (filter.values.status[key3]) {
                            facetFilter.push('Status:' + component.find('algolia_search_filter').find('ideas_' + key3).get("v.value"));
                        }
                    }

                    if (facetFilter.length > 0)
                        facetFilters.push(facetFilter);
                    facetFilter = [];
                   //console.log(filter.values.merged_type);
                    if (filter.values.merged_type !== 'All')
                        facetFilter.push('IsMerged:' + filter.values.merged_type);

                    if (facetFilter.length > 0)
                        facetFilters.push(facetFilter);

                    if (filter.values.sorting_index !== 'Ideas_Community') {
                        indexName = filter.values.sorting_index;
                    }
                    
                    queries_params = {
                            attributesToRetrieve: '*',
                            facets: ['RecordType', 'IsMerged', 'Status'],
                            facetFilters: facetFilters,
                            hitsPerPage: component.get('v.countClickViewMore')*20
                        };
                    
                    if (indexName === 'Ideas_Community_Trending') {
                        queries_params.filters = 'CommentCount > 0';
                    }
                    
                    queries.push({
                        indexName: indexName, 
                        query: query,
                        params: queries_params
                    });
                    this.getOtherIndexes(
                        availableIndexes, 
                        [
                            'KnowledgeStaging',
                            'FeedItem_Community'
                        ], 
                        queries, 
                        query
                    );
                    filter_type = indexName;
                }
                break;
            }
            default: {
                this.getOtherIndexes(
                    availableIndexes, 
                    [
                        'KnowledgeStaging',
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

        filter_type = indexName;
        
        //index.search({ query: query }, function searchDone(err, content) {
        client.search(queries, function searchDone(err, content) {    

            var objData = [],
                tmpListData = [],
                categories = content.results,
                k = 0,
                hasData = false,
                name_index = '',
                link_index = '',
                filterCounts = {},
                objSfdcSite = $A.get('$SfdcSite'),
            	availableIndexes2 = component.get("v.availableIndexes");

            objSfdcSite = (!!objSfdcSite? objSfdcSite.pathPrefix: '');

            for (var i = 0; i < categories.length; ++i) {
                var category = categories[i], 
                    hits = category.hits,
                    item = {};
                tmpListData = [];

                filterCounts[category.index.toLowerCase()] = ' (' + category.nbHits + ')';
                //console.log(hits);
                if ((hits.length > 0) && ((filter_type === category.index) || (filter_type === 'All'))) {
                    if (availableIndexes2.indexOf(category.index) > -1) {
                        switch (category.index) {
                            case 'KnowledgeStaging': {
                                filterCounts['KnowledgeStaging'.toLowerCase()] = ' (' + category.nbHits + ')';
                                name_index = $A.get('$Label.c.hAlgoliaSearchKnowledgeBase');
                                link_index = objSfdcSite + '/s/knowledge';
                                for (var key6 in hits) {
                                    item = {
                                        left: '',
                                        right: [],
                                        source: hits[key6]
                                    };

                                    var title = item.source.title,
                                        section = item.source.Section,
                                        section_content = item.source._snippetResult.Section_Content.value,
                                        hlr = item.source._highlightResult;

                                    if (!!hlr) {

                                        for (var ih in hlr) {
                                            if (hlr.hasOwnProperty(ih)) {
                                                while (hlr[ih].value.indexOf('<em>') > -1) {
                                                    hlr[ih].value = hlr[ih].value.replace('<em>', '<span class="serp__highlight-text">').replace('</em>', '</span>');
                                                }
                                            }
                                        }

                                        if (hlr.hasOwnProperty('title')) {
                                            title = hlr.title.value;
                                        }
                                        if (hlr.hasOwnProperty('Section')) {
                                            section = hlr.Section.value;
                                        }
                                    }

                                    while (section_content.indexOf('<em>') > -1) {
                                        section_content = section_content.replace('<em>', '<span class="serp__highlight-text">').replace('</em>', '</span>');
                                    }

                                    if (!!item.source.Data_Category)
                                        item.left = '<p class="serp__item-left-text">' + item.source.Data_Category[0] + '</p>';
                                    item.right = [
                                        '<p class="serp__item-category truncated">' + item.source.type__c + '</p>',
                                        '<p class="serp__item-title truncated">' +
                                        ((!!item.source.chapter__c)? item.source.chapter__c + ' <span class="serp__item-title-chevron icon-svg-arrow-angular-sm-right-grey"></span> ': '') +
                                        title +
                                        ((!!item.source.Section)?' <span class="serp__item-title-chevron icon-svg-arrow-angular-sm-right-grey"></span> ' + section: '') +
                                        '</p>',
                                        '<p class="serp__item-description truncated">' + section_content + '</p>'
                                    ];
                                    tmpListData.push(item);
                                }
                                break;
                            } 
                            case 'FeedItem_Community':
                            case 'FeedItem_Community_Latest_Post':
                            case 'FeedItem_Community_Recent_Activity': {
                                filterCounts['FeedItem_Community'.toLowerCase()] = ' (' + category.nbHits + ')';
                                name_index = $A.get('$Label.c.hAlgoliaSearchCommunity');
                                link_index = objSfdcSite + '/s/community';
                                for (var key4 in hits) {
                                    item = {
                                        left: '',
                                        right: [],
                                        source: hits[key4]
                                    };

                                    var title4 = item.source._snippetResult.Title.value,
                                        body4 = item.source._snippetResult.Body.value,
                                        hlr4 = item.source._highlightResult;

                                    while (title4.indexOf('<em>') > -1) {
                                        title4 = title4.replace('<em>', '<span class="serp__highlight-text">').replace('</em>', '</span>');
                                    }

                                    while (body4.indexOf('<em>') > -1) {
                                        body4 = body4.replace('<em>', '<span class="serp__highlight-text">').replace('</em>', '</span>');
                                    }

                                    item.left = '<p class="serp__item-left-text">' + item.source.PostedTo + '</p>';
                                    item.right = [
                                        '<p class="serp__item-title truncated">' + title4 + '</p>',
                                        '<p class="serp__item-description truncated">' + body4 + '</p>',
                                        '<p class="serp__item-description truncated">' + 
                                        (item.source.IsAnswered === 'Answered'? ('<span class="text-status text-status--success"><span class="icon-svg-check-success pos-top-2"></span>&nbsp;<span class="relative">' + item.source.IsAnswered + '</span></span>&nbsp;&nbsp;&nbsp;<span class="middot">&middot;</span>'): '') +
                                        (item.source.IsAnswered === 'Answered'?'&nbsp;&nbsp;&nbsp;' + item.source.CreatedDate: item.source.CreatedDate) + '&nbsp;&nbsp;&nbsp;<span class="middot">&middot;</span>' +
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
                                filterCounts['Ideas_Community'.toLowerCase()] = ' (' + category.nbHits + ')';
                                name_index = $A.get('$Label.c.hAlgoliaSearchIdeas');
                                link_index = objSfdcSite + '/s/ideas';
                                for (var key5 in hits) {
                                    item = {
                                        left: '',
                                        right: [],
                                        source: hits[key5]
                                    };

                                    var title5 = item.source.Title,
                                        body5 = item.source._snippetResult.Body.value,
                                        hlr5 = item.source._highlightResult;

                                    if (!!hlr5) {

                                        for (var ih5 in hlr5) {
                                            if (hlr5.hasOwnProperty(ih5)) {
                                                while (hlr5[ih5].value.indexOf('<em>') > -1) {
                                                    hlr5[ih5].value = hlr5[ih5].value.replace('<em>', '<span class="serp__highlight-text">').replace('</em>', '</span>');
                                                }
                                            }
                                        }

                                        if (hlr5.hasOwnProperty('Title')) {
                                            title5 = hlr5.Title.value;
                                        }
                                    }

                                    while (body5.indexOf('<em>') > -1) {
                                        body5 = body5.replace('<em>', '<span class="serp__highlight-text">').replace('</em>', '</span>');
                                    }

                                    item.left = '<p class="serp__item-left-text">' + item.source.Categories + '</p>';
                                    item.right = [
                                        '<p class="serp__item-title truncated">' + title5 + '</p>',
                                        '<p class="serp__item-description truncated">' + body5 + '</p>',
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
                            // no default            
                        }
                    }
                    objData.push({
                        name: name_index,
                        items: tmpListData,
                        link: link_index,
                        nbHits: category.nbHits
                    });
                    component.set('v.availableIndexes', availableIndexes2); 
                    
                }

                component.set('v.filterCounts', filterCounts);
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
    }
})