/**
 * Created by semis on 01.10.2022.
 */
@IsTest
private class DealTriggerTest {

    static final Id SALE = Schema.SObjectType.Deal__c.getRecordTypeInfosByName().get('Sale').getRecordTypeId();
    static final Id LEASE = Schema.SObjectType.Deal__c.getRecordTypeInfosByName().get('Lease').getRecordTypeId();
    static final Id BROKER = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Broker').getRecordTypeId();
    static final String STATUS_VALUE_CLW = 'CLosed Won';
    static final String STATUS_VALUE_O = 'Open';
    static final String STATUS_VALUE_AA = 'Awaiting Approval';
    static final String STATUS_VALUE_CLL = 'CLosed Lost';
    static final String STATUS_VALUE_CL = 'CLosed';

    @TestSetup
    static void setup(){

        List<Contact> cnt = new List<Contact>();

        Contact con1 = new Contact();
        con1.RecordTypeId = BROKER;
        con1.Phone = '+375339876009';
        con1.LastName = 'LastName 1';
        cnt.add(con1);

        Contact con2 = new Contact();
        con2.RecordTypeId = BROKER;
        con2.Phone = '+375333453887';
        con2.LastName = 'LastName 2';
        cnt.add(con2);

        insert cnt;

        List<Property__c> prop = new List<Property__c>();

        Property__c p1 = new Property__c();
        p1.Contact__c = con1.Id;
        prop.add(p1);

        Property__c p2 = new Property__c();
        p2.Contact__c = con2.Id;
        prop.add(p2);

        insert prop;

        List<Deal__c> deals = new List<Deal__c>();
        Deal__c d1 = new Deal__c();
        d1.Status__c = STATUS_VALUE_O;
        d1.RecordTypeId = SALE;
        d1.Owner_of_property__c = con1.Id;
        d1.Property__c = p1.Id;
        deals.add(d1);

        Deal__c d2 = new Deal__c();
        d2.Status__c = STATUS_VALUE_CLL;
        d2.RecordTypeId = LEASE;
        d2.Owner_of_property__c = con1.Id;
        d2.Property__c = p1.Id;
        deals.add(d2);

        Deal__c d3 = new Deal__c();
        d3.Status__c = STATUS_VALUE_AA;
        d3.RecordTypeId = SALE;
        d3.Owner_of_property__c = con1.Id;
        d3.Property__c = p1.Id;
        deals.add(d3);

        Deal__c d4 = new Deal__c();
        d4.Status__c = STATUS_VALUE_CL;
        d4.RecordTypeId = SALE;
        d4.Owner_of_property__c = con2.Id;
        d4.Property__c = p2.Id;
        deals.add(d4);

        Deal__c d5 = new Deal__c();
        d5.Status__c = STATUS_VALUE_CLW;
        d5.RecordTypeId = SALE;
        d5.Owner_of_property__c = con2.Id;
        d5.Property__c = p2.Id;
        deals.add(d5);

        Deal__c d6 = new Deal__c();
        d6.Status__c = STATUS_VALUE_O;
        d6.RecordTypeId = SALE;
        d6.Owner_of_property__c = con2.Id;
        d6.Property__c = p2.Id;
        deals.add(d6);

        insert deals;
    }
    @IsTest
    static void testDealTrigger () {
        Deal__c deal = [SELECT Id, Status__c FROM Deal__c WHERE Status__c =: STATUS_VALUE_O LIMIT 1];
        deal.Status__c = 'Closed Won';

        Test.startTest();
        update deal;
        Test.stopTest();
    }

}