package com.powwow.cordova.polarisdocumentviewer;

import android.content.Intent;

import com.infraware.polarisoffice6.api.OfficeAPI;
import com.infraware.sdk.IUserConfig;
import com.infraware.sdk.SdkInterface;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/**
 * @author Orest Guziy.
 */

public class PolarisDocumentViewerPlugin extends CordovaPlugin {

    private static final int REQUEST_CODE = 1001;

    private static final String INIT = "init";
    private static final String OPEN_DOCUMENT = "openDocument";

    private static final String SDK_KEY = "key";
    private static final String URI_KEY = "fileUri";

    private CallbackContext mCallbackContext;

    private SdkInterface mSdkInterface = new SdkInterface();

    private String mSdkKey;
    private String mFileUri;

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        this.mCallbackContext = callbackContext;

        switch (action) {
            case INIT:
                mSdkKey = retrieveSdkKey(args.optJSONObject(0));
                init(mSdkKey);
                return true;

            case OPEN_DOCUMENT:
                mFileUri = retrieveFileUri(args.optJSONObject(0));
                openDocument(mFileUri);
                return true;

            default:
                return false;

        }
    }

    private String retrieveSdkKey(JSONObject object) {
        return object != null ? object.optString(SDK_KEY) : null;
    }

    private String retrieveFileUri(JSONObject object) {
        return object != null ? object.optString(URI_KEY) : null;
    }

    private void init(String sdkKey) {
        mSdkInterface.mIUserConfig.strCID = sdkKey;
        mSdkInterface.mIUserConfig.bOpenEditMode = true;
        OfficeAPI.registerSdkInterface(mSdkInterface);
    }

    private void openDocument(String fileUri) {
        cordova.setActivityResultCallback(this);
        OfficeAPI.OpenDocument(cordova.getActivity(), fileUri.substring(7), REQUEST_CODE);
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent intent) {
        super.onActivityResult(requestCode, resultCode, intent);

        sendResult();
    }

    private void sendResult() {
        PluginResult result = new PluginResult(PluginResult.Status.OK, mFileUri);
        result.setKeepCallback(true);

        mCallbackContext.sendPluginResult(result);
    }
}
