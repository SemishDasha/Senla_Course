/**
 * Created by semis on 29.09.2022.
 */

public with sharing class LogManager {

    public static List<Log__c> createLogs(String message, String  type, Integer count, Boolean inserting) {
        List <Log__c> createLogsList = new List<Log__c>();

        for (Integer i=0;i<count;i++){
            Log__c log = new Log__c();
            log.Type__c = type;
            log.Message__c = message;
            createLogsList.add(log);
        }

        if(inserting) insert createLogsList;
        return createLogsList;
    }

    public static List<Log__c> getLogsByIds(List<Id> ids) {
        List<Log__c> logsList = [SELECT Name, Type__c, Message__c FROM Log__c WHERE Id IN :ids];
        return logsList;
    }
    public static List<Log__c> updateLogs(List<Id> ids, String type, String message, Boolean updating) {
        List<Log__c> logsList = [SELECT Name, Type__c, Message__c FROM Log__c WHERE Id IN :ids];


        for (Log__c log : logsList) {
            log.Type__c = type;
            log.Message__c = message;
            logsList.add(log);
        }

        if(updating) update logsList;
        return logsList;
    }

    public static void deleteLogs(List<Id> ids) {
        delete [SELECT Id FROM Log__c WHERE Id IN :ids];
    }
}