from connect import Env
from connect import Logger
from connect import Processor
from connect.api import QueryParams
from connect.models import Request


def add_dummy_data(p, _):
    p.setData('assetId', p.getRequest().asset.id) \
        .setData('connectionId', p.getRequest().asset.connection.id) \
        .setData('productId', p.getRequest().asset.product.id) \
        .setData('status', p.getRequest().status)
    return p.getRequest().id


def trace_request_data(p, request_id):
    print(request_id \
        + ' : ' + p.getData('assetId') \
        + ' : ' + p.getData('connectionId') \
        + ' : ' + p.getData('productId') \
        + ' : ' + p.getData('status'))

def approve_request(p, _):
    p.getRequest().approveByTemplate('TL-000-000-000')
    # p.getRequest().approveByTile('Markdown text')


if __name__ == '__main__':
    # Env.initLogger('log.md', Logger.LEVEL_ERROR, None)

    # Process requests
    Processor() \
        .step('Add dummy data', add_dummy_data) \
        .step('Trace request data', trace_request_data) \
        .run(Request, QueryParams() \
            .set('asset.product.id__in', Env.getConfig().getProductsString()) \
            .set('status', 'pending'))
