from connect import Env
from connect import Flow
from connect import Logger
from connect import Processor
from connect.api import Query
from connect.models import Request


def add_dummy_data(p):
    p.setData('requestId', p.getRequest().id) \
        .setData('assetId', p.getRequest().asset.id) \
        .setData('connectionId', p.getRequest().asset.connection.id) \
        .setData('productId', p.getRequest().asset.product.id) \
        .setData('status', p.getRequest().status)


def trace_request_data(p):
    print(p.getData('requestId') \
        + ' : ' + p.getData('assetId') \
        + ' : ' + p.getData('connectionId') \
        + ' : ' + p.getData('productId') \
        + ' : ' + p.getData('status'))

def approve_request(p):
    pass
    # p.getRequest().approveByTemplate('TL-000-000-000')
    # p.getRequest().approveByTile('Markdown text')


if __name__ == '__main__':
    # Env.initLogger('log.md', Logger.LEVEL_ERROR, None)

    # Define main flow
    flow = Flow(None) \
        .step('Add dummy data', add_dummy_data) \
        .step('Trace request data', trace_request_data)

    # Process requests
    Processor() \
        .flow(flow) \
        .processRequests(Query() \
            .set('asset.product.id__in', Env.getConfig().getProductsString()) \
            .set('status', 'pending'))
