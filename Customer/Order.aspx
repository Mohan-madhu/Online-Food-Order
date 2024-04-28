<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Order.aspx.cs" Inherits="Customer_Order" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajax" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HEAD" runat="Server">


    <style>
        body {
            background: #808080;
        }
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


        .wrapper {
            margin-left: 10px;
            margin-right: 10px;
            height: 50px;
            min-width: 27px;
            background: #fff;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 12px;
            box-shadow: 0 5px 10px rgba(0,0,0,0.2);
            margin-bottom: 20px;
        }

            .wrapper span {
                width: 100%;
                text-align: center;
                font-size: 40px;
                font-weight: 600;
                height: auto;
            }

                .wrapper span button {
                    width: 100%;
                    background-color: transparent;
                    border: none;
                    text-align: center;
                    text-decoration: none;
                    display: inline-block;
                    cursor: pointer;
                    border-radius: 3px;
                }

                .wrapper span.minus button:hover {
                    color: #C62828;
                }

                .wrapper span.num button:hover {
                    background-color: #e0e0e0;
                }

                .wrapper span.plus button:hover {
                    color: #2E7D32;
                }

                .wrapper span.num {
                    font-size: 20px;
                    border-right: 2px solid rgba(0,0,0,0.2);
                    border-left: 2px solid rgba(0,0,0,0.2);
                }


        .modal-dialog {
            width: 350px;
            display: block;
            justify-content: center;
            align-items: center;
        }

        .qr {
            align-content: center;
            margin-left: 50px;
        }

        .modal-title {
            font-weight: bold;
        }

        .modal fade {
            width: auto;
        }

        .modal-body {
            width: auto;
            align-content: center;
        }

        .row vd {
            width: auto;
            align-items: flex-start;
            width: fit-content;
            display: flex;
            justify-content: space-between;
        }

        .form-validation {
            width: auto;
        }

        .x-button {
            align-content: end;
        }

        .col-md-6 {
            width: auto;
        }

        .qrcode {
            align-content: center;
            margin-left: 40px;
        }

        .modal-footer {
            align-content: end;
        }

        @keyframes fadeInAnimation {
            from {
                opacity: 0;
            }

            to {
                opacity: 1;
            }
        }



        /* Highlight selected row */
        .highlight {
            background-color: #d9edf7;
        }
    </style>


</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="BODY" runat="Server">

    <div ng-app="myApp" ng-controller="myCtrl">
        <div class="fadeIn">
            <div ng-show="tblvisible">
                <h1>ORDER LIST
                </h1>
                <br />
                <table class="table  table-hover">
                    <thead>
                        <tr>
                            <th>S.NO</th>
                            <th>Food Item Name</th>
                            <th>Item Cost</th>
                            <th>Quantity</th>
                            <th>Total Amount</th>

                        </tr>
                    </thead>
                    <tbody>
                        <tr ng-repeat="item in orders" ng-class="{ 'highlight': isSelected(item) }" ng-click="toggleSelection(item)">
                            <td>{{$index+1 }}</td>
                            <td>{{ item.foodname }}</td>
                            <td>{{ item.cost }}</td>
                            <td>{{ item.quantity }}</td>
                            <td>{{ item.cost * item.quantity }}</td>
                        </tr>
                    </tbody>
                </table>
                <br />
                <div ng-show="paid">
                    <label>Total Amount to be Paid :       </label>

                    <label ng-model="total">{{total}}</label>
                    <br />
                    <br />
                    <input type="button" value="Continue To Pay" class="btn btn-success" ng-click="pay()" data-toggle="modal" data-target="#myModal" />

                    <br />
                    <br />
                </div>

            </div>
            <div ng-show="!paid">
                <label>Total Amount of {{total}} Paid Successfully. Check "<a href="MyOrders.aspx">My Orders</a>" to see your order details.     </label>
            </div>










            <div class="food-container">
                <div ng-repeat="food in foodItems track by $index" class="food-item-container">
                    <div class="food-item">
                        <img class="food-image" ng-src="{{ food.imageurl }}" alt="{{ food.foodname }}" />
                        <div class="food-details">
                            <%-- <p class="food-description">Description: {{ food.description }}</p>--%>
                            <p class="food-cost">Available: {{ food.available -  food.quantity }}</p>
                            <p class="food-cost">Cost: {{ food.cost }}</p>
                            <p class="food-cost">Total Cost: {{ food.cost * food.quantity}}</p>
                        </div>
                    </div>
                    <div>
                        <center>
                            <h2 class="food-name">{{ food.foodname }}</h2>
                        </center>
                    </div>
                    <div>
                        <div class="wrapper">
                            <span class="minus">
                                <button type="button" ng-click="decrement(food)">-</button></span>
                            <span class="num">
                                <button type="button">{{food.quantity}}</button></span>
                            <span class="plus">
                                <button type="button" ng-click="increment(food)">+</button></span>
                        </div>
                    </div>
                </div>
            </div>
        </div>


        <div class="modal fade" id="myModal">
            <div class="modal-dialog">
                <div class="modal-content">

                    <div class="modal-header">
                        <div class="row vd">
                            <div>
                                <h4 class="modal-title">Payment Information</h4>
                            </div>
                            <div></div>
                            <div class="x-button">
                                <button type="button" class="close" data-dismiss="modal">&times;</button>
                            </div>
                        </div>



                    </div>

                    <div class="modal-body">
                        <div id="qrcode" class="rcode">
                            <img ng-src="{{ paymentqr }}" class="qr" />

                            <br />
                            <asp:Label ID="foodNameLabel" runat="server" AssociatedControlID="foodName" CssClass="form-label">Transaction Number :</asp:Label>
                            <asp:RequiredFieldValidator ID="foodNameValidator" runat="server" ControlToValidate="foodName" ErrorMessage="*" CssClass="form-validation"></asp:RequiredFieldValidator><br />

                            <asp:TextBox ID="foodName" Width="100%" runat="server" CssClass="form-input form-control" ng-model="utrnumber"></asp:TextBox>
                            <ajax:FilteredTextBoxExtender runat="server" TargetControlID="foodName" FilterType="Numbers" />
                        </div>
                    </div>


                    <div class="modal-footer">

                        <button type="button" id="modalclose" class="btn btn-secondary" data-dismiss="modal">Close</button>

                        <button type="button" class="btn btn-primary" ng-click="placeordertest()" ng-disabled="!utrnumber || utrnumber.length < 10">Place Order</button>
                    </div>
                </div>
            </div>
        </div>



    </div>













    <script>

        var app = angular.module('myApp', []);

        app.controller('myCtrl', ['$http', '$scope', function ($http, $scope) {
            $scope.orders = []
            $scope.tblvisible = false;
            $scope.paymentqr = ""
            $scope.paid = true

            $.ajax({
                type: "POST",
                url: "Order.aspx/getfooditems",
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

            $scope.placeordertest = function () {

                console.log($scope.utrnumber)
                $.ajax({
                    type: "POST",
                    url: "Order.aspx/checktransaction",
                    data: "{ 'utrno': '" + $scope.utrnumber + "' }",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: OnSuccess,
                    failure: function (response) {
                        alert(response.d);
                    }
                });
                function OnSuccess(response) {

                    var data = response.d
                    if (data != 0) {

                        $scope.paid = false;
                        var modalclose = document.getElementById("modalclose")
                        modalclose.click()
                        var orderdata = JSON.stringify($scope.orders);
                        addorder(data, 'username', 'name', $scope.total, 'e', orderdata)


                        alert('Payment Received Succesfully.')
                    }
                    console.log(data)


                    $scope.$apply();
                }
            }

            var findtotal = function () {
                $scope.total = 0

                for (var i = 0; i < $scope.orders.length; i++) {
                    $scope.total += ($scope.orders[i]["cost"] * $scope.orders[i]["quantity"])
                }
            }





            $scope.increment = function (obj) {
                if ($scope.paid) {
                    $scope.tblvisible = true;
                    if (obj.available>obj.quantity) {
                        obj.quantity++;
                        if ($scope.orders.some(item => item.transid === obj.transid)) {

                        } else {

                            $scope.orders.push(obj)
                        }
                        findtotal();
                    } else {
                        alert("Item Not Available.")
                    }
                }
            }
            $scope.decrement = function (obj) {
                if ($scope.paid) {
                    if (obj.quantity > 0) {
                        obj.quantity = obj.quantity - 1;
                        if (obj.quantity === 0) {
                            for (var i = 0; i < $scope.orders.length; i++) {
                                if ($scope.orders[i]["transid"] === obj.transid) {
                                    $scope.orders.splice(i, 1);
                                }
                            }
                        }

                    }
                    if ($scope.orders.length === 0) {
                        $scope.tblvisible = false;
                    }
                    findtotal();
                }
            }

            $scope.selectedItem = null;

            $scope.isSelected = function (item) {
                return $scope.selectedItem === item;
            };

            $scope.toggleSelection = function (item) {
                $scope.selectedItem = ($scope.selectedItem === item) ? null : item;
            };

            $scope.pay = function () {
                var upiUrl = "upi://pay?pa=mohan326856@oksbi&pn=Vijay&cu=INR&am=" + $scope.total;
                $scope.paymentqr = "https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=" + encodeURIComponent(upiUrl);
            }

            var addorder = function (paymentid, userid, name, cost, ordertype, orderdata) {

                $.ajax({
                    type: "POST",
                    url: "Order.aspx/ins_order",
                    data: "{ 'paymentid': '" + paymentid + "', 'userid': '" + userid + "', 'name': '" + name + "', 'cost': '" + cost + "', 'ordertype': '" + ordertype + "', 'orderdata': '" + orderdata + "'}",
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: OnSuccess,
                    failure: function (response) {
                        alert(response.d);
                    }
                });
                function OnSuccess(response) {
                    var data = response.d.toString();
                    if (data.includes("already")) {
                        alert(data)

                    } else if (data.length == 6) {
                        alert('Your Order is been Placed Successfully. Order ID : ' + data + ' Check in "My Orders" Page')
                    }
                    console.log(data)
                }
            }


        }]);
    </script>

</asp:Content>



