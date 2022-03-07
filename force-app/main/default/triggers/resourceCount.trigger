trigger resourceCount on Resource__c (before insert, before update) {
    if (Trigger.isBefore && Trigger.isInsert || Trigger.isBefore && Trigger.isUpdate) {
        List<Resource__c> resoureces = Trigger.new;
        List<Contact> contacts = new List<Contact>();
        for (Resource__c res : resoureces) {
            Contact contact = [SELECT Id, Name, Responsibility__c, 
                                    (SELECT Id FROM Resources__r) 
                                FROM Contact 
                                WHERE Id = :res.Contact__c 
                                LIMIT 1];
            if (contact.Resources__r.size() >= cost_definition__c.getOrgDefaults().High_Responsibility_Cost__c) {
                contact.Responsibility__c = 'high';
            }
            contacts.add(contact);
        }
        update contacts;
    }
}