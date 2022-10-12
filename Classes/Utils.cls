/**
 * Created by semis on 12.10.2022.
 */

public with sharing class Utils {
    public static String getJSONInfo(Id id) {

        Deal__c deal = DealManager.getDealsById(id, 'id, Owner_of_property__c, Buyer__c, Start_of_lease__c, End_of_lease__c');
        Id pId = DealManager.getDealsById(id, 'Property__c').Property__c;
        Property__c propertyInDeal = PropertyManager.getPropertyById(id, 'Address__c, City__c, Country__c, Latitude__c, Longitude__c');

        Contact buyer = ContactManager.getContactsById(deal.Buyer__c, 'id, FirstName, LastName, Email');
        Contact owner = ContactManager.getContactsById(deal.Owner_of_property__c, 'id, FirstName, LastName, Email');

        Datetime dt = Datetime.now();
        Date sd = deal.Start_of_lease__c;
        Date ed = deal.End_of_lease__c;

        Client client = new Client (buyer.Id, buyer.FirstName, buyer.LastName, buyer.Email);
        Client ownerOfProp = new Client (owner.Id, owner.FirstName, owner.LastName, owner.Email);
        LocationWrapper locationWrapper = new LocationWrapper(propertyInDeal.Country__c, propertyInDeal.City__c,
                propertyInDeal.Address__c, propertyInDeal.Latitude__c, propertyInDeal.Longitude__c);
        Property property = new Property(pId, ownerOfProp, locationWrapper);

        Info info = new Info(dt, sd, ed, client, property);

        return JSON.serialize(info);
    }
}