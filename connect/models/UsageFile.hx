/*
    This file is part of the Ingram Micro CloudBlue Connect SDK.
    Copyright (c) 2019 Ingram Micro. All Rights Reserved.
*/
package connect.models;

import connect.api.Query;
import connect.models.Period;
import connect.util.Blob;
import connect.util.Collection;
import connect.util.ExcelWriter.ExcelSheet;
import connect.util.ExcelWriter.ExcelWriter;

/**
    Usage File Object.
**/
class UsageFile extends IdModel {
    /** Name of the UsageFile object. **/
    public var name: String;

    /** Vendor can provide a description value in this field to describe the file content. **/
    public var description: String;

    /** Vendor can put a note which can be referred to later for some extra information. **/
    public var note: String;

    /**
        One of:
    
        - draft
        - uploading
        - uploaded
        - processing
        - invalid
        - ready
        - rejected
        - pending
        - accepted
        - closed
    **/
    public var status: String;

    /** Period covered by this UsageFile. **/
    public var period: Period;

    /** Currency of the amount included in UsageFile. **/
    public var currency: String;

    /** Usage scheme used for the usage file. One of: QT, TR, CR, PR. **/
    public var schema: String;

    /**
        Google Storage shared location of the upload file. Only available in GET API and not
        included in list API (sharing timeout 600 sec).
    **/
    public var usageFileUri: String;

    /**
        Google Storage shared location of the generated file after processing uploaded file.
        Only available in GET API and not included in list API (sharing timeout 30 sec).
    **/
    public var processedFileUri: String;

    /** Reference to `Product` object. **/
    public var product: Product;

    /** Reference to `Contract` object. **/
    public var contract: Contract;

    /** Reference to `Marketplace` object. **/
    public var marketplace: Marketplace;

    /** Reference to Vendor `Account`. **/
    public var vendor: Account;

    /** Reference to Provider `Account`. **/
    public var provider: Account;

    /** Note provided by the provider in case of acceptance of the usage file. **/
    public var acceptanceNote: String;

    /** Note provider by the provider in case of rejection of the usage file. **/
    public var rejectionNote: String;

    /** In case of invalid file, this field will contain errors related to the file. **/
    public var errorDetail: String;

    /** Reference to `UsageStats` object. **/
    public var stats: UsageStats;

    /** Reference to `Events` ocurred on the UsageFile. **/
    public var events: Events;

    /** External id of the UsageFile. **/
    public var externalId: String;

    /** Environment of the UsageFile. **/
    public var environment: String;

    public function new() {
        super();
        this._setFieldClassNames([
            'vendor' => 'Account',
            'provider' => 'Account',
            'stats' => 'UsageStats'
        ]);
    }

    /**
        Lists all UsageFiles that match the given filters. Supported filters are:

        - `product_id`
        - `distribution_contract_id`
        - `status`
        - `created_at`

        @returns A Collection of Requests.
    **/
    public static function list(filters: Query) : Collection<UsageFile> {
        final usageFiles = Env.getUsageApi().listUsageFiles(filters);
        return Model.parseArray(UsageFile, usageFiles);
    }

    /** @returns The UsageFile with the given id, or `null` if it was not found. **/
    public static function get(id: String): UsageFile {
        try {
            final usageFile = Env.getUsageApi().getUsageFile(id);
            return Model.parse(UsageFile, usageFile);
        } catch (ex: Dynamic) {
            return null;
        }
    }

    /**
        Registers a new UsageFile on Connect, based on the data of `this` UsageFile, which
        should have a value at least in the following fields:

        - name
        - product.id
        - contract.id

        @returns The new UsageFile.
    **/
    public function register(): UsageFile {
        try {
            final newUsageFile = Env.getUsageApi().createUsageFile(this.toString(),this);
            return Model.parse(UsageFile, newUsageFile);
        } catch (ex: Dynamic) {
            return null;
        }
    }

    /**
        Updates `this` UsageFile in the server with the data changed in `this` model.

        You should reassign your file with the object returned by this method, so the next time
        you call `update` on the object, the SDK knows the fields that already got updated in a
        previous call, like this:

        ```
        file = file.update();
        ```

        @returns The UsageFile returned from the server, which should contain
        the same data as `this` UsageFile.
    **/
    public function update(): UsageFile {
        final diff = this._toDiff();
        final hasModifiedFields = Reflect.fields(diff).length > 1;
        if (hasModifiedFields) {
            final usageFile = Env.getUsageApi().updateUsageFile(
                this.id,
                haxe.Json.stringify(diff), this);
            return Model.parse(UsageFile, usageFile);
        } else {
            return this;
        }
    }

    /** Deletes `this` UsageFile in the server. **/
    public function delete(): Bool {
        try {
            Env.getUsageApi().deleteUsageFile(this.id, this);
            return true;
        } catch (ex: Dynamic) {
            return false;
        }
    }

    /**
        Uploads the `Collection` of `UsageRecord` objects to `this` UsageFile in Connect.
        The SDK automatically generates a Microsoft Excel XLSX file with the records
        and uploads it, so this is a more convenient version of the `UsageFile.upload()`
        method, which requires you to generate the Excel file contents yourself.
    **/
    public function uploadRecords(records: Collection<UsageRecord>): UsageFile {
        final sheet = createSpreadsheet(this.id, records.toArray(), null);
        final data = Blob._fromBytes(sheet);
        return upload(data);
    }

    private static function createSpreadsheet(fileId: String, records: Array<UsageRecord>,
            categories: Array<UsageCategory>): haxe.io.Bytes {
        final paramNames = getRecordParamNames(records);
        final usageColumns = [
            's:record_id',
            's:record_note',
            's:item_search_criteria',
            's:item_search_value',
            's:amount',
            's:quantity',
            's:start_time_utc',
            's:end_time_utc',
            's:asset_search_criteria',
            's:asset_search_value',
            's:item_name',
            's:item_mpn',
            's:item_precision',
            's:item_unit',
            's:category_id',
            's:asset_recon_id',
            's:tier'
        ].concat(paramNames.map(n -> 's:$n'));
        final usageSheet: ExcelSheet = [usageColumns];
        for (i in 0...records.length) {
            final record = records[i];
            usageSheet.push([
                's:' + ((record.recordId != null) ? record.recordId : '${fileId}_record_$i'),
                's:' + ((record.recordNote != null) ? record.recordNote : ''),
                's:' + ((record.itemSearchCriteria != null) ? record.itemSearchCriteria : ''),
                's:' + ((record.itemSearchValue != null) ? record.itemSearchValue : ''),
                'n:' + ((record.amount != null) ? Std.string(record.amount):'0'),
                'n:' + ((record.quantity != null) ?  Std.string(record.quantity) :'0'),
                's:' + (record.startTimeUtc != null ? StringTools.replace(record.startTimeUtc.toString(),'T',' ').split("+")[0] : ''),
                's:' + (record.endTimeUtc != null ? StringTools.replace(record.endTimeUtc.toString(),'T',' ').split("+")[0] : ''),
                's:' + ((record.assetSearchCriteria != null) ? record.assetSearchCriteria : ''),
                's:' + ((record.assetSearchValue != null) ? record.assetSearchValue : ''),
                's:' + ((record.itemName != null) ? record.itemName : ''),
                's:' + ((record.itemMpn != null) ? record.itemMpn : ''),
                's:' + ((record.itemPrecision != null) ? record.itemPrecision : ''),
                's:' + ((record.itemUnit != null) ? record.itemUnit : ''),
                's:' + ((record.categoryId != null) ? record.categoryId : 'generic_category'),
                's:' + ((record.assetReconId != null) ? record.assetReconId : ''),
                's:' + record.tier != null ?  Std.string(record.tier) : ''
            ].concat(paramNames.map(n -> 's:${getRecordParamValue(record, n)}')));
        }

        final categoriesSheet: ExcelSheet = [];
        categoriesSheet.push([
            's:category_id',
            's:category_name',
            's:category_description'
        ]);
        if (categories != null) {
            for (category in categories) {
                categoriesSheet.push([
                    's:' + category.id,
                    's:' + category.name,
                    's:' + category.description
                ]);
            }
        } else {
            categoriesSheet.push([
                's:generic_category',
                's:Generic Category',
                's:Generic autogenerated category'
            ]);
        }

        return new ExcelWriter()
            .addSheet('categories', categoriesSheet)
            .addSheet('usage_records', usageSheet)
            .compress();
    }

    private static function getRecordParamNames(records: Array<UsageRecord>): Array<String> {
        final names: Array<String> = [];
        for (record in records) {
            if (record.params != null) {
                for (param in record.params) {
                    if (names.indexOf(param.parameterName) == -1) {
                        names.push(param.parameterName);
                    }
                }
            }
        }
        return names;
    }

    private static function getRecordParamValue(record: UsageRecord, name: String): String {
        if (record.params != null) {
            final param = Lambda.find(record.params, p -> p.parameterName == name);
            return (param != null) ? param.parameterValue : '';
        } else {
            return '';
        }
    }

    /**
     * Uploads the `Collection` of `UsageRecord` objects and `UsageCategory` objects
     * to `this` UsageFile in Connect. The SDK automatically generates a Microsoft Excel
     * XLSX file with the records and uploads it, so this is a more convenient version of
     * the `UsageFile.upload()` method, which requires you to generate the Excel file
     * contents yourself.
     */
    public function uploadRecordsAndCategories(records: Collection<UsageRecord>,
            categories: Collection<UsageCategory>): UsageFile {
        final sheet = createSpreadsheet(this.id, records.toArray(), categories.toArray());
        final data = Blob._fromBytes(sheet);
        return upload(data);
    }

    /**
        Uploads the specified contents to `this` UsageFile in Connect.

        @param content The contents of an XLSX file.
        @returns The UsageFile returned from the server.
    **/
    public function upload(content: Blob): UsageFile {
        final usageFile = Env.getUsageApi().uploadUsageFile(this.id, content, this);
        return Model.parse(UsageFile, usageFile);
    }

    /**
        Submits `this` UsageFile.

        @returns The UsageFile returned from the server.
    **/
    public function submit(): UsageFile {
        final usageFile = Env.getUsageApi().submitUsageFileAction(this.id, this);
        return Model.parse(UsageFile, usageFile);
    }

    /**
        Accepts `this` UsageFile.

        @returns The UsageFile returned from the server.
    **/
    public function accept(note: String): UsageFile {
        final usageFile = Env.getUsageApi().acceptUsageFileAction(this.id, note, this);
        return Model.parse(UsageFile, usageFile);
    }

    /**
        Rejects `this` UsageFile.

        @returns The UsageFile returned from the server.
    **/
    public function reject(note: String): UsageFile {
        final usageFile = Env.getUsageApi().rejectUsageFileAction(this.id, note, this);
        return Model.parse(UsageFile, usageFile);
    }

    /**
        Cancels `this` UsageFile.

        @returns The UsageFile returned from the server.
    **/
    public function close(): UsageFile {
        final usageFile = Env.getUsageApi().closeUsageFileAction(this.id, this);
        return Model.parse(UsageFile, usageFile);
    }

    /**
        Gets the contents of the product specific file template for `this` UsageFile.
    **/
    public function getTemplate(): Blob {
        try {
            final link = getTemplateLink();
            final response = Env.getApiClient().syncRequest('GET', link, null, null, null, null, null, null);
            return response.data;
        } catch (ex: Dynamic) {
            return null;
        }
    }

    /**
        Gets the product specific file template URL for `this` UsageFile.
    **/
    public function getTemplateLink(): String {
        final link = haxe.Json.parse(Env.getUsageApi().getProductSpecificUsageFileTemplate(this.id, this));
        return link.template_link;
    }

    /**
        Uploads the contents of a reconciliation file to `this` UsageFile.

        @param content The contents of an XLSX file.
        @returns The UsageFile returned from the server.
    **/
    public function uploadReconciliation(content: Blob): UsageFile {
        final usageFile = Env.getUsageApi().uploadReconciliationFileFromProvider(this.id, content, this);
        return Model.parse(UsageFile, usageFile);
    }

    /**
        Reprocesses a processed file. This is called by the provider after the provider closes
        some usage records manually.

        @returns The UsageFile returned from the server.
    **/
    public function reprocess(): UsageFile {
        final usageFile = Env.getUsageApi().reprocessProcessedFile(this.id, this);
        return Model.parse(UsageFile, usageFile);
    }
}
