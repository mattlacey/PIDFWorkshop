public with sharing class ProximityAdExtension
{
    private final PRXI__Beacon__c beacon;
    public String adURL {get; private set;}

    // The extension constructor initializes the private member
    // variable mysObject by using the getRecord method from the standard
    // controller.
    public ProximityAdExtension(ApexPages.StandardController stdController)
    {
        beacon = (PRXI__Beacon__c)stdController.GetRecord();
        adURL = '';
    }

    public PageReference CheckForCustomer()
    {
        adURL = '';

        List<PRXI__Visit__c> v = [select Id, PRXI__Contact__c from PRXI__Visit__c where PRXI__Range__c != -1 and PRXI__Beacon__c = : beacon.Id order by PRXI__Range__c asc limit 1];
        if(v.Size() > 0)
        {
            List<Campaign> c = [select Id, Ad_URL__c from Campaign
                                where Id in  (select CampaignId from CampaignMember where ContactId = : v[0].PRXI__Contact__c) 
                                    and Ad_URL__c != '' and PRXI__Beacon__c = : beacon.Id
                                order by PRXI__Priority__c desc limit 1];

            if(c.Size() > 0)
            {
                adUrl = c[0].Ad_URL__c;
            }
        }

        return null;
    }
}