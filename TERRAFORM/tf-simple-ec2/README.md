this is a normal terraform file to create a new ec2 instance with following configurations 
* default vpc
* custom sg that allows following ingress
    - SSH:22
    - HTTP:80
    - HTTPS:443
* a custom keygen given by user generated in his node
* uses the zone eu-north-1
* the server it creates has following configurations 
    - image: ubuntu
    - instance_type: t3_micro
    - volume: EBS
    - capacity: 8GB
    - type: gp3
    - tenency: default
* file also run the commands given by user
* file also produces an output that is ip, dns and private ip of instance