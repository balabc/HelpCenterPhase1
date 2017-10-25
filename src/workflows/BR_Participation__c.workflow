<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Send_Reminder_Before_24_hours</fullName>
        <description>Send Reminder Before 24 hours</description>
        <protected>false</protected>
        <recipients>
            <field>User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>BrAC_Event_Email_Templates/BrEvent_reminders</template>
    </alerts>
    <alerts>
        <fullName>Send_Reminder_Before_7_days</fullName>
        <description>Send Reminder Before 7 days</description>
        <protected>false</protected>
        <recipients>
            <field>User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>BrAC_Event_Email_Templates/BrEvent_reminders</template>
    </alerts>
    <alerts>
        <fullName>Send_email_before_1_hour</fullName>
        <description>Send email before 1 hour</description>
        <protected>false</protected>
        <recipients>
            <field>User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>BrAC_Event_Email_Templates/BrEvent_reminders</template>
    </alerts>
    <rules>
        <fullName>Send event reminders before 1 hour</fullName>
        <active>true</active>
        <formula>AND(ISPICKVAL(Participate__c , &apos;YES&apos;), BR_Event__r.Send_reminders__c = true,
BR_Event__r.Start_Date__c &gt; NOW() + 0.0416667, TriggerSendReminderWorkflow__c = true 
)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Send_email_before_1_hour</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>BR_Participation__c.Event_Start_Date__c</offsetFromField>
            <timeLength>-1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Send event reminders before 24 hours</fullName>
        <active>true</active>
        <formula>AND(ISPICKVAL(Participate__c, &apos;YES&apos;), BR_Event__r.Send_reminders__c = true, 
BR_Event__r.Start_Date__c &gt; NOW() + 1, 
TriggerSendReminderWorkflow__c = true)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Send_Reminder_Before_24_hours</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>BR_Participation__c.Event_Start_Date__c</offsetFromField>
            <timeLength>-1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Send event reminders before 7 days</fullName>
        <active>true</active>
        <formula>AND(ISPICKVAL(Participate__c, &apos;YES&apos;), BR_Event__r.Send_reminders__c = true, 
BR_Event__r.Start_Date__c &gt; NOW() + 7, 
TriggerSendReminderWorkflow__c = true)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Send_Reminder_Before_7_days</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>BR_Participation__c.Event_Start_Date__c</offsetFromField>
            <timeLength>-7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
