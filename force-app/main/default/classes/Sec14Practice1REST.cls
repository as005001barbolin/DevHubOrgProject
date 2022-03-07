@RestResource(urlMapping='/sec14rest/*')
global with sharing class Sec14Practice1REST {

    @HttpGet
    global static List<Contact> getCreatedContacts() {
        List<Contact> contacts = [SELECT Id, Name FROM Contact WHERE CreatedBy.Id = '0055j000001SJK6AAO' LIMIT 10000];
        return contacts;
    }

    @HttpPost
    global static void postNewContact(String firstName, String lastName, String title) {
        
        vrpSec10Prac3__Sec14Prac1__e eventVariable = new vrpSec10Prac3__Sec14Prac1__e(
            vrpSec10Prac3__contact_first_name__c = firstName, 
            vrpSec10Prac3__contact_last_name__c = lastName, 
            vrpSec10Prac3__contact_title__c = title);

        Database.SaveResult result = EventBus.publish(eventVariable);
    }
}