FROM lambci/lambda:build-python3.6
ENV LANG C.UTF-8
ENV AWS_DEFAULT_REGION us-east-1

ADD . .

CMD pip3 install -r requirements.txt -t /var/task && \
  zip -9 deploy_package.zip function.py && \
    zip -r9 deploy_package.zip *
