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


## Packging
```
$ docker run --rm -v "$PWD":/var/task aws-lambda-python3.6-test:latest
WARNING: You are using pip version 20.0.2; however, version 20.1 is available.
You should consider upgrading via the '/var/lang/bin/python3.6 -m pip install --upgrade pip' command.
  adding: function.py (deflated 35%)
updating: function.py (deflated 35%)
  adding: Dockerfile (deflated 21%)
  adding: README.md (deflated 54%)
  adding: __pycache__/ (stored 0%)
  adding: __pycache__/function.cpython-36.pyc (deflated 22%)
  adding: requirements.txt (stored 0%)

$ unzip -Z ./deploy_package.zip 
Archive:  ./deploy_package.zip
Zip file size: 2630 bytes, number of entries: 6
-rw-r--r--  3.0 unx      261 tx defX 20-Apr-30 21:36 function.py
-rw-r--r--  3.0 unx      229 tx defX 20-Apr-30 21:39 Dockerfile
-rw-r--r--  3.0 unx     2330 tx defX 20-Apr-30 21:52 README.md
drwxr-xr-x  3.0 unx        0 bx stor 20-Apr-30 21:31 __pycache__/
-rw-r--r--  3.0 unx      297 bx defX 20-Apr-30 21:31 __pycache__/function.cpython-36.pyc
-rw-r--r--  3.0 unx        0 bx stor 20-Apr-30 21:54 requirements.txt
6 files, 3117 bytes uncompressed, 1654 bytes compressed:  46.9%
```


## Deploy
1: Create a new role for lambda execution
2: Create a new user for deploy operation
3: Edit config and credential files

```
$ aws lambda create-function \
  --function-name docker-lambda-python-test \
  --zip-file fileb://deploy_package.zip \
  --handler function.my_handler \
  --runtime python3.6 \
  --timeout 10 \
  --memory-size 256 \
  --role arn:aws:iam::xxxxx:role/docker-lambda-exec-role \
  --profile docker-lambda-deploy
{
    "CodeSha256": "++Fs6HmIAl9oDllAhCJwLJE2UlkLSK0JloLc0a7SOJA=",
    "FunctionName": "docker-lambda-python-test",
    "CodeSize": 2630,
    "MemorySize": 256,
    "FunctionArn": "arn:aws:lambda:us-east-1:xxxxx:function:docker-lambda-python-test",
    "Version": "$LATEST",
    "Role": "arn:aws:iam::xxxxx:role/docker-lambda-exec-role",
    "Timeout": 10,
    "LastModified": "2020-05-05T10:32:44.260+0000",
    "Handler": "function.my_handler",
    "Runtime": "python3.6",
    "Description": ""
}
```

```
$ aws lambda update-function-code \
  --function-name docker-lambda-python-test \
  --zip-file fileb://deploy_package.zip \
  --profile docker-lambda-deploy
{
    "CodeSha256": "++Fs6HmIAl9oDllAhCJwLJE2UlkLSK0JloLc0a7SOJA=",
    "FunctionName": "docker-lambda-python-test",
    "CodeSize": 2630,
    "MemorySize": 256,
    "FunctionArn": "arn:aws:lambda:us-east-1:xxxxx:function:docker-lambda-python-test",
    "Version": "$LATEST",
    "Role": "arn:aws:iam::xxxxx:role/docker-lambda-exec-role",
    "Timeout": 10,
    "LastModified": "2020-05-05T10:48:09.197+0000",
    "Handler": "function.my_handler",
    "Runtime": "python3.6",
    "Description": ""
}
```

