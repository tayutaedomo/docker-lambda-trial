# docker-lambda-trial

## Refer
https://r17n.page/2019/08/18/aws-docker-lambda-usage/

## Run
```
$ docker run --rm -v "$PWD":/var/task lambci/lambda:python3.6 function.my_handler '{"first_name": "Taro", "last_name": "Yamada”}''"}'
```

