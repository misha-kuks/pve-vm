# pve-vm
Deploy VMs on PVE by terraform 
This manifest deploy ubuntu VMs on PVE cluster.
Preconfig your PVE node to use cloudimg.
Download image 
1. wget https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img
Install libguestfs-tools
2. apt install libguestfs-tools -y
Prepare 
3. virt-customize -a focal-server-cloudimg-amd64.img --install qemu-guest-agent
4. qm create 700 --name "ubuntu-focal64" --memory 2048 --cores 2 --net0 virtio,bridge=vmbr0
5. qm importdisk 700 focal-server-cloudimg-amd64.img SSD
Next steps you can do in web interface
6. qm set 700 --scsihw virtio-scsi-pci --virtio0 SSD:vm-700-disk-0.raw 
7. qm set 700 --boot c --bootdisk virtio0
8. qm set 700 --ide2 SSD:cloudinit
9. qm set 700 --agent enabled=1
10. qm template 700

Now we have template of ubuntu-focal64 server. 
In cloud-init section change subnet ip address. 
To deploy VMs you should create your own file terraform.tfvars which include:

1. nano terraform.tfvars

pve_ip_address = "IPv4"
pm_user = "root@pam" 
pm_password = "PASSWORD"
proxmox_host = "HOSTNAME"
template = "ubuntu-focal64"
storage = "STORAGE"

3. Open variables.tf and put your ssh key into section ssh_keys.
4. terraform init
5. terraform apply
