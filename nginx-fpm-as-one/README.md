# Build and deploy a containerized PHP application using Jenkins, Docker, Ansible

### Introduction
This project includes a Jenkinsfile and Ansible playbooks, with which you can implement CI/CD for PHP applications.

### Prerequisite
- Jenkins with Pipeline, Docker plugins installed
- Ansible with Docker python module installed
- Docker
- Docker Registry or Docker Hub

### Ansible playbook to build runtime and base app Docker image
```
ansible-playbook ${env.WORKSPACE}/${env.ANSIBLE_PLAYBOOK_DIR_NAME}/nginx-fpm-as-one/build-php-images.yml  \
--extra-vars 'jenkin_workspace=${env.WORKSPACE}/ \
workspace_code_dir_name=${env.APP_CODE_DIR_NAME} \
workspace_ansible_dir_name=${env.ANSIBLE_PLAYBOOK_DIR_NAME}'
```
This playbook creates one Docker image with Nginx and PHP-FPM installed for running PHP-backed web applications and 
another Docker image which will be used in the the next build to speed up installing PHP packages.

### Ansible playbook to build a new version Docker image for PHP applications
```
ansible-playbook  ${env.WORKSPACE}/${env.ANSIBLE_PLAYBOOK_DIR_NAME}/nginx-fpm-as-one/build-php-app-images.yml  \
--extra-vars 'jenkin_workspace=${env.WORKSPACE}/ \
 workspace_code_dir_name=${env.APP_CODE_DIR_NAME} \
 workspace_ansible_dir_name=${env.ANSIBLE_PLAYBOOK_DIR_NAME} '
```
This playbook creates a Docker image and copies PHP codes in the workspace of Jenkins into the image and then pushs the image
to Docker Registry

### Ansible playbook to run the new version Docker image for PHP applications
```
ansible-playbook -i ${env.WORKSPACE}/${env.ANSIBLE_ENVIRONMENT_DIR_NAME}/dev/hosts \
${env.WORKSPACE}/${env.ANSIBLE_PLAYBOOK_DIR_NAME}/nginx-fpm-as-one/deploy-php.yml   \
-u ${userName} \
--private-key ${keyfile}
```
This playbook does as follows:   
- Pulling the new version image on the remote server.
- Generating a .env file and uploading the .env file to the remote server.
- Stoping the running container.
- Creating a new container on the remote server.
- Running the newly created container.


### TODO
- A playbook used to roll back to previous version 