/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect.api;

@:dox(hide)
interface IGeneralApi {
    public function listAccounts(filters: Query): String;
    public function createAccount(): String;
    public function getAccount(id: String): String;
    public function listAccountUsers(id: String): String;
    public function getAccountUser(id: String, userId: String): String;
    public function listConversations(filters: Query): String;
    public function createConversation(data: String): String;
    public function getConversation(id: String): String;
    public function createConversationMessage(id: String, data: String): String;
    public function listProducts(filters: Query): String;
    public function getProduct(id: String): String;
    public function listProductActions(id: String, filters: Query): String;
    public function getProductAction(id: String, actionId: String): String;
    public function getProductActionLink(id: String, actionId: String): String;
    public function getProductConnections(id: String): String;
    public function getProductItems(id: String): String;
    public function getProductParameters(id: String): String;
    public function getProductTemplates(id: String): String;
    public function getProductVersions(id: String): String;
    public function getProductVersion(id: String, version: Int): String;
    public function getProductVersionActions(id: String, version: Int): String;
    public function getProductVersionAction(id: String, version: Int,
            actionId: String): String;
    public function getProductVersionActionLink(id: String, version: Int,
            actionId: String): String;
    public function getProductVersionItems(id: String, version: Int): String;
    public function getProductVersionParameters(id: String, version: Int): String;
    public function getProductVersionTemplates(id: String, version: Int): String;
    public function listProductConfigurations(id: String, filters: Query): String;
    public function setProductConfigurationParam(id: String, param: String): String;
    public function listProductAgreements(id: String, filters: Query): String;
    public function listProductMedia(id: String, filters: Query): String;
    public function createProductMedia(id: String): String;
    public function getProductMedia(id: String, mediaId: String): String;
    public function updateProductMedia(id: String, mediaId: String, media: String): String;
    public function deleteProductMedia(id: String, mediaId: String): String;
    public function listCategories(filters: Query): String;
    public function getCategory(id: String): String;
}
