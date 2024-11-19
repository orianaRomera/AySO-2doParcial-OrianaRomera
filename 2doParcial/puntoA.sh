NAME                          MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
loop0                           7:0    0   64M  1 loop /snap/core20/2379
loop1                           7:1    0 63.7M  1 loop /snap/core20/2434
loop2                           7:2    0   87M  1 loop /snap/lxd/29351
loop3                           7:3    0  4.4M  1 loop /snap/tree/54
loop4                           7:4    0 38.8M  1 loop /snap/snapd/21759
loop5                           7:5    0 74.2M  1 loop /snap/core22/1621
loop6                           7:6    0 73.9M  1 loop /snap/core22/1663
sda                             8:0    0   40G  0 disk
└─sda1                          8:1    0   40G  0 part /
sdb                             8:16   0   10M  0 disk
sdc                             8:32   0   10G  0 disk
├─sdc1                          8:33   0    1G  0 part
├─sdc2                          8:34   0    1G  0 part
├─sdc3                          8:35   0    1G  0 part
└─sdc4                          8:36   0    1K  0 part
sdd                             8:48   0   10G  0 disk
├─sdd1                          8:49   0    1G  0 part [SWAP]
├─sdd2                          8:50   0    1G  0 part
│ └─vgAdmin-lvAdmin           253:3    0  1.5G  0 lvm  /mnt/lvAdmin
├─sdd3                          8:51   0    1G  0 part
│ └─vgAdmin-lvAdmin           253:3    0  1.5G  0 lvm  /mnt/lvAdmin
├─sdd4                          8:52   0    1K  0 part
├─sdd5                          8:53   0  1.5G  0 part
│ ├─vgDevelopers-lvDevelopers 253:0    0    1G  0 lvm  /mnt/lvDevelopers
│ └─vgDevelopers-lvDevops     253:2    0  820M  0 lvm  /mnt/lvDevops
└─sdd6                          8:54   0  1.3G  0 part
  ├─vgDevelopers-lvTester     253:1    0    1G  0 lvm  /mnt/lvTesters
  └─vgDevelopers-lvDevops     253:2    0  820M  0 lvm  /mnt/lvDevops


#destinar particion 1 como swap
sudo mkswap /dev/sdd1
#habilitar swap
sudo swapon /dev/sdd1
#crear pv
sudo pvcreate /dev/sdd2 /dev/sdd3 /dev/sdd5 /dev/sdd6
#crear vg
sudo vgcreate vgAdmin /dev/sdd2 /dev/sdd3
sudo vgcreate vgDevelopers /dev/sdd5 /dev/sdd6
#crear lv
sudo lvcreate -L 1G vgDevelopers -n lvDevelopers
sudo lvcreate -L 1G vgDevelopers -n lvTester
sudo lvcreate -L 0.9G vgDevelopers -n lvDevops
sudo lvcreate -L 1.8G vgAdmin -n lvAdmin
#formatear
sudo mkfs.ext4 /dev/mapper/vgDevelopers-lvDevelopers
sudo mkfs.ext4 /dev/mapper/vgDevelopers-lvTester
sudo mkfs.ext4 /dev/mapper/vgDevelopers-lvDevops
sudo mkfs.ext4 /dev/mapper/vgAdmin-lvAdmin
#montar
sudo mkdir /mnt/lvDevelopers
sudo mkdir /mnt/lvTester
sudo mkdir /mnt/lvDevops
sudo mkdir /mnt/lvAdmin

sudo mount /dev/mapper/vgDevelopers-lvDevelopers /mnt/lvDevelopers
sudo mount /dev/mapper/vgDevelopers-lvTester /mnt/lvTester
sudo mount /dev/mapper/vgDevelopers-lvDevops /mnt/lvDevops
sudo mount /dev/mapper/vgAdmin-lvAdmin /mnt/lvAdmin

