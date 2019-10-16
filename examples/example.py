from connect import Env
from connect import Logger
from connect import Processor
from connect.api import QueryParams
from connect.models import Request


def add_dummy_data(p, input):
    pass


if __name__ == '__main__':
    # Env.initLogger('log.md', Logger.LEVEL_ERROR, None)

    # Process requests
    Processor() \
        .step('Add dummy data', add_dummy_data) \
        .run(Request, QueryParams() \
            .set('asset.product.id__in', Env.getConfig().getProductsString()) \
            .set('status', 'pending'))
