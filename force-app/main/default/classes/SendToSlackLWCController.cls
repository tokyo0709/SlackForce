public class SendToSlackLWCController {
    
    @AuraEnabled
    public static void sendMessageToSlack() {

        String slackUrlSettingName = 'Main';
        List<SlackWebhookUrl__mdt> slackWebhookUrl = [
            SELECT DeveloperName, Url__c
            FROM SlackWebhookUrl__mdt
            WHERE DeveloperName = :slackUrlSettingName
        ];

        String url = slackWebhookUrl[0].Url__c;

        SlackPublisher.start()
            .setUrl(url)
            .setNotificationText('Failure to setup Account in Salesforce')
            .addTextBlock('A request to setup an Account in Salesforce has failed. The following is error and raw request of the failure.', true)
            .addDivider()
            .addTextBlock('*Error Message - 400*', true)
            .addCodeBlock('Some Error Code Message')
            .post();
    }
}
