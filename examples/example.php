<?php

require_once '../_packages/connect.php/connect.php';

use connect\Env;
use connect\Flow;
use connect\Logger;
use connect\Processor;
use connect\api\Query;
use connect\models\Request;


//Env::initLogger('log.md', Logger::LEVEL_ERROR, null);

// Define main flow
$flow = (new Flow(null))
    ->step('Add dummy data', function($p) {
        $p->setData('requestId', $p->getRequest()->id)
            ->setData('assetId', $p->getRequest()->asset->id)
            ->setData('connectionId', $p->getRequest()->asset->connection->id)
            ->setData('productId', $p->getRequest()->asset->product->id)
            ->setData('status', $p->getRequest()->status);
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
        $p->getRequest()->approveByTemplate('TL-000-000-000');
        $p->getRequest()->approveByTile('Markdown text');
    })
    */

// Process requests
(new Processor())
    ->flow($flow)
    ->processRequests((new Query())
        ->set('asset.product.id__in', Env::getConfig()->getProductsString())
        ->set('status', 'pending'));
