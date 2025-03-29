#!/bin/bash

ENV=$1
terraform plan -var-file="${ENV}.tfvars"
