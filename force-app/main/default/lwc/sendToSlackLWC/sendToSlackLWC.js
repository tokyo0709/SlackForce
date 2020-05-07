import { LightningElement } from 'lwc';
import sendMessageToSlack from '@salesforce/apex/SendToSlackLWCController.sendMessageToSlack';

export default class SendToSlackLWC extends LightningElement {

    messageSent = false;

    sendMessageToSlack() {

        sendMessageToSlack({})
            .then(() => {

                this.messageSent = true;

            }).catch(error => {
                console.log(error);
            });
    }
}