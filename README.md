# docker-lambda-trial

## Refer
https://r17n.page/2019/08/18/aws-docker-lambda-usage/


## Run
```
$ docker run --rm -v "$PWD":/var/task lambci/lambda:python3.6 function.my_handler '{"first_name": "Taro", "last_name": "Yamada”}''"}'
function.my_handler '{"first_name": "Taro", "last_name": "Yamada”}'
Unable to find image 'lambci/lambda:python3.6' locally
python3.6: Pulling from lambci/lambda
a981bd693b45: Pull complete
dec961664731: Pull complete
8e95c64814bc: Pull complete
8792a0d5896f: Pull complete
0fe20c0bc990: Pull complete
Digest: sha256:9d819f36cb0f088b67a7abe1c53fb7fbc64511780cda23c86659490795316b08
Status: Downloaded newer image for lambci/lambda:python3.6
START RequestId: 3c00c07e-add6-1ab4-2b88-2c0050539dfb Version: $LATEST
END RequestId: 3c00c07e-add6-1ab4-2b88-2c0050539dfb
REPORT RequestId: 3c00c07e-add6-1ab4-2b88-2c0050539dfb  Init Duration: 179.09 ms        Duration: 3.46 ms      Billed Duration: 100 ms Memory Size: 1536 MB        Max Memory Used: 27 MB

{"message":"Hello Taro Yamada!"}'"}'
```


## Build
```
$ docker build -t aws-lambda-python3.6-test .
Sending build context to Docker daemon  81.41kB
Step 1/5 : FROM lambci/lambda:build-python3.6
build-python3.6: Pulling from lambci/lambda
a981bd693b45: Already exists
ed1625cf7f8d: Pull complete
ff82aa764429: Pull complete
f5f9d5a05a09: Pull complete
Digest: sha256:d19e72a6d17d4f3aa92d721caaee2457450849c9dec60a409b125358192f5a48
Status: Downloaded newer image for lambci/lambda:build-python3.6
 ---> a54602850ea8
Step 2/5 : ENV LANG C.UTF-8
 ---> Running in 7e46eac067f9
Removing intermediate container 7e46eac067f9
 ---> eea52e08c550
Step 3/5 : ENV AWS_DEFAULT_REGION us-east-1
 ---> Running in ce7a49bb5322
Removing intermediate container ce7a49bb5322
 ---> 8f29d5f9164e
Step 4/5 : ADD . .
 ---> 5e2ca4cd1226
Step 5/5 : CMD pip3 install -r requirements.txt -t /var/task &&   zip -9 deploy_package.zip function.py &&     zip -r9 deploy_package.zip *
 ---> Running in 93e0ad1c85fd
Removing intermediate container 93e0ad1c85fd
 ---> faeb7e6b0b91
Successfully built faeb7e6b0b91
Successfully tagged aws-lambda-python3.6-test:latest

$ docker images
REPOSITORY                  TAG                 IMAGE ID            CREATED             SIZE
aws-lambda-python3.6-test   latest              faeb7e6b0b91        3 minutes ago       2.1GB
```

