package connect.models;

import connect.api.QueryParams;
import haxe.io.Bytes;


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


    /** User ID who has created this UsageFile. **/
    public var createdBy: String;


    /** Date of the creation of the UsageFile. **/
    public var createdAt: String;


    /**
        Google Storage shared location of the upload file. Only available in GET API and not
        included in list API (sharing timeout 600 sec).
    **/
    public var uploadFileUri: String;


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
    public var rejectionNode: String;


    /** In case of invalid file, this field will contain errors related to the file. **/
    public var errorDetails: String;


    /** Reference to `UsageRecords` object. **/
    public var records: UsageRecords;


    /** Reference to `Events` ocurred on the UsageFile. **/
    public var events: Events;


    /**
        Lists all UsageFiles that match the given filters. Supported filters are:

        - product_id
        - distribution_contract_id
        - status
        - created_at

        @returns A Collection of Requests.
    **/
    public static function list(filters: QueryParams) : Collection<UsageFile> {
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
        Creates a new UsageFile, based on the data of the UsageFile provided. The given UsageFile
        is only required to have a value in the following fields:

        - name
        - description
        - note
        - product.id
        - contract.id

        @returns The created UsageFile.
    **/
    public static function create(usageFile: UsageFile): UsageFile {
        try {
            final newUsageFile = Env.getUsageApi().createUsageFile(usageFile.toString());
            return Model.parse(UsageFile, newUsageFile);
        } catch (ex: Dynamic) {
            return null;
        }
    }


    /**
        Updates the UsageFile in the server with the data changed in `this` model.

        @returns The UsageFile returned from the server, which should contain
        the same data as `this` UsageFile.
    **/
    public function update(): UsageFile {
        final usageFile = Env.getUsageApi().updateUsageFile(
            this.id,
            this.toString());
        return Model.parse(UsageFile, usageFile);
    }


    /**
        Deletes the UsageFile in the server.
    **/
    public function delete(): Void {
        Env.getUsageApi().deleteUsageFile(this.id);
    }


    public function upload(file: Bytes): UsageFile {
        final usageFile = Env.getUsageApi().uploadUsageFile(this.id, file);
        return Model.parse(UsageFile, usageFile);
    }


    public function submit(): UsageFile {
        final usageFile = Env.getUsageApi().submitUsageFileAction(this.id);
        return Model.parse(UsageFile, usageFile);
    }


    public function accept(note: String): UsageFile {
        final usageFile = Env.getUsageApi().acceptUsageFileAction(this.id, note);
        return Model.parse(UsageFile, usageFile);
    }


    public function reject(note: String): UsageFile {
        final usageFile = Env.getUsageApi().rejectUsageFileAction(this.id, note);
        return Model.parse(UsageFile, usageFile);
    }


    public function close(): UsageFile {
        final usageFile = Env.getUsageApi().closeUsageFileAction(this.id);
        return Model.parse(UsageFile, usageFile);
    }


    public function getTemplateLink(): String {
        final link = Env.getUsageApi().getProductSpecificUsageFileTemplate(this.id);
        return link.template_link;
    }


    public function uploadReconciliation(file: Bytes): UsageFile {
        final usageFile = Env.getUsageApi().uploadReconciliationFileFromProvider(this.id, file);
        return Model.parse(UsageFile, usageFile);
    }


    public function reprocess(): UsageFile {
        final usageFile = Env.getUsageApi().reprocessProcessedFile(this.id);
        return Model.parse(UsageFile, usageFile);
    }
}
