#!/bin/bash

ENV=$1
terraform destroy -var-file="${ENV}.tfvars"
