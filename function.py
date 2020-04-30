#
# Refer: https://r17n.page/2019/08/18/aws-docker-lambda-usage/
#

def my_handler(event, context):
    message = 'Hello {} {}!'.format(event['first_name'],
                                    event['last_name'])
    return {
        'message' : message
    }

