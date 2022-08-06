import base64
import logging

import boto3
from botocore.exceptions import ClientError


AWS_REGION = 'us-east-1'
SECRET = 'my_db_pass'
KEY_ALIAS = 'alias/my-key'

# logger config
logger = logging.getLogger()
logging.basicConfig(level=logging.INFO,
                    format='%(asctime)s: %(levelname)s: %(message)s')
                    
#COMPLETE WITH YOUR PROFILE NAME
boto3.setup_default_session(profile_name='')
kms_client = boto3.client("kms", region_name=AWS_REGION)


def encrypt(secret, alias):
    try:
        cipher_text = kms_client.encrypt(
            KeyId=alias,
            Plaintext=bytes(secret, encoding='utf8'),
        )
    except ClientError:
        logger.exception('Could not encrypt the string.')
        raise
    else:
        return base64.b64encode(cipher_text["CiphertextBlob"])


if __name__ == '__main__':
    
    logger.info('Encrypting...')
    kms = encrypt(SECRET, KEY_ALIAS).decode('utf-8') 
    pass_file = open("mypass.txt", "w") 
    pass_file.write(f'{kms}')
