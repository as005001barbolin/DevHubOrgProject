public with sharing class ForResViewCont {

    public List<selectOption> options { get; set; }
    public List<Resource__c> resources { get; set; }
    public String listValue { get; set; }
    
    public ForResViewCont() {
        options = new List<selectOption>();
        options.add(new selectOption('Equipment','Equipment'));
        options.add(new selectOption('Furniture','Furniture'));
        options.add(new selectOption('Car','Car'));
    } 
    
    public PageReference changeResources() {
        resources = [SELECT Id, Name FROM Resource__c WHERE Type__c = :this.listValue LIMIT 10000];
        return null;
    }

}