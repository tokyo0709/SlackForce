@isTest
private class SlackPublisherTest {
    
    @IsTest static void slackPublisherFullBuild_BuildAndSendRequest_IfValidData() {
    
        // ARRANGE
        test.setMock(HttpCalloutMock.class, new SlackPublisherCalloutMock());
    
        // ACT
        test.startTest();
        HttpResponse response = SlackPublisher.start()
            .setUrl('https://www.google.com')
            .setNotificationText('TEST NOTIFICATION')
            .addTextBlock('TEST', true)
            .addDivider()
            .addCodeBlock('TEST CODE BLOCK')
            .post();
        test.stopTest();
    
        // ASSERT
        System.assert(response != null);
    }
}