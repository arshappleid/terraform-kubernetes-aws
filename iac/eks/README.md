### Writing to the EFS File System
1. Mount to EC2 Instances , to the Access point for the drive
```
sudo mount -t efs -o tls,accesspoint=[AccessPointId] [FileSystemId] /mnt/efs
```
For the above command , AccessPoint ID , and FileSystemID will be outputted as part of ```terraform apply``` command.
