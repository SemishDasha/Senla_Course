/**
 * Created by semis on 30.09.2022.
 */

public with sharing class DealTriggerHandler {

    static final String STATUS_VALUE_CLW = 'CLosed Won';
    static final String STATUS_VALUE_CLL = 'CLosed Lost';
    static final Id SALE = Schema.SObjectType.Deal__c.getRecordTypeInfosByName().get('Sale').getRecordTypeId();


    List<Deal__c> ClosedWonDealList = new List<Deal__c>();
    List<Id> IdsPropIdList= new List<Id>();

    public void afterUpdate(List<Deal__c> newDeals) {
        for(Deal__c deal : newDeals) {
            if(deal.Status__c == STATUS_VALUE_CLW && deal.RecordTypeId == SALE) {
                IdsPropIdList.add(deal.Property__c);
                ClosedWonDealList.add(deal);
            }
        }

        List<Deal__c> NotClosedDealList = [SELECT Id, RecordTypeId, Status__c
                                            FROM Deal__c
                                            WHERE RecordTypeId =: SALE
                                            AND (NOT Status__c LIKE : 'Closed')
                                            AND Id !=: ClosedWonDealList
                                            AND Property__c =: IdsPropIdList];

        for(Deal__c deal : NotClosedDealList ) {
            deal.Status__c = STATUS_VALUE_CLL;
        }
        update NotClosedDealList;
    }
}