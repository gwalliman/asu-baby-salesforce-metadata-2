/**
* Controller for Visual force Page.
* author SFDC
*/
public with sharing class VfSearchControllerArticles{

    public VfSearchControllerArticles(ApexPages.StandardController controller) {

    }


 //Page Size
 private Static Final Integer PAGE_NUMBER = 10;
 
 //Search String used in ArticleList tag
 public String searchstring { get; set; }

 //Is new List reqd 
 private boolean isRefRequired = true;
 //Exclude filter criteria for UI only
 private static final String EXCLUDE_CRITERIA_FILTER  = 'All';
 
 //Keeps track of current page & max size of article list
 Integer currentPage = 1;
 Integer maxSize = 1;
 
 //Returns array of Category Groups
 public DataCategoryGroupInfo[] getDataCategoryGroupInfo() {
  return DataCategoryUtil.getInstance().getAllCategoryGroups();
 }

 //Returns category keyword required to filter articleList.
 public String getCategoryKeyword() {
  DataCategoryGroupInfo[] categoryGroups = DataCategoryUtil.getInstance().getAllCategoryGroups();
  String categoryCondition = '';
  for (DataCategoryGroupInfo categoryGroup : categoryGroups) {
   String selectedCategoryName = System.currentPageReference().getParameters().Get('categoryType_'+categoryGroup.getName());
   if(selectedCategoryName != null && !selectedCategoryName.equals('NoFilter')) {
    if(categoryCondition=='' && selectedCategoryName != null){
    categoryCondition=categoryCondition+categoryGroup.getName() + ':' + System.currentPageReference().getParameters().Get('categoryType_'+categoryGroup.getName());
    }else {
    categoryCondition=categoryCondition + ',' +categoryGroup.getName() + ':' + System.currentPageReference().getParameters().Get('categoryType_'+categoryGroup.getName());
    }
   }
  }
  String categoryFilter = '';
  for (DataCategoryGroupInfo categoryGroup : categoryGroups) {
   String categoryType = System.currentPageReference().getParameters().Get('categoryType_'+categoryGroup.getName());
   if(categoryType != null &&  !categoryType.equals('NoFilter')) {
    if(categoryFilter == ''){
     categoryFilter = categoryGroup.getName() + '__c ABOVE_OR_BELOW ' + categoryType  +'__c';
    } else {
     categoryFilter = categoryFilter + ' AND ' + categoryGroup.getName() +'__c ABOVE_OR_BELOW ' + categoryType +'__c';
    }
   }
  }
  try {
   if(categoryFilter.length()>0) {
    if(searchString != null && searchString.length() >0 ) {
    String searchquery = 'FIND \'' + searchString + '*\'IN ALL FIELDS RETURNING KnowledgeArticleVersion(Id, title, UrlName, LastPublishedDate,LastModifiedById where PublishStatus =\'online\' and Language = \'en_US\') WITH DATA CATEGORY '+categoryFilter ;
     List<List<SObject>>searchList = search.query(searchquery);
     List<KnowledgeArticleVersion> articleList = (List<KnowledgeArticleVersion>)searchList[0];
     maxSize = articleList.size() ;
//                    maxSize = maxSize.divide(PAGE_NUMBER,2,System.RoundingMode.UP);
    } else {
    String qryString = 'SELECT Id, title, UrlName, LastPublishedDate,LastModifiedById FROM KnowledgeArticleVersion WHERE (PublishStatus = \'online\' and Language = \'en_US\') WITH DATA CATEGORY '+categoryFilter; 
     List<KnowledgeArticleVersion> articleList= Database.query(qryString);
     maxSize = articleList.size() ;
//                    maxSize = maxSize.divide(PAGE_NUMBER,2,System.RoundingMode.UP);
    }
   } else {
   String qryString = 'SELECT Id, title, UrlName, LastPublishedDate,LastModifiedById FROM KnowledgeArticleVersion WHERE (PublishStatus = \'online\' and Language = \'en_US\')';
     List<KnowledgeArticleVersion> articleList= Database.query(qryString);
     maxSize = articleList.size() ;
//                maxSize = maxSize.divide(PAGE_NUMBER,2,System.RoundingMode.UP);
   }        
   } catch(Exception e) {
    Apexpages.addmessages( e );
  }
  /*if(categoryFilter =='') {
//            maxSize = 0;
   categoryCondition = 'Fashions:All,Stores:All,Products:All' ;   
  }*/
  return categoryCondition;
 }
 
 // Action call when the new list needs to be fetched
 public PageReference refreshSearchResult() {
  maxSize = currentPage = 1;
  return null;
 }

 // Returns whether we need to see previous button or not
 public boolean getPrevRequired() {
  return currentPage > 1;
 }

// Returns whether we need to see next button or not
 public boolean getNextRequired() {
  return currentPage * PAGE_NUMBER < maxSize;
 }
  
//Returns current page number 
 public Decimal getCurrentPageNumber() {
  return this.currentPage;
  }

//action for next click
 public PageReference next() {
  if(maxSize > this.currentPage * PAGE_NUMBER) {
   this.currentPage = this.currentPage + 1;
  }
   return null;
 }    
 
//action for previous click
 public PageReference previous() {        
  if(this.currentPage > 1)
   this.currentPage = this.currentPage - 1;
  return null;
 }

}