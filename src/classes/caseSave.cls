public class caseSave {

    public caseSave(TestController controller) {

    }

    public caseSave(vfKeywordSearchController controller) {

    }

    private ApexPages.StandardController controller;

    public caseSave(ApexPages.StandardController controller) {
        this.controller = controller;
    }
    
    public PageReference saveAndConfirm() {
      controller.save(); // This takes care of the details for you.
      PageReference confirmPage = Page.studentSC;
      confirmPage.setRedirect(true);
      return confirmPage;
    }

}