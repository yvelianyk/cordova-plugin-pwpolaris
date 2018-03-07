var exec = require('cordova/exec');

var _createClass = function () {
    function defineProperties(target, props) {
        for (var i = 0; i < props.length; i++) {
            var descriptor = props[i];
            descriptor.enumerable = descriptor.enumerable || false;
            descriptor.configurable = true;
            if ("value" in descriptor) descriptor.writable = true;
            Object.defineProperty(target, descriptor.key, descriptor);
        }
    }

    return function (Constructor, protoProps, staticProps) {
        if (protoProps) defineProperties(Constructor.prototype, protoProps);
        if (staticProps) defineProperties(Constructor, staticProps);
        return Constructor;
    };
}();

function _classCallCheck(instance, Constructor) {
    if (!(instance instanceof Constructor)) {
        throw new TypeError("Cannot call a class as a function");
    }
}

var PolarisOffice = function () {

    function PolarisOffice(options) {
        _classCallCheck(this, PolarisOffice);

        if (typeof options === 'undefined') {
            throw new Error('Options argument is required');
        }

        this.options = options;

        /**
         * Uncomment if you need permanent license key verification
         *
         */
        // if (typeof options['licenseKey'] === 'undefined') {
        //     throw new Error('License key is required');
        // }

        this.licenseKey = options['licenseKey'];

        exec(null, null, 'PolarisOffice', 'init', [{'key': this.licenseKey}]);
    }

    _createClass(PolarisOffice, [{
        /**
         * Open document
         *
         * @param fileUri - link to file in local file system
         * @param isPreview - open file in native preview app.(iOS only)
         */
        key: 'openDocument',
        value: function (fileUri, isPreview, successCallback, errorCallback) {
            errorCallback = errorCallback || function () {
            };

            if (typeof successCallback !== "function") {
                console.log("PolarisOffice.openDocument failure: success callback parameter must be a function");
                return;
            }

            var arg = {
                "fileUri": fileUri,
                "isPreview": isPreview
            };

            exec(successCallback, errorCallback, 'PolarisOffice', 'openDocument', [arg]);
        }
    }]);

    return PolarisOffice;
}();

module.exports = {
    /**
     * Create new Polaris Office instance and start the init process
     *
     * @param options
     */
    init: function (options) {
        return new PolarisOffice(options)
    }
};