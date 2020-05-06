import { LightningElement } from 'lwc';
import sendMessageToSlack from '@salesforce/apex/SendToSlackLWCController.sendMessageToSlack';

export default class SendToSlackLWC extends LightningElement {

    sendMessageToSlack() {

        sendMessageToSlack({})
            .then((result)) => {

            }).catch(error => {
                console.log(error);
            });
    }
}