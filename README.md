A vagrant/puppet vm for packagist

Installs everything required for packagist

Usage:

install vagrant

install virtualbox

clone repository

navigate to directory and type vagrant up

register new application "packagist-dev" at https://github.com/settings/applications

type vagrant ssh

type cp /packagist/app/config/parameters.yml.dst /packagist/app/config/parameters.yml

type vi !$

uncomment packagist_host and add packagist.dev.local
uncomment route.* change https to http

add github.client_id / github/client_secret as created for new application packagist-dev earlier

type composer install -d /packagist/

vi /packagist/web/app_dev and add ip address of connecting host to allowed array

add host on local machine (/etc/hosts/) 127.0.0.1 packagist.dev.local

browse to 127.0.0.1:8081 to see packagist
