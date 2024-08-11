import boto3
import json 
 
POLICY_FILE_NAME = f"./policy.json"
POLICY_NAME = "S3-Administrator-Policy"
USER_NAME = 'user_test_6'

# Initialize the IAM client
iam = boto3.client('iam')

# create iam user and policy
def create_iam_user(policy_file_name,policy_name,user_name):
    # Create IAM user
    response = iam.create_user(UserName=user_name)
    print("IAM User created:", response['User']['UserName'])
    policy_document = open(policy_file_name, "r")
    
    response = iam.create_policy(
        PolicyName=policy_name,
        PolicyDocument=json.dumps(json.load(policy_document))
    )
    
    policy_arn = response['Policy']['Arn']
    print("IAM Policy created:", policy_arn)
    
    # Attach the policy to the user
    iam.attach_user_policy(
        UserName=user_name,
        PolicyArn=policy_arn
    )
    
    print(f"Policy attached to the user {user_name}")

def list_iam_user():
    # List all IAM users
    response_users = iam.list_users()
    
    if 'Users' in response_users:
        users = response_users['Users']
        for user in users:
            user_name = user['UserName']
            print(f"IAM User: {user_name}")
            
            # List attached policies for the user
            response_policies = iam.list_attached_user_policies(UserName=user_name)
            if 'AttachedPolicies' in response_policies:
                attached_policies = response_policies['AttachedPolicies']
                for policy in attached_policies:
                    policy_name = policy['PolicyName']
                    print(f"  Attached Policy: {policy_name}")
            else:
                print("  No attached policies for this user.")
    
            print()
    else:
        print("No IAM users found.")


def main() -> None:
    create_iam_user(POLICY_FILE_NAME,POLICY_NAME,USER_NAME)
    list_iam_user()

main()