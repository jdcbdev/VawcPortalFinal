function addPoliceStationListener(formElement, count = 0) {
    const region = formElement.querySelector(`#region_${count}`);
    const province = formElement.querySelector(`#province_${count}`);
    const station = formElement.querySelector(`#station_${count}`);

    province.disabled = true;
    station.disabled = true;

    region.addEventListener('change', (e) => {
        const regionId = e.target.value;
        if (regionId) {
            setGeoSelect(province, {
                filter: regionId,
                action: 'province',
                csrfmiddlewaretoken: csrf_token
            });
            province.disabled = false;
        }
    });

    province.addEventListener('change', (e) => {
        const provinceId = e.target.value;
        if (provinceId) {
            setGeoSelect(station, {
                filter: provinceId,
                action: 'station',
                csrfmiddlewaretoken: csrf_token
            });
            station.disabled = false;
        }
    });
}

async function setGeoSelect(selectElement, formData) {
    const res = await fetch('/pages/select-police-station/', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
            'X-CSRFToken': csrf_token
        },
        body: new URLSearchParams(formData)
    });

    const data = await res.json();

    selectElement.innerHTML = ''; // clear all
    const blankOption = document.createElement('option');
    blankOption.textContent = '--Select Option--';
    blankOption.value = '';
    selectElement.appendChild(blankOption);

    data.forEach(item => {
        const option = document.createElement('option');
        option.value = item.name;
        option.textContent = item.name;
        option.dataset.code = item.code;
        selectElement.appendChild(option);
    });
}

document.addEventListener('DOMContentLoaded', function () {
    const formElement = document.getElementById('addAccountForm');
    addPoliceStationListener(formElement, 0);
});
