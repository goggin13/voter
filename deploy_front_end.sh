source .deployer_credentials
aws s3 cp voter-front/ s3://voter-front-end/ --acl public-read --recursive
