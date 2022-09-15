#!/bin/bash
export STACKS=($(aws cloudformation list-stacks --query "StackSummaries[*].StackName" --stack-status-filter CREATE_COMPLETE --no-paginate --output text --region us-east-1))
echo Stack names: "${STACKS[@]}"
for i in "${STACKS[@]}"
do
	echo CHECKING : $i
	echo ID===>${i:19}

	if [[  $i =~ "6f95bfe"  ]]
	then 
		echo "	SKIP"
	else
		echo WILL REMOVE THIS : $i
		if [[ $i =~ "backend" ]]
		then 
			echo Removing BACKEND ${i:18}
			echo stack: aws cloudformation delete-stack --stack-name "udapeople-backend-${i:18}"
			aws cloudformation delete-stack --stack-name "udapeople-backend-${i:18}" --region us-east-1
		elif [[  $i =~ "frontend" ]]
		then 
			echo Removing FRONTEND ${i:19}
			echo bucket: aws s3 rb s3://${i:19} --force
			echo stack: aws cloudformation delete-stack --stack-name "udapeople-frontend-${i:19}" --region us-east-1
			#aws s3 rb s3://${i:19} --force
			aws cloudformation delete-stack --stack-name "udapeople-frontend-${i:19}" --region us-east-1
		else 
			echo "	UNKNOWN STACK"
		fi 
	fi 
	
done
