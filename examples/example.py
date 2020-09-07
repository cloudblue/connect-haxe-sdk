# This file is part of the Ingram Micro CloudBlue Connect SDK.
# Copyright (c) 2019 Ingram Micro. All Rights Reserved.

from connect import Env
from connect import Flow
from connect import Processor
from connect.api import Query
from connect.logger import LoggerConfig


def add_dummy_data(p):
    p.setData('requestId', p.getAssetRequest().id) \
        .setData('assetId', p.getAssetRequest().asset.id) \
        .setData('connectionId', p.getAssetRequest().asset.connection.id) \
        .setData('productId', p.getAssetRequest().asset.product.id) \
        .setData('status', p.getAssetRequest().status)


def trace_request_data(p):
    print(p.getData('requestId') \
        + ' : ' + p.getData('assetId') \
        + ' : ' + p.getData('connectionId') \
        + ' : ' + p.getData('productId') \
        + ' : ' + p.getData('status'))


def approve_request(p):
    pass
    # p.getAssetRequest().approveByTemplate('TL-000-000-000')
    # p.getAssetRequest().approveByTile('Markdown text')


if __name__ == '__main__':
    Env.initLogger(LoggerConfig().path('log'))

    # Define main flow
    flow = Flow(None) \
        .step('Add dummy data', add_dummy_data) \
        .step('Trace request data', trace_request_data)

    # Process requests
    Processor() \
        .flow(flow) \
        .processAssetRequests(Query() \
            .equal('asset.product.id__in', Env.getConfig().getProductsString()) \
            .equal('status', 'pending'))
