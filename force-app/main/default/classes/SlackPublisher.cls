public class SlackPublisher {

    private MessageBuilder currentMessage;

    private SlackPublisher(MessageBuilder message) {
        this.currentMessage = message;
    }

    // Entry point builder method to start composing object attributes
    public static SlackPublisher start() {
        return new SlackPublisher(
            new MessageBuilder()
        );
    }

    // Entry point builder method to modify a slack message
    public static SlackPublisher modify(MessageBuilder message) {
        return new SlackPublisher(
            message
        );
    }

    public SlackPublisher setNotificationText(String text) {
        currentMessage.text = text;
        return this;
    }

    public SlackPublisher addContext(List<Element> elements) {

        Block newBlock = new Block();
        newBlock.type = 'context';
        newBlock.elements = elements;

        currentMessage.blocks.add(newBlock);

        return this;
    }

    public SlackPublisher addTextBlock(String text) {

        Block newBlock = new Block();
        newBlock.text = new Text();
        newBlock.type = 'section';
        newBlock.text.text = text;
        newBlock.text.type = 'mrkdwn';

        currentMessage.blocks.add(newBlock);
        return this;
    }

    public SlackPublisher addTextBlockWithImage(String text, Element imageElement) {

        Block newBlock = new Block();
        newBlock.text = new Text();
        newBlock.type = 'section';
        newBlock.text.text = text;
        newBlock.accessory = imageElement;
        newBlock.text.type = 'mrkdwn';

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

    public HttpResponse post(String url) {

        if (String.isEmpty(url)) { throw new CustomExceptions.RequiredInputException('A Url must be provided to post a Slack message'); }
        if (this.currentMessage.blocks.isEmpty()) { throw new CustomExceptions.RequiredInputException('At least one block must be provided to post a Slack message'); }

        System.debug('MESSAGE TO POST');
        System.debug(JSON.serialize(this.currentMessage));

        HttpRequest request = new HttpRequest();
        request.setEndpoint(url);
        request.setMethod('POST');
        request.setBody(JSON.serialize(this.currentMessage, true));
        Http http = new Http();
        HttpResponse response = http.send(request);

        System.debug(response);
        return response;
    }

    public MessageBuilder retrieve() {
        return this.currentMessage;
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
        public Element accessory { get; set; }
        public List<Element> elements { get; set; }
    }

    public class Text {
        public String type { get; set; }
        public String text { get; set; }
    }

    public class Element {
        public String type { get; set; }
        public String image_url { get; set; }
        public String alt_text { get; set; }
        public String text { get; set; }
    }

    public static Element imageElement(String imageUrl, String altText){
        
        Element imageElement = new Element();
        imageElement.type = 'image';
        imageElement.image_url = imageUrl;
        imageElement.alt_text = altText;

        return imageElement;
    }

    public static Element textElement(String text){
        
        Element textElement = new Element();
        textElement.type = 'mrkdwn';
        textElement.text = text;

        return textElement;
    }
}