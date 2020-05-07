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

        SlackPublisher.MessageBuilder slackMessage = SlackPublisher.start()
            .setNotificationText('Snowforce is coming up! :snowflake:')
            .addTextBlock('*Upcoming Event*')
            .addDivider()
            .addTextBlockWithImage('*<https://www.snowforce.io|Snowforce>*\nTuesday, February 26th 8:00am-4:30pm\nUtah Cultural Celebration Center\n1355 West 3100 South, West Valley City, UT 84119', 
                SlackPublisher.imageElement('https://api.slack.com/img/blocks/bkb_template_images/notifications.png', 'calendar'))
            .addContext(new List<SlackPublisher.Element> { 
                SlackPublisher.imageElement('https://api.slack.com/img/blocks/bkb_template_images/notificationsWarningIcon.png', 'warning'),
                SlackPublisher.textElement('*Conflicting Appointment:* Team Sync 3:00-4:00')
            })
            .retrieve();

        SlackPublisher.modify(slackMessage)
            .addDivider()
            .addTextBlock('Check the #general channel for more details on availability for <@U011M81G3AS>')
            .post(url);
    }
}
