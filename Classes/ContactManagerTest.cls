/**
 * Created by semis on 01.10.2022.
 */
@IsTest
private class ContactManagerTest {
    static final Id BROKER = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Broker').getRecordTypeId();
    static final Id OWNER = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Owner').getRecordTypeId();
    static final Integer COUNTER = 2;

    @TestSetup
    static void setup()
    {
        Contact con1 = new Contact();
        con1.FirstName = 'Dasha';
        con1.LastName = 'Semish';
        con1.RecordTypeId = BROKER;
        con1.Phone = '8039832';
        con1.HomePhone = '63161';
        con1.Email = 'test1@gmail.com';
        insert con1;

        Contact con2 = new Contact();
        con2.FirstName = 'Petya';
        con2.LastName = 'Petrov';
        con2.RecordTypeId = OWNER;
        con2.Phone = '2464821';
        con2.HomePhone = '46282';
        con2.Email = 'test2@gmail.com';
        insert con2;
    }

    @IsTest
    static void testGetContactsByIds(){
        List<Contact> contacts = [SELECT Name, RecordTypeId, Phone, HomePhone, Email FROM Contact];
        List<Id> ids = new List<Id>(new Map<Id, Contact>([SELECT Id FROM Contact]).keySet());

        List<Contact> contactsFromConManager = ContactManager.getContactsByIds(ids);

        system.assertEquals(contacts,contactsFromConManager);
    }

    @IsTest
    static void testGetContactsById()
    {
        Contact contact = [SELECT Id, Name, RecordTypeId, Phone, HomePhone, Email FROM Contact LIMIT 1];
        Id iContact = contact.Id;

        Contact contactFromConManager = ContactManager.getContactsById(iContact, 'Id, Name, RecordTypeId, Phone, HomePhone, Email');

        system.assertEquals(contact,contactFromConManager);
    }

    @IsTest
    static void testDeleteContacts()
    {
        List<Id> idsContact = new List<Id>(new Map<Id, Contact>([SELECT Id FROM Contact]).keySet());

        ContactManager.deleteContacts(idsContact);
        List<Id> idsContactAfterDelete = new List<Id>(new Map<Id, Contact>([SELECT Id FROM Contact]).keySet());

        System.assertEquals(0, idsContactAfterDelete.size());
    }

    @IsTest
    static void testCreateContacts(){
        ContactManager.ContactWrapper wrapper = new ContactManager.ContactWrapper();
        wrapper.firstName = 'Test Contact';
        wrapper.lastName = 'Created';
        wrapper.recordTypeId = OWNER;
        wrapper.phone = '+375292827262';
        wrapper.homePhone = '661231';
        wrapper.email = 'test_contact@created.prop';

        List<Contact> contactsFalseInsert = ContactManager.createContacts(wrapper, COUNTER, false);
        List<Contact> contactsNull = [SELECT Id FROM Contact WHERE LastName = 'Created'];
        System.assertEquals(2, contactsFalseInsert.size());
        System.assertEquals(0, contactsNull.size());

        List<Contact> contactsTrueInsert = ContactManager.createContacts(wrapper, COUNTER, true);
        List<Contact> contactsWithInsert = [SELECT Id FROM Contact WHERE LastName = 'Created'];
        System.assertEquals(2, contactsTrueInsert.size());
        System.assertEquals(2, contactsWithInsert.size());

    }

    @IsTest
    static void testUpdateContacts(){

        List<Id> idsContacts = new List<Id>(new Map<Id, Contact>([SELECT Id FROM Contact]).keySet());

        ContactManager.ContactWrapper wrapper = new ContactManager.ContactWrapper();
        wrapper.firstName = 'Test Contact';
        wrapper.lastName = 'Created';
        wrapper.recordTypeId = OWNER;
        wrapper.phone = '+375292827262';
        wrapper.homePhone = '661231';
        wrapper.email = 'test_contact@created.prop';

        List<Contact> contactsFalseUpdate = ContactManager.updateContacts(idsContacts, wrapper, false);
        List<Contact> contactsNull = [SELECT Id FROM Contact WHERE LastName = 'Created'];
        System.assertEquals(2, contactsFalseUpdate.size());
        System.assertEquals(0, contactsNull.size());

        List<Contact> contactsTrueUpdate = ContactManager.updateContacts(idsContacts, wrapper, true);
        List<Contact> contactsWithUpdate = [SELECT Id FROM Contact WHERE LastName = 'Created'];
        System.assertEquals(2, contactsTrueUpdate.size());
        System.assertEquals(2, contactsWithUpdate.size());
    }
}