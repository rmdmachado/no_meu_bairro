$(document).ready(function () {

    function findLocation() {
        navigator.geolocation.getCurrentPosition(
            foundLocation,
            noLocation,
            { enableHighAccuracy: true, timeout: 15000, maximumAge: 0 }
        );
    }

    function foundLocation(position) {
        var latitude = position.coords.latitude;
        var longitude = position.coords.longitude;
        document.getElementById('latitude').value = latitude;
        document.getElementById('longitude').value = longitude;
        document.getElementById('status_message').innerHTML = 'Nota: A sua localização foi recolhida automaticamente.'
    }

    function noLocation() {
        document.getElementById('status_message').innerHTML = 'Não foi possível validar a localização.<br/> Verifice as definições do seu browser.'
    }

    if ($('form#new_report').length > 0) {
        findLocation();
    }

});
