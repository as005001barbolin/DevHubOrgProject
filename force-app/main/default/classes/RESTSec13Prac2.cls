@RestResource(urlMapping='/sec13rest/*')
global with sharing class RESTSec13Prac2 {
    
    @HttpGet
    global static List<vrpSec10Prac3__Guest__c> getGuestList() {
        //Id returnById = ;
        if (RestContext.request.params.get('id') != null) {
            return [SELECT Name FROM vrpSec10Prac3__Guest__c WHERE Id =: RestContext.request.params.get('id')];
        }
        //String returnUnInvited = ;
        if (RestContext.request.params.get('isInvited') == 'true') {
            return [SELECT Name FROM vrpSec10Prac3__Guest__c WHERE vrpSec10Prac3__Is_Invited__c = false];
        }
        return [SELECT Name FROM vrpSec10Prac3__Guest__c];
    }

    @HttpPut
    global static void addGuestToListByName(List<String> contactsName) {
        List<Contact> contactsId = [SELECT Id, Name FROM Contact WHERE Name IN: contactsName];
        //Все ли контакты из списка существуют и найден? Если нет - создаем недостающие.
        if (contactsId.size() != contactsName.size()) {
            List<Contact> contactsToCreate = new List<Contact>();
            //почистим список от уже существующих
            for (Contact contact : contactsId) {
                if (contactsName.contains(contact.Name)) {
                    contactsName.remove(contactsName.indexOf(contact.Name));
                }
            }
            //создадим новые нужные контакты
            for (String contactName : contactsName) {
                contactsToCreate.add(new Contact(LastName = contactName));
            }
            insert contactsToCreate;
            contactsId.addAll(contactsToCreate);
        }

        try {
            //List<vrpSec10Prac3__Guest__c> guestsId = [SELECT Id FROM vrpSec10Prac3__Guest__c WHERE vrpSec10Prac3__Contact__c IN: contactId.Id];
            List<vrpSec10Prac3__Guest__c> guestsId = new List<vrpSec10Prac3__Guest__c>();
            for (Contact contactId : contactsId) {
                guestsId.add(new vrpSec10Prac3__Guest__c(vrpSec10Prac3__Contact__c = contactId.Id));
            }
            upsert guestsId;
        } catch (Exception ex) {
            System.debug(ex);
        }
    }

    @HttpPatch
    global static void inviteGuestById(String guestId) {
        vrpSec10Prac3__Guest__c guest = [SELECT Id, vrpSec10Prac3__Is_Invited__c FROM vrpSec10Prac3__Guest__c WHERE Id =: guestId];
        try {
            guest.vrpSec10Prac3__Is_Invited__c = true;
            update guest;
        } catch (Exception ex) {
            System.debug(ex);
        }
    }

    @HttpDelete
    global static void deleteGuestById() {
        RestRequest request = RestContext.request;
        String guestId = request.requestURI.substring(
            request.requestURI.lastIndexOf('/')+1);
        vrpSec10Prac3__Guest__c guest = [SELECT Id FROM vrpSec10Prac3__Guest__c WHERE Id =: guestId];
        try {
            delete guest;
        } catch (Exception ex) {
            System.debug(ex);
        }
    }
    
}