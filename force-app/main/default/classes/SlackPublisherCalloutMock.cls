@isTest
public class SlackPublisherCalloutMock implements HttpCalloutMock {

    public HTTPResponse respond(HttpRequest req) {
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setStatusCode(200);

        res.setBody('{ "success": true }');

        return res;
    }
}