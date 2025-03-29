#!/bin/bash

ENV=$1
terraform apply -var-file="${ENV}.tfvars"
