/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect.api;

import connect.logger.Logger;
import connect.models.IdModel;

class GeneralApi extends Base {
    private static final ACCOUNTS_PATH = 'accounts';
    private static final CONVERSATIONS_PATH = 'conversations';
    private static final PRODUCTS_PATH = 'products';
    private static final CATEGORIES_PATH = 'categories';

    public function new() {
    }

    public function listAccounts(filters: Query): String {
        return ConnectHelper.get(ACCOUNTS_PATH, null, null, filters, false, Logger.LEVEL_DEBUG);
    }

    public function createAccount(): String {
        return ConnectHelper.post(ACCOUNTS_PATH);
    }

    public function getAccount(id: String): String {
        return ConnectHelper.get(ACCOUNTS_PATH, id);
    }

    public function listAccountUsers(id: String): String {
        return ConnectHelper.get(ACCOUNTS_PATH, id, 'users', null, false, Logger.LEVEL_DEBUG);
    }

    public function getAccountUser(id: String, userId: String): String {
        return ConnectHelper.get(ACCOUNTS_PATH, id, 'users/${userId}');
    }

    public function listConversations(filters: Query): String {
        return ConnectHelper.get(CONVERSATIONS_PATH, null, null, filters, false, Logger.LEVEL_DEBUG);
    }

    public function createConversation(data: String): String {
        return ConnectHelper.post(CONVERSATIONS_PATH, null, null, data, Logger.LEVEL_DEBUG);
    }

    public function getConversation(id: String): String {
        return ConnectHelper.get(CONVERSATIONS_PATH, id, null, null, false, Logger.LEVEL_DEBUG);
    }

    public function createConversationMessage(id: String, data: String): String {
        return ConnectHelper.post(CONVERSATIONS_PATH, id, 'messages', data, Logger.LEVEL_DEBUG);
    }

    public function listProducts(filters: Query): String {
        return ConnectHelper.get(PRODUCTS_PATH, null, null, filters, true, Logger.LEVEL_DEBUG);
    }

    public function getProduct(id: String): String {
        return ConnectHelper.get(PRODUCTS_PATH, id);
    }

    public function listProductActions(id: String, filters: Query): String {
        return ConnectHelper.get(PRODUCTS_PATH, id, 'actions', filters, false, Logger.LEVEL_DEBUG);
    }

    public function getProductAction(id: String, actionId: String): String {
        return ConnectHelper.get(PRODUCTS_PATH, id, 'actions/${actionId}');
    }

    public function getProductActionLink(id: String, actionId: String): String {
        final response = haxe.Json.parse(
            ConnectHelper.get(PRODUCTS_PATH, id, 'actions/${actionId}/actionLink'));
        return response.link;
    }

    public function getProductConnections(id: String): String {
        return ConnectHelper.get(PRODUCTS_PATH, id, 'connections');
    }

    public function listProductItems(id: String, filters: Query): String {
        return ConnectHelper.get(PRODUCTS_PATH, id, 'items', filters, false, Logger.LEVEL_DEBUG);
    }

    public function listProductParameters(id: String, filters: Query): String {
        return ConnectHelper.get(PRODUCTS_PATH, id, 'parameters', filters, false, Logger.LEVEL_DEBUG);
    }

    public function getProductParameter(id: String, paramId: String): String {
        return ConnectHelper.get(PRODUCTS_PATH, id, 'parameters/$paramId');
    }

    public function createProductParameter(id: String, data: String): String {
        return ConnectHelper.post(PRODUCTS_PATH, id, 'parameters', data);
    }

    public function updateProductParameter(id: String, paramId: String, data: String): String {
        return ConnectHelper.put(PRODUCTS_PATH, id, 'parameters/$paramId', data);
    }

    public function deleteProductParameter(id: String, paramId: String): Void {
        ConnectHelper.delete(PRODUCTS_PATH, id, 'parameters/$paramId');
    }

    public function getProductTemplates(id: String): String {
        return ConnectHelper.get(PRODUCTS_PATH, id, 'templates');
    }

    public function getProductVersions(id: String): String {
        return ConnectHelper.get(PRODUCTS_PATH, id, 'versions');
    }

    public function getProductVersion(id: String, version: Int): String {
        return ConnectHelper.get(PRODUCTS_PATH, id, 'versions/${version}');
    }

    public function getProductVersionActions(id: String, version: Int): String {
        return 
            ConnectHelper.get(PRODUCTS_PATH, id, 'versions/${version}/actions');
    }

    public function getProductVersionAction(id: String, version: Int,
            actionId: String): String {
        return ConnectHelper.get(PRODUCTS_PATH, id,
            'versions/${version}/actions/${actionId}');
    }

    public function getProductVersionActionLink(id: String, version: Int,
            actionId: String): String {
        final response = haxe.Json.parse(ConnectHelper
            .get(PRODUCTS_PATH, id, 'versions/${version}/actions/${actionId}/actionLink'));
        return response.link;
    }

    public function getProductVersionItems(id: String, version: Int): String {
        return 
            ConnectHelper.get(PRODUCTS_PATH, id, 'versions/${version}/items');
    }

    public function getProductVersionParameters(id: String, version: Int): String {
        return 
            ConnectHelper.get(PRODUCTS_PATH, id, 'versions/${version}/parameters');
    }

    public function getProductVersionTemplates(id: String, version: Int): String {
        return 
            ConnectHelper.get(PRODUCTS_PATH, id, 'versions/${version}/templates');
    }

    public function listProductConfigurations(id: String, filters: Query): String {
        return 
            ConnectHelper.get(PRODUCTS_PATH, id, 'configurations', filters);
    }

    public function setProductConfigurationParam(id: String, param: String): String {
        return ConnectHelper.post(PRODUCTS_PATH, id, 'configurations', param);
    }

    public function listProductAgreements(id: String, filters: Query): String {
        return ConnectHelper.get(PRODUCTS_PATH, id, 'agreements', filters, false, Logger.LEVEL_DEBUG);
    }

    public function listProductMedia(id: String, filters: Query): String {
        return ConnectHelper.get(PRODUCTS_PATH, id, 'media', filters, false, Logger.LEVEL_DEBUG);
    }

    public function createProductMedia(id: String): String {
        return ConnectHelper.post(PRODUCTS_PATH, id, 'media');
    }

    public function getProductMedia(id: String, mediaId: String): String {
        return ConnectHelper.get(PRODUCTS_PATH, id, 'media/${mediaId}');
    }

    public function updateProductMedia(id: String, mediaId: String, media: String): String {
        return ConnectHelper.put(PRODUCTS_PATH, '${id}/media/${mediaId}', null, media);
    }

    public function deleteProductMedia(id: String, mediaId: String): String {
        return ConnectHelper.delete(PRODUCTS_PATH, id, 'media/${mediaId}');
    }

    public function listCategories(filters: Query): String {
        return ConnectHelper.get(CATEGORIES_PATH, null, null, filters, false, Logger.LEVEL_DEBUG);
    }

    public function getCategory(id: String): String {
        return ConnectHelper.get(CATEGORIES_PATH, id);
    }
}
