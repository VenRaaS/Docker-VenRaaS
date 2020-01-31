#!/bin/bash                                                                                                        
                                                                                                                   
CODE_NAME=$1
CODE_NAME=$(echo "$CODE_NAME" | tr '[:upper:]' '[:lower:]')
                                            
gsutil mb -c regional -l asia-east1 gs://ven-cust-${CODE_NAME}

# gcloud pubsub subscriptions create pull_bucket_ven-custs --topic bucket_ve
n-custs
gsutil notification create -t bucket_ven-custs -f json gs://ven-cust-${CODE_NAME}

CODE_NAME=$(echo "$CODE_NAME" | tr -d '-')                                                                         

bq mk --data_location US ${CODE_NAME}_unima                                                                        
bq mk --data_location US ${CODE_NAME}_results                                                                      
bq mk --data_location US ${CODE_NAME}_tmp                                                                          
                                                

