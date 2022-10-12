/**
 * Created by semis on 30.09.2022.
 */

trigger DealTrigger on Deal__c (after update) {

    DealTriggerHandler updateTrigger = new DealTriggerHandler();

    if(Trigger.isUpdate && Trigger.isAfter){
        updateTrigger.afterUpdate(Trigger.new);
    }
}