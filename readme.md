������ ������ ���� �������� ��������� ������.

1.� ������� ���������� ������� � AWS ��� Azure (�� �����);
2.� ������� Terraform ������, ������� ������������� 2 ����������� ������ (EC2 / VM). ���� �� �����;
3.� ������� Docker ����� �� ���� nginx, ������� ����� �������� ��� ������ ����������� �������� � ������������.- 
(�����������): �������� �������� �� �������� - ������� ��������� IP VM / EC2;
4.� ������� Ansible ������, ������� ����� ������������� �� ������ ���������� ���������� ������ �� ����� ��������� 
����������� �����;5.� ������� ������ ���� �������� �� ���� ��������.�� ����� ������� Terraform ���, �� ��������� � 
��������� EC2 / VM ���������������� ����������� � ������� Ansible.����� ���������� ������� ������� ������������ ���
������� � Git. ����������� ������ ��������� README.md ���� � ��������� ������� ��������� � ������������.


�����������
1. ������ AWS.
2. AWS_ACCESS_KEY_ID & SECRET_ACCESS_KEY ������������ AWS � ������� ��������������.
3. ����� SSH (public & private) ��� ������� � ���������.
4. ������������� � ����������� AWS CLI.

������������ ������� 

���� aws-ec2.tf
�������� ��������� -  AWS, ������ Frankfurt.
������ ��������� ��������� ��������
1 ������� ��������� AMI id Ubuntu linux � �������
2 ������� ���� (internet gateway), ������� �������������
3 ������� vpc & subnet � ������ � �������� ������������� �� � 2
4 ������� Sequrity group  � ��������� �������� ���������� �� ����� 80 (tcp)  22 (tcp), icmp all. ��������� - ��� ���������.
5 ����������� ��������� ���� (����������� ������� ����)
6 ������� 2 �������� t2.micro �� ������ image �� �1 � vps  & subnet �� �3 � ��������� IP � ������ SSH �� � 5 
� user_data ��������, ������� ���������� index.html �������� � IP ������� �������

ansible
���������� ������� ���� ������ � ansible\group_vars\web_servers, host.txt 
playbook docker.yml
������ ��������� ��������� ��������
1 ������������� ����������� ������: apt-transport-https, ca-certificates, curl, gnupg-agent
, software-properties-common
, 
python3-pip
2 ������������� docker
3 ������� �������� � �������� ����������� ����� �� ��������� ����������
4 ��������� docker � �������� ����������
5 ��������� ������������ ubuntu  � ������ docker

playbook img.yml
������ ��������� ��������� ��������
1 ������� ����������� ��������� ��������� � ��������� �� �������
2 ������������� Docker Module for Python
3 �� ������ nginx ������� image 
4 ��������� ��������� �� ������ image  �� � 3