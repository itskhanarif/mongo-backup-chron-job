# Instructions to get backup
# STEPS:
## Fork this repository in your GitHub

### Install and Create mongoDB with Dummy data:

### Make the script executable

    chmod 700 mongodb-installer.sh
### Run the file to create database and collection

    ./setup_mongo.sh

### Install AWS CLI

    sudo apt install unzip
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install

### Configure AWS User Credentials
`aws configure`

### Create an S3 Bucket

    aws s3 mb s3://<your-bucket-name>

### Update Package Lists

    sudo apt-get update

### Install `mongodb-database-tools`. This package includes essential tools like `mongodump` and `mongorestore`.

    sudo apt install mongodb-database-tools

### Use IAM Role for EC2 (if you're running on an EC2 instance)
-   Go to the **IAM Console** in AWS.
-   Create an **IAM role** with the following permissions:
    -   `AmazonS3FullAccess` (or a custom policy granting permission to upload to your specific S3 bucket).
-   Attach the IAM role to your EC2 instance.


### Check bucket access:

    aws s3 ls s3://your-bucket-name

### Verify the Backup Process if backup-generator.sh is running smoothly and creating s3 backup

    sudo chmod 700 backup-generator.sh
    sudo ./backup-generator.sh

### Set Up a Cron Job to Run Every 2 or 5 or 10 Minutes

    */2 * * * * /path/to/backup-generator.sh >> /var/log/backup-generator.log 2>&1

### Monitor Cron Logs 

    grep CRON /var/log/syslog
