// JavaScript Document

var fragments     = []


// this is the function returns a Kendo UI DataSource
// which reads the top threads off of the programming.reddit
// datasource
var dataSource = new kendo.data.DataSource({
            data: fragments,
            pageSize: 48
});




// Wait for PhoneGap to load
document.addEventListener("deviceready", onDeviceReady, false);

// PhoneGap is ready
function onDeviceReady() {
    $.getJSON("http://yworker.herokuapp.com/apa/jeans", function(data){
        /*
        if(data){
            $.each(data.data, function(key, val){
                fragments.push(val);
            });

            dataSource.read();
        }
        */
        console.log("Haleluyah! \n");
    }).error(function(err){ console.log("Error occurred: " + err); });


    getLocation();
}

function getLocation() {
    navigator.geolocation.getCurrentPosition(onGeolocationSuccess, onGeolocationError);
}

//=======================Say Hello (Page 1) Operations=======================//
function sayHello() {
    var sayHelloInputElem = document.getElementById('helloWorldInput');
    var sayHelloTextElem = document.getElementById('helloWorldText');
    var inputText = document.getElementById('txtName');

    sayHelloTextElem.innerHTML = 'Hello, ' + inputText.value + '!';
    sayHelloTextElem.style.display = 'block';
    sayHelloInputElem.style.display = 'none';
}

function sayHelloReset() {
    var sayHelloInputElem = document.getElementById('helloWorldInput');
    var sayHelloTextElem = document.getElementById('helloWorldText');
    var inputText = document.getElementById('txtName');

    inputText.value = '';
    sayHelloTextElem.style.display = 'none';
    sayHelloInputElem.style.display = 'block';
}

//=======================Geolocation Operations=======================//
// onGeolocationSuccess Geolocation
function onGeolocationSuccess(position) {
    // Use Google API to get the location data for the current coordinates
    var geocoder = new google.maps.Geocoder();
    var latlng = new google.maps.LatLng(position.coords.latitude, position.coords.longitude);
    geocoder.geocode({ "latLng": latlng }, function (results, status) {
        if (status == google.maps.GeocoderStatus.OK) {
            if ((results.length > 1) && results[1]) {
                $("#myLocation").html(results[1].formatted_address);
            }
        }
    });

    // Use Google API to get a map of the current location
    // http://maps.googleapis.com/maps/api/staticmap?size=280x300&maptype=hybrid&zoom=16&markers=size:mid%7Ccolor:red%7C42.375022,-71.273729&sensor=true
    var googleApis_map_Url = 'http://maps.googleapis.com/maps/api/staticmap?size=300x300&maptype=hybrid&zoom=16&sensor=true&markers=size:mid%7Ccolor:red%7C' + latlng;
    var mapImg = '<img src="' + googleApis_map_Url + '" />';
    $("#map_canvas").html(mapImg);
}

// onGeolocationError Callback receives a PositionError object
function onGeolocationError(error) {
    $("#myLocation").html("<span class='err'>" + error.message + "</span>");
}