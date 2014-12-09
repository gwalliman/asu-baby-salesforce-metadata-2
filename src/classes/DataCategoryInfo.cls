/**
* This class holds the Data Category Info. from
* the describe result
*/
public class DataCategoryInfo {

 private String name;
 private String label;
 private String displayName;

 public DataCategoryInfo(String name, String label, String displayName) {
  this.name = name;
  this.label = label;
  this.displayName = displayName;
 }

 public String getName() {
  return this.name;
 }

 public String getLabel() {
  return this.label;
 }

 public String getDisplayName() {
  return this.displayName;
 }
}