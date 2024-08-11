import json
import uuid
 
GET_RAW_PATH = "/test/getPerson"
CREATE_RAW_PATH = "/test/createPerson"
 
def lambda_handler(event, context):
    print(event)
    if event['rawPath'] == GET_RAW_PATH:
        # GetPerson Path
        print("Lambda receive Request for getPerson")
        #personId = event['queryStringParameters']['personId']
        #print("Lambda receive Request with personID =" + personId)
        return { "firstName" : "Nguyen" , "lasteName": "Van A", "email":"abc@gmail.com"}
    elif event['rawPath'] == CREATE_RAW_PATH:
        print("Lambda receive Request for createPerson")

        return { "personId" : str(uuid.uuid1())}

 
 