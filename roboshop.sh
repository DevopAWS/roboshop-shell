#!/bin/bash

#AMI-ID=ami-03265a0778a880afb
#SG-ID=sg-039cc2fb5a7846012
INSTANCES=("mongodb" "mysql" "rabbitmq" "catalogue" "user" "cart" "reddis" "shipping" "payment" "web")
ZONE_ID=Z02572582AYLBU30KSIJ8
DOMAIN_NAME="daws76.online"


for i in "${INSTANCES[@]}"
do 
    if [ $i == "mongodb" ] || [ $i == "mysql" ] || [ $i == "shipping" ]
    then
        INSTANCES_TYPE="t3.small"
    else
        INSTANCES_TYPE="t2.micro"
    fi

    IP_ADDRESS=$(aws ec2 run-instances --image-id ami-03265a0778a880afb  --instance-type $INSTANCES_TYPE --security-group-ids sg-039cc2fb5a7846012 --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]" --query 'Instances[0].PrivateIpAddress' --output text)
    
    echo "$i: $IP_ADDRESS"

aws route53 change-resource-record-sets \
  --hosted-zone-id $ZONE_ID \
  --change-batch '
    {
        "Comment": "Creating a record set for cognito endpoint"
        ,"Changes": [{
        "Action"              : "CREATE"
        ,"ResourceRecordSet"  : {
            "Name"              : "'$i'.'$DOMAIN_NAME'"
            ,"Type"             : "A"
            ,"TTL"              : 1
            ,"ResourceRecords"  : [{
                "Value"         : "'$IP_ADDRESS'"
            }]
        }
        }]
    }
        '

done




