/**
 * Created by semis on 30.09.2022.
 */

public with sharing class DealTriggerHandler {

    static final String STATUS_VALUE = 'CLosed Won';
    static final String REC_TYPE = 'Sale';

    List<Deal__c> NotClosedDealList = new List<Deal__c>();
    List<Property__c> PropIdList= new List<Property__c>();

    public void afterUpdate(List<Deal__c> newDeals) {
        for(Deal__c deal : newDeals) {
            if(deal.Status__c == STATUS_VALUE && deal.RecordType.Name == REC_TYPE) {
                PropIdList.add(deal.Property__r);
            }
        }
        for(Property__c prop : PropIdList) {
            for (Deal__c d : prop.Deals__r)
            {
                if(d.Status__c == 'Open' && d.Status__c == 'Awaiting Approval' && d.RecordType.Name == REC_TYPE) {
                    d.Status__c = 'Closed Lost';
                    NotClosedDealList.add(d);
                }
            }
        }
        update NotClosedDealList;
    }
}
