<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Edit.aspx.cs" Inherits="Admin_FoodItems_Edit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HEAD" runat="Server">
    <style>
        .food-item {
            width: 150px;
            border: 1px solid #ddd;
            border-radius: 8px;
            overflow: hidden;
            position: relative; /* Needed for absolute positioning of details */
        }

        /* Style for the food image */
        .food-image {
            width: 150px;
            height: 150px;
            object-fit: cover;
            transition: transform 0.3s ease; /* Smooth transition for hover effect */
        }

        .food-details {
            position: absolute;
            bottom: 0;
            left: 0;
            width: 100%;
            display: flex;
            justify-content: center;
            gap: 10px;
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
    </style>

    <style>
        /* Style for the button */
        .delete-button {
            background-color: #dc3545; /* Red color for delete button */
            color: white; /* Text color */
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
        }

            /* Hover effect */
            .delete-button:hover {
                background-color: #c82333; /* Darker shade of red on hover */
            }
    </style>


</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="BODY" runat="Server">
    <div ng-app="myApp" ng-controller="myCtrl">
        <div class="fadeIn">
            <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#myModal" id="createitem" ng-click="addnewitem()">
                Add New Food Item
            </button>






            <div class="modal fade" id="myModal">
                <div class="modal-dialog">
                    <div class="modal-content">

                        <!-- Modal Header -->
                        <div class="modal-header">
                            <div class="row">
                                <div class="col-md-6">
                                    <h4 class="modal-title">Submit Food Information</h4>
                                </div>
                                <div class="col-md-6">
                                    <button type="button" class="close" data-dismiss="modal">&times;</button>
                                </div>
                            </div>



                        </div>

                        <!-- Modal Body -->
                        <div class="modal-body">
                            <div class="form-container">
                                <asp:TextBox ID="txttransid" runat="server" ng-model="transid" Visible="false"></asp:TextBox>

                                <div>
                                    <asp:RequiredFieldValidator ID="foodNameValidator" runat="server" ControlToValidate="foodName" ErrorMessage="Food Name is required" CssClass="form-validation"></asp:RequiredFieldValidator>
                                    <asp:Label ID="foodNameLabel" runat="server" AssociatedControlID="foodName" CssClass="form-label">Food Name:</asp:Label>
                                    <asp:TextBox ID="foodName" runat="server" CssClass="form-input" ng-model="foodName"></asp:TextBox>
                                </div>
                                <div>
                                    <asp:RequiredFieldValidator ID="descriptionValidator" runat="server" ControlToValidate="description" ErrorMessage="Description is required" CssClass="form-validation"></asp:RequiredFieldValidator>
                                    <asp:Label ID="descriptionLabel" runat="server" AssociatedControlID="description" CssClass="form-label">Description:</asp:Label><br>
                                    <asp:TextBox ID="description" runat="server" CssClass="form-input" ng-model="description" TextMode="MultiLine" Rows="2" Columns="50"></asp:TextBox>
                                </div>
                                <div class="col-lg-6">
                                    <asp:RequiredFieldValidator ID="costValidator" runat="server" ControlToValidate="cost" ErrorMessage="Cost is required" CssClass="form-validation"></asp:RequiredFieldValidator>
                                    <asp:Label ID="costLabel" runat="server" AssociatedControlID="cost" CssClass="form-label">Cost:</asp:Label>
                                    <asp:TextBox ID="cost" runat="server" CssClass="form-input" TextMode="Number" ng-model="cost"></asp:TextBox>
                                </div>
                                <div class="col-lg-6">
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="available" ErrorMessage="Available count is required" CssClass="form-validation"></asp:RequiredFieldValidator>
                                    <asp:Label ID="Label1" runat="server" AssociatedControlID="available" CssClass="form-label">Stock Available Count:</asp:Label>
                                    <asp:TextBox ID="available" runat="server" CssClass="form-input" TextMode="Number" ng-model="available"></asp:TextBox>
                                </div>
                                <br />
                                <div>
                                    <asp:Label ID="foodImageLabel" runat="server" AssociatedControlID="foodImage" CssClass="form-label">Upload Food Image:</asp:Label>
                                    <%-- <input type="file" id="fileUpload" class="form-input" onchange="angular.element(this).scope().filesChanged(this)" file-model="file11" />--%>
                                    <asp:FileUpload runat="server" ID="foodImage" CssClass="form-input" />
                                </div>
                                <br />
                                <div>

                                    <asp:Button runat="server" ID="btnsubmit" Text="Submit" CssClass="form-submit" OnClick="submitBtn_Click" />
                                </div>



                            </div>
                        </div>

                        <%--   <!-- Modal Footer -->
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-primary">Save changes</button>
                </div>--%>
                    </div>
                </div>
            </div>
            <h1>Food Items List
            </h1>
            <br />
            <table class="table  table-hover">
                <thead>
                    <tr>
                        <th>S.NO</th>
                        <th>Image</th>
                        <th>Food Name</th>
                        <th>Food Type</th>
                        <th>Cost</th>
                        <th>Available</th>
                        <th>Action</th>


                    </tr>
                </thead>
                <tbody>
                    <tr ng-repeat="item in foodlist" ng-class="{ 'highlight': isSelected(item) }" ng-click="toggleSelection(item)">
                        <td>{{$index+1 }}</td>
                        <td>
                            <div class="food-item">
                                <img class="food-image" ng-src="{{ item.imageurl }}" alt="{{ item.foodname }}" />
                                <div class="food-details">
                                    <p class="food-cost">{{ item.description }}</p>
                                </div>
                            </div>
                        </td>
                        <td>{{ item.foodname }}</td>
                        <td>{{ item.foodtype }}</td>
                        <td>{{ item.cost }}</td>
                        <td>{{ item.available }}</td>
                        <td>
                            <button type="button" class="btn  btn-info alert-info" ng-click="editfooditem($index)">
                                <i class="fas fa-edit  "></i>
                            </button>
                            <button type="button" class="btn alert-danger btn-danger" ng-click="deletefood(item.transid)">
                                <i class="fas fa-trash-alt"></i>
                            </button>
                        </td>


                    </tr>
                </tbody>
            </table>
            <br />



        </div>



    </div>

    <script>

        var app = angular.module('myApp', []);

        app.controller('myCtrl', ['$http', '$scope', '$interval', function ($http, $scope, $interval) {
            $scope.orderlist = []
            $scope.orderdetails = []
            $scope.tblvisible = false;
            $scope.orderqr = ""
            $scope.paid = true

            var load = function () {
                $.ajax({
                    type: "POST",
                    url: "Edit.aspx/foodlist",
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
                    $scope.foodlist = jsonString
                    $scope.$apply();
                }
            }
            load()


            $scope.selectedItem = null;

            $scope.isSelected = function (item) {
                return $scope.selectedItem === item;
            };

            $scope.toggleSelection = function (item) {
                $scope.selectedItem = ($scope.selectedItem === item) ? null : item;
            };



            $scope.deletefood = function (id) {
                var result = window.confirm("Are you sure you want to delete this item?");
                if (result) {
                    deletefooditem(id);
                }
            }

            var deletefooditem = function (id) {
                $.ajax({
                    type: "POST",
                    url: "Edit.aspx/delfooditem",
                    data: '{"id" : "' + id + '"}',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: OnSuccess,
                    failure: function (response) {
                        alert(response.d);
                    }
                });
                function OnSuccess(response) {
                    alert(response.d)
                    load()
                }
            }


            $scope.editfooditem = function (id) {
                var popup = document.getElementById("createitem")
                popup.click()
                var item = $scope.foodlist[id]
                $scope.foodName = item.foodname
                $scope.description = item.description
                $scope.cost = item.cost
                $scope.available = item.available
                $scope.transid = item.transid
                $scope.$apply();
            }
            $scope.addnewitem = function (id) {
                $scope.transid = ''
                $scope.foodName = ''
                $scope.description = ''
                $scope.cost = 0
                $scope.available = 0
            }



        }]);
    </script>
    <script>

        function clearform() {
            var textBox = document.getElementById("<%= foodName.ClientID %>");
            textBox.value = "";
            textBox = document.getElementById("<%= description.ClientID %>");
            textBox.value = "";
            textBox = document.getElementById("<%= cost.ClientID %>");
            textBox.value = "";

        }
    </script>

</asp:Content>

