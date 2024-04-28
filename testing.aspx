<%@ Page Language="C#" AutoEventWireup="true" CodeFile="testing.aspx.cs" Inherits="testing" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>

    <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.8.2/angular.min.js"></script>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <!-- HTML -->
            <div ng-app="myApp" ng-controller="myCtrl">
       
                {{10*5}}



                 <asp:Label ID="Label13" runat="server" Text="Add WhatsApp FileUpload:"></asp:Label>
                <asp:FileUpload ID="FileUpload2" runat="server" file-model="myFile1" />

                  <button id="btnsubmit5" type="button" class="btn btn-success" ng-click="FormDataSubmit()">Final Submit</button>
            </div>

        </div>
    </form>
        <script>

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
                    console.log(fd)
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






        </script>

</body>
</html>
