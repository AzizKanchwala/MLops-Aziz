012558362614.dkr.ecr.us-east-1.amazonaws.com/mlproj
terraform output -raw public_ip >> ../ansible/ec2_ip.txt
ansible-playbook playbook.yaml -i ec2_ip.txt -u ubuntu --private-key ../mlproj-key.pem -vvvv