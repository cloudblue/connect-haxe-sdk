<?php
/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/

require_once '../_packages/connect.php/connect.php';

use connect\Env;
use connect\Flow;
use connect\Processor;
use connect\api\Query;
use connect\logger\LoggerConfig;


Env::initLogger((new LoggerConfig())->path('log'));

// Define main flow
$flow = (new Flow(null))
    ->step('Add dummy data', function($p) {
        $p->setData('requestId', $p->getAssetRequest()->id)
            ->setData('assetId', $p->getAssetRequest()->asset->id)
            ->setData('connectionId', $p->getAssetRequest()->asset->connection->id)
            ->setData('productId', $p->getAssetRequest()->asset->product->id)
            ->setData('status', $p->getAssetRequest()->status);
    })
    ->step('Trace request data', function($p) {
        echo $p->getData('requestId')
            . ' : ' . $p->getData('assetId')
            . ' : ' . $p->getData('connectionId')
            . ' : ' . $p->getData('productId')
            . ' : ' . $p->getData('status')
            . PHP_EOL;
    });
    /*
    ->step('Approve request', function($p) {
        $p->getAssetRequest()->approveByTemplate('TL-000-000-000');
        $p->getAssetRequest()->approveByTile('Markdown text');
    })
    */

// Process requests
(new Processor())
    ->flow($flow)
    ->processAssetRequests((new Query())
        ->equal('asset.product.id__in', Env::getConfig()->getProductsString())
        ->equal('status', 'pending'));
