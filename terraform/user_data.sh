#!/bin/bash
sudo apt update -y
sudo apt install python3-pip python3-venv git -y

cd /home/ubuntu
git clone https://github.com/AnushkaSandbhor/Smart_Inventory.git app
cd app

python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt

python manage.py migrate
nohup python manage.py runserver 0.0.0.0:8000 &
