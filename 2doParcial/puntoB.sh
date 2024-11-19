vagrant@vmAMN316:~$
#verifico address
ip address show
#genero llave
ssh-keygen
#ver llaves publica y privada
ll .ssh/
#copio llave publica
cat .ssh/id_rsa.pub

vagrant@vmAnsDev316:~$
#pego llave publica
ll .ssh/
vim .ssh/authorized_keys

vagrant@vmAMN316:~$
#verifico address
ip address show
#me conecto al host
ssh vagrant@192.168.56.9
#clono repo ansible
git clone https://github.com/upszot/UTN-FRA_SO_Ansible.git
#modifico ejemplo 2
vim inventory
[testing]


[desarrollo]
192.168.56.9


[produccion]

vim playbook.yml
---
- hosts:
    - all
  tasks:
    - name: "Set WEB_SERVICE dependiendo de la distro"
      set_fact:
        WEB_SERVICE: "{% if   ansible_facts['os_family']  == 'Debian' %}apache2
                      {% elif ansible_facts['os_family'] == 'RedHat'  %}httpd
                      {% endif %}"

    - name: "Muestro nombre del servicio:"
      debug:
        msg: "nombre: {{ WEB_SERVICE }}"

    - name: "Run the equivalent of 'apt update' as a separate step"
      become: yes
      ansible.builtin.apt:
        update_cache: yes
      when: ansible_facts['os_family'] == "Debian"

    - name: "Instalando apache "
      become: yes
      package:
        name: "{{ item }}"
        state: present
      with_items:
        - "{{ WEB_SERVICE }}"

#ejecutamos ansible 
ansible-playbook -i inventory playbook.yml

vagrant@vmAnsDev316:~$
#compruebo si se instalo en el host
sudo apt list --installed |grep apache

apache2-bin/jammy-updates,jammy-security,now 2.4.52-1ubuntu4.12 amd64 [installed,automatic]
apache2-data/jammy-updates,jammy-security,now 2.4.52-1ubuntu4.12 all [installed,automatic]
apache2-utils/jammy-updates,jammy-security,now 2.4.52-1ubuntu4.12 amd64 [installed,automatic]
apache2/jammy-updates,jammy-security,now 2.4.52-1ubuntu4.12 amd64 [installed]
