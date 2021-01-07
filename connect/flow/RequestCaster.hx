package connect.flow;

import connect.models.AssetRequest;
import connect.models.IdModel;
import connect.models.Listing;
import connect.models.TierConfigRequest;
import connect.models.UsageFile;

@:dox(hide)
class RequestCaster {
    public static function castAssetRequest(request:IdModel):AssetRequest {
        try {
            return cast(request, AssetRequest);
        } catch (ex:Dynamic) {
            return null;
        }
    }

    public static function castListing(request:IdModel):Listing {
        try {
            return cast(request, Listing);
        } catch (ex:Dynamic) {
            return null;
        }
    }

    public static function castTierConfigRequest(request:IdModel):TierConfigRequest {
        try {
            return cast(request, TierConfigRequest);
        } catch (ex:Dynamic) {
            return null;
        }
    }

    public static function castUsageFile(request:IdModel):UsageFile {
        try {
            return cast(request, UsageFile);
        } catch (ex:Dynamic) {
            return null;
        }
    }
}
