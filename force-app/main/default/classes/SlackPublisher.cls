public with sharing class SlackPublisher {

    private MessageBuilder currentMessage;
    private String currentUrl;

    private SlackPublisher(MessageBuilder message) {
        this.currentMessage = message;
    }

    // Entry point builder method to start composing object attributes
    public static SlackPublisher start() {
        return new SlackPublisher(
            new MessageBuilder()
        );
    }

    public SlackPublisher setUrl(String url) {
        this.currentUrl = url;
        return this;
    }

    public SlackPublisher setNotificationText(String text) {
        currentMessage.text = text;
        return this;
    }

    public SlackPublisher addTextBlock(String text, Boolean withMarkdown) {

        Block newBlock = new Block();
        newBlock.text = new Text();
        newBlock.type = 'section';
        newBlock.text.text = text;
        if (withMarkdown) { newBlock.text.type = 'mrkdwn'; }

        currentMessage.blocks.add(newBlock);
        return this;
    }

    public SlackPublisher addCodeBlock(String text) {

        Block newBlock = new Block();
        newBlock.text = new Text();
        newBlock.type = 'section';
        newBlock.text.text = '```' + text + '```';
        newBlock.text.type = 'mrkdwn';

        currentMessage.blocks.add(newBlock);
        return this;
    }

    public SlackPublisher addDivider() {
        Block newBlock = new Block();
        newBlock.type = 'divider';

        currentMessage.blocks.add(newBlock);
        return this;
    }

    public HttpResponse post() {

        if (String.isBlank(this.currentUrl)) { throw new CustomExceptions.RequiredInputException('A Url must be provided to post a Slack message'); }
        if (this.currentMessage.blocks.isEmpty()) { throw new CustomExceptions.RequiredInputException('At least one block must be provided to post a Slack message'); }

        System.debug(JSON.serialize(this.currentMessage));

        HttpRequest request = new HttpRequest();
        request.setEndpoint(this.currentUrl);
        request.setMethod('POST');
        request.setBody(JSON.serialize(this.currentMessage, true));
        Http http = new Http();
        HttpResponse response = http.send(request);

        System.debug(response);
        return response;
    }

    public class MessageBuilder {

        public MessageBuilder() {
            blocks = new List<Block>();
        }

        public String text { get; set; }
        public List<Block> blocks { get; set; }
    }

    public class Block {
        public String type { get; set; }
        public Text text { get; set; }
    }

    public class Text {
        public String type { get; set; }
        public String text { get; set; }
    }
}