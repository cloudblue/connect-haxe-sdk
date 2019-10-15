<?php

require_once '../_build/_packages/php/connect.php';

use connect\Env;
use connect\Logger;
use connect\Processor;
use connect\api\QueryParams;
use connect\models\Request;


// Process requests
(new Processor())
    ->step('Add dummy data', function($p, $input) {
        $p->setData('assetId', $p->getRequest()->asset->id)
            ->setData('connectionId', $p->getRequest()->asset->connection->id)
            ->setData('productId', $p->getRequest()->asset->product->id)
            ->setData('status', $p->getRequest()->status);
        return $p->getRequest()->id;
    })
    ->step('Trace request data', function($p, $requestId) {
        trace($requestId
            . ' : ' . $p->getData('assetId')
            . ' : ' . $p->getData('connectionId')
            . ' : ' . $p->getData('productId')
            . ' : ' . $p->getData('status')
            . PHP_EOL);
        return '';
    })
    /*
    ->step('Approve request', function($p, $input) {
        $p->getRequest()->approveByTemplate('TL-000-000-000');
        $p->getRequest()->approveByTile('Markdown text');
        return '';
    })
    */
    ->run(Request::class, (new QueryParams())
        ->set('asset.product.id__in', Env::getConfig()->getProductsString())
        ->set('status', 'pending'));
