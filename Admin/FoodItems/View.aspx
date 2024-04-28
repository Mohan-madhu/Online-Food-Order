<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="View.aspx.cs" Inherits="AddFoodItem" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HEAD" runat="Server">



    <style>
        /* Style for the food container */
        .food-container {
            display: flex;
            flex-wrap: wrap;
            justify-content: space-around;
        }

        /* Style for each food item */
        .food-item {
            width: 300px;
            margin: 10px;
            border: 1px solid #ddd;
            border-radius: 8px;
            overflow: hidden;
            position: relative; /* Needed for absolute positioning of details */
        }

        /* Style for the food image */
        .food-image {
            width: 100%;
            height: 200px;
            object-fit: cover;
            transition: transform 0.3s ease; /* Smooth transition for hover effect */
        }

        /* Style for the food details container */
        .food-details {
            position: absolute;
            bottom: 0;
            left: 0;
            width: 100%;
            background-color: rgba(0, 0, 0, 0.7); /* Background color with transparency */
            padding: 10px;
            color: #fff; /* Text color */
            transform: translateY(100%); /* Hide details by default */
            transition: transform 0.3s ease; /* Smooth transition for hover effect */
        }

        /* Show details on hover */
        .food-item:hover .food-details {
            transform: translateY(0);
        }

        /* Style for the food name */
        .food-name {
            margin: 0;
            font-size: 18px;
            font-weight: bold;
        }

        /* Style for the food cost */
        .food-cost {
            margin: 5px 0 0;
            font-size: 16px;
        }

        /* Style for the food description */
        .food-description {
            margin: 5px 0 0;
            font-size: 14px;
        }
        /* CSS */
        .fadeIn {
            animation: fadeInAnimation 2s ease forwards;
            opacity: 0;
        }

        @keyframes fadeInAnimation {
            from {
                opacity: 0;
            }

            to {
                opacity: 1;
            }
        }
    </style>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="BODY" runat="Server">
    <div ng-app="myApp" ng-controller="myCtrl">

        <div class="fadeIn">
            <div class="food-container">
                <div ng-repeat="food in foodItems track by $index">
                    <div class="food-item">
                        <img class="food-image" ng-src="{{ food.imageurl }}" alt="{{ food.foodname }}" />
                        <div class="food-details">

                            <p class="food-description">Description: {{ food.description }}</p>
                            <p class="food-cost">Cost: {{ food.cost }}</p>
                        </div>
                    </div>
                    <div>
                        <center>
                            <h2 class="food-name">{{ food.foodname }}</h2>
                        </center>
                    </div>
                </div>

            </div>
        </div>


    </div>

    <script>

        var app = angular.module('myApp', []);
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

            $scope.upd = function () {
                var file = $scope.file11
                console.log(file)


                $scope.uploadFile(file);
            }



            $scope.filesChanged = function (ele) {
                $scope.files = ele.files
                $scope.$apply();
            }


            $.ajax({
                type: "POST",
                url: "View.aspx/getfooditems",
                data: '{}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnSuccess,
                failure: function (response) {
                    alert(response.d);
                }
            });

            function OnSuccess(response) {

                var data = response.d


                var jsonString = JSON.parse(data);
                for (let i = 0; i < jsonString.length; i++) {
                    if (jsonString[i].hasOwnProperty('imageurl')) {

                        jsonString[i].imageurl = jsonString[i].imageurl.replace(/~/g, '');
                    }
                }

                $scope.foodItems = jsonString

                $scope.$apply();


            }


        }]);
    </script>




</asp:Content>

