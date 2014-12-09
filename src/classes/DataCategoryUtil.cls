/**
* This class contains utility functions used by
* the controller
*/
public with sharing class DataCategoryUtil {

 private static final DataCategoryUtil INSTANCE = new DataCategoryUtil();
 private static final String NON_BREAKING_SPACE = '&nbsp;&nbsp;';
 private final String ARTICLE_TYPE = 'KnowledgeArticleVersion';

 private DataCategoryUtil() { }

 public static DataCategoryUtil getInstance() { return INSTANCE; }

 /**
 * Retrieves a List of DataCategoryGroupInfo of all the data category
 * groups associated with Knowledge Article Version
 */
 public DataCategoryGroupInfo[] getAllCategoryGroups() {
  Describedatacategorygroupresult[] results = getDescribeDataCategoryGroupResults();
  DataCategoryGroupInfo[] dataCategoryGroups = new DataCategoryGroupInfo[] { };
  for (Describedatacategorygroupresult singleResult : results) {
   dataCategoryGroups.add(
    new DataCategoryGroupInfo(singleResult.getName(), singleResult.getLabel(),
     singleResult.getDescription(), getCategoryStructure(singleResult.getName())));
  }
  return dataCategoryGroups;
 }

 private Describedatacategorygroupresult[] getDescribeDataCategoryGroupResults() {
  String[] objTypes = new String[] {ARTICLE_TYPE};
  return Schema.describeDataCategoryGroups(objTypes);
 }

 /**
 * Retrieves an ordered list of all Categories for the specified category group
 */
 private DataCategoryInfo[] getCategoryStructure(String categoryGroupName) {
  DataCategory root = getRootCategory(categoryGroupName);
  DataCategory[] yetToBeProcessed = root.getChildCategories();
  DataCategoryInfo[] allCategories = new DataCategoryInfo[] { processCategory(root, '') };
  getAllCategories(yetToBeProcessed, allCategories, NON_BREAKING_SPACE);
  return allCategories;
 }

 private void getAllCategories(DataCategory[] yetToBeProcessed, DataCategoryInfo[] processed, String labelPrefix) {
  for (DataCategory category : yetToBeProcessed) {
   processed.add(processCategory(category, labelPrefix));
   getAllCategories(category.getChildCategories(), processed, labelPrefix + NON_BREAKING_SPACE);
  }
 }

 private DataCategoryInfo processCategory(DataCategory category, String labelPrefix) {
  return new DataCategoryInfo(category.getName(), category.getLabel(), labelPrefix + category.getLabel());
 }

 private DataCategory getRootCategory(String categoryGroupName) {
  Describedatacategorygroupstructureresult structureResult = getDescribeDataCategoryGroupStructureResults(categoryGroupName);
  return structureResult.getTopCategories()[0];
 }

 private Describedatacategorygroupstructureresult getDescribeDataCategoryGroupStructureResults(String categoryGroupName) {
  Datacategorygroupsobjecttypepair pair = new Datacategorygroupsobjecttypepair();
  pair.setSobject(ARTICLE_TYPE);
  pair.setDataCategoryGroupName(categoryGroupName);
  return Schema.describeDataCategoryGroupStructures(new Datacategorygroupsobjecttypepair[] { pair }, false)[0];
 }
}