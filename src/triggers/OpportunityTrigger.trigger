trigger OpportunityTrigger on Opportunity (after delete, after insert, after update, 
before delete, before insert, before update) {
    TriggerFactory.createAndExecuteHandler(OpportunityHandler.class);
}