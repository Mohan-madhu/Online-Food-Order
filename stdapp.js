﻿
var app = angular.module("myApp", []);

app.directive('fileModel', ['$parse', function ($parse) {
    return {
        restrict: 'A',
        link: function (scope, element, attrs) {
            var model = $parse(attrs.fileModel);
            var modelSetter = model.assign;

            element.bind('change', function () {
                scope.$apply(function () {
                    modelSetter(scope, element[0].files[0]);
                });
            });
        }
    };
}]);

app.service('fileUpload', ['$http', function ($http) {
    this.uploadFileToUrl = function (file, uploadUrl) {
        var fd = new FormData();
        fd.append('file', file);

        $http.post(uploadUrl, fd, {
            transformRequest: angular.identity,
            headers: { 'Content-Type': undefined }
        })


            .success(function (e) {

            })

            .error(function () {
            });
    }
}]);

app.controller('myCtrl', ['$http', '$scope', 'fileUpload', function ($http, $scope, fileUpload) {




    $scope.uploadFile = function (file) {

        console.log('file is ');
        console.dir(file);

        var uploadUrl = "UploadHandler.ashx";
        fileUpload.uploadFileToUrl(file, uploadUrl);

    };
    $scope.FormDataSubmit = function () {


        var file1 = $scope.myFile1;
        console.log(file1.name);
        filename1 = file1.name;
        $scope.uploadFile(file1);


        //var file2 = $scope.myFile2;
        //console.log(file2.name);
        //filename2 = file2.name;
        //$scope.uploadFile(file2);

    }


}]);




