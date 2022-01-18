#!/bin/bash

TOEXIT=0
if [ -z "$S3_BUCKET_NAME" ]
then
    echo "\$S3_BUCKET_NAME required to be set"
    TOEXIT=1
fi
if [ -z "$S3_REGION"  ]
then
    echo "\$S3_REGION required to be set"
    TOEXIT=1
fi
if [ -z "$S3_REGION_ENDPOINT"  ]
then
    echo "\$S3_REGION_ENDPOINT required to be set"
    TOEXIT=1
fi
if [ $TOEXIT -eq 1 ]
then
    exit 1
fi

docker build . -t s3-ipfs:latest \
    --build-arg S3_BUCKET_NAME=$S3_BUCKET_NAME \
    --build-arg S3_REGION=$S3_REGION \
    --build-arg S3_REGION_ENDPOINT=$S3_REGION_ENDPOINT
