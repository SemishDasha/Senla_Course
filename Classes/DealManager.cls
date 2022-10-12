/**
 * Created by semis on 29.09.2022.
 */

public with sharing class DealManager {

    public class DealWrapper {
        public Id buyer {get; set;}
        public Id owner {get; set;}
        public Id property {get; set;}
        public String status {get; set;}
    }

    public static Deal__c createDeals(DealWrapper wrapper, Boolean inserting) {

            Deal__c deal = new Deal__c();
            deal.Buyer__c = wrapper.buyer;
            deal.Owner_of_property__c = wrapper.owner;
            deal.Property__c = wrapper.property;
            deal.Status__c = wrapper.status;

        if(inserting) insert deal;
        return deal;
    }

    public static List<Deal__c> getDealsByIds(List<Id> ids, String field) {
        return Database.query('SELECT ' + field + ' FROM Deal__c WHERE Id IN :ids');
    }
    public static Deal__c getDealsById(Id id, String fields ) {
        return Database.query('SELECT ' + fields+ ' FROM Deal__c WHERE Id =: id');
    }

    public static List<Deal__c> updateDeals(List<Id> ids, DealWrapper wrapper, Boolean updating) {
        List<Deal__c> dealsList = [SELECT Name, Buyer__c, Owner_of_property__c, Property__c, Status__c FROM Deal__c WHERE Id IN :ids];

        for (Deal__c deal : dealsList) {
            deal.Buyer__c = wrapper.buyer;
            deal.Owner_of_property__c = wrapper.owner;
            deal.Property__c = wrapper.property;
            deal.Status__c = wrapper.status;
            dealsList.add(deal);
        }

        if(updating) update dealsList;
        return dealsList;
    }

    public static void deleteDeals(List<Id> ids) {
        delete [SELECT Id FROM Deal__c WHERE Id IN :ids];
    }
}