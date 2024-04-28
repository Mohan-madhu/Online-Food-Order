<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="MyOrders.aspx.cs" Inherits="Customer_MyOrders" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HEAD" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="BODY" runat="Server">
    <div ng-app="myApp" ng-controller="myCtrl">
        <div class="fadeIn">

            <h1>ORDER LIST
            </h1>
            <br />
            <table class="table  table-hover">
                <thead>
                    <tr>
                        <th>S.NO</th>
                        <th>Order Name</th>

                        <th>Order Type</th>
                        <th>Cost</th>
                        <th>Order Status</th>
                        <th>Order Time</th>
                        <th>Confirm Order</th>

                    </tr>
                </thead>
                <tbody>
                    <tr ng-repeat="item in orderlist" ng-class="{ 'highlight': isSelected(item) }" ng-click="toggleSelection(item)">
                        <td>{{$index+1 }}</td>
                        <td>Order {{ foodlist.length - ($index-1 ) }}</td>
                        <td>{{ item.ordertype }}</td>
                        <td>{{ item.cost }}</td>
                        <td>
                            <span ng-if="item.ordersts == 0">Pending
                            </span>
                            <span ng-if="item.ordersts !=0">Checked Out
                            </span>

                        </td>
                        <td>{{ item.createdtime }}</td>
                        <td>
                            <span ng-if="item.ordersts == 0">
                                <input type="button" class="btn  btn-success" value="Check Out" data-toggle="modal" ng-click="checkout(item.transid)" data-target="#myModal" />
                            </span>
                            <span ng-if="item.ordersts !=0">
                                <input type="button" class="btn btn-info" value="View Details" data-toggle="modal" ng-click="vieworderdetails(item.transid)" data-target="#myModal1" />
                            </span>

                        </td>

                    </tr>
                </tbody>
            </table>
            <br />



        </div>


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
                                <button type="button" class="close" id="modalclose" data-dismiss="modal">&times;</button>
                            </div>
                        </div>



                    </div>

                    <!-- Modal Body -->
                    <div class="modal-body">
                        <div class="form-container">
                            <img ng-src="{{ orderqr }}" class="qr" />
                            <br />
                            <br />
                            <h1>Order Details
                            </h1>
                            <br />
                            <table class="table  table-hover">
                                <thead>
                                    <tr>
                                        <th>S.NO</th>
                                        <th>Food Name</th>
                                        <th>Cost</th>
                                        <th>Quantity</th>
                                        <th>Total</th>

                                    </tr>
                                </thead>
                                <tbody>
                                    <tr ng-repeat="item in orderdetails" ng-class="{ 'highlight': isSelected(item) }" ng-click="toggleSelection(item)">
                                        <td>{{$index+1 }}</td>
                                        <td>{{ item.foodname }}</td>
                                        <td>{{ item.foodcost }}</td>

                                        <td>{{ item.quantity }}</td>
                                        <td>{{ item.total }}</td>

                                    </tr>
                                </tbody>

                            </table>
                            <b>Total Amount : {{total}}</b>
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


        <div class="modal fade" id="myModal1">
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

                            <h1>Order Details
                            </h1>
                            <br />
                            <table class="table  table-hover">
                                <thead>
                                    <tr>
                                        <th>S.NO</th>
                                        <th>Food Name</th>
                                        <th>Cost</th>
                                        <th>Quantity</th>
                                        <th>Total</th>

                                    </tr>
                                </thead>
                                <tbody>
                                    <tr ng-repeat="item in orderdetails" ng-class="{ 'highlight': isSelected(item) }" ng-click="toggleSelection(item)">
                                        <td>{{$index+1 }}</td>
                                        <td>{{ item.foodname }}</td>
                                        <td>{{ item.foodcost }}</td>

                                        <td>{{ item.quantity }}</td>
                                        <td>{{ item.total }}</td>

                                    </tr>
                                </tbody>

                            </table>

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
                    url: "MyOrders.aspx/getorderlist",
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
                    $scope.orderlist = jsonString
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

            $scope.checkout = function (id) {
                $scope.orderqr = "https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=" + id;
                $.ajax({
                    type: "POST",
                    url: "MyOrders.aspx/getorderdetails",
                    data: "{ 'orderid': '" + id + "' }",
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
                    $scope.orderdetails = jsonString
                    $scope.total = 0
                    for (var i = 0; i < $scope.orderdetails.length; i++) {
                        $scope.total += parseFloat($scope.orderdetails[i]["total"])
                    }
                    $scope.$apply();
                }

                var intervalPromise = $interval(function () {
                    $scope.doTask();
                }, 2000);



                $scope.doTask = function () {
                    $.ajax({
                        type: "POST",
                        url: "MyOrders.aspx/checkdelivered",
                        data: "{ 'orderid': '" + id + "' }",
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        success: OnSuccess,
                        failure: function (response) {
                            alert(response.d);
                        }
                    });
                    function OnSuccess(response) {
                        var data = response.d

                        if (data == 1) {
                            $interval.cancel(intervalPromise);


                            var modalclose = document.getElementById("modalclose")
                            modalclose.click()

                            alert("Your Order has been Verified Successfully.")
                            load()
                        }
                    }
                };


            }
            $scope.vieworderdetails = function (id) {
                $.ajax({
                    type: "POST",
                    url: "MyOrders.aspx/getorderdetails",
                    data: "{ 'orderid': '" + id + "' }",
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
                    $scope.orderdetails = jsonString
                    $scope.$apply();
                }
            }



        }]);
    </script>
</asp:Content>

