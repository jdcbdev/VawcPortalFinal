function addAddressListener(formElement, formType, count = 0) {
    let region, province, city, barangay;

    if (formType === 'perp' || formType === 'victim') {
        region = formElement.querySelector(`#${formType}_region_${count}`);
        province = formElement.querySelector(`#${formType}_province_${count}`);
        city = formElement.querySelector(`#${formType}_city_${count}`);
        barangay = formElement.querySelector(`#${formType}_barangay_${count}`);
    } else {
        region = formElement.querySelector(`#${formType}_region`);
        province = formElement.querySelector(`#${formType}_province`);
        city = formElement.querySelector(`#${formType}_city`);
        barangay = formElement.querySelector(`#${formType}_barangay`);
    }

    // Do not disable anything initially (requirement 2)
    // Ensure dropdowns retain selected value after reload (requirement 1)
    const selectedProvince = province.getAttribute('data-selected');
    const selectedCity = city.getAttribute('data-selected');
    const selectedBarangay = barangay.getAttribute('data-selected');

    if (region.value) {
        setGeoSelect(province, {
            filter: region.options[region.selectedIndex].dataset.code,
            action: 'province',
            csrfmiddlewaretoken: csrf_token,
        }, selectedProvince).then(() => {
            if (province.value) {
                setGeoSelect(city, {
                    filter: province.options[province.selectedIndex].dataset.code,
                    action: 'city',
                    csrfmiddlewaretoken: csrf_token,
                }, selectedCity).then(() => {
                    if (city.value) {
                        setGeoSelect(barangay, {
                            filter: city.options[city.selectedIndex].dataset.code,
                            action: 'barangay',
                            csrfmiddlewaretoken: csrf_token,
                        }, selectedBarangay);
                    }
                });
            }
        });
    }

    region.addEventListener('change', (e) => {
        const regionId = e.target.options[e.target.selectedIndex].dataset.code;

        resetSelect(province);
        resetSelect(city);
        resetSelect(barangay);

        if (regionId) {
            setGeoSelect(province, {
                filter: regionId,
                action: 'province',
                csrfmiddlewaretoken: csrf_token,
            });
        }
    });

    province.addEventListener('change', (e) => {
        const provinceId = e.target.options[e.target.selectedIndex].dataset.code;

        resetSelect(city);
        resetSelect(barangay);

        if (provinceId) {
            setGeoSelect(city, {
                filter: provinceId,
                action: 'city',
                csrfmiddlewaretoken: csrf_token,
            });
        }
    });

    city.addEventListener('change', (e) => {
        const cityId = e.target.options[e.target.selectedIndex].dataset.code;

        resetSelect(barangay);

        if (cityId) {
            setGeoSelect(barangay, {
                filter: cityId,
                action: 'barangay',
                csrfmiddlewaretoken: csrf_token,
            });
        }
    });
}


async function setGeoSelect(geoTypeInput, formData, selectedValue = null) {
    const res = await fetch('/pages/select-address/', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'X-CSRFToken': csrf_token
        },
        body: JSON.stringify(formData),
    });

    const data = await res.json();

    const blankOption = document.createElement('option');
    blankOption.textContent = '--Select Option--';
    blankOption.value = '';
    geoTypeInput.replaceChildren();  // clear all options
    geoTypeInput.appendChild(blankOption);

    data.forEach(item => {
        const option = document.createElement('option');
        option.dataset.code = item.code;
        option.value = item.name;
        option.textContent = item.name;

        if (item.name === selectedValue) {
            option.selected = true;
        }

        geoTypeInput.appendChild(option);
    });
}

function resetSelect(selectElement) {
    selectElement.innerHTML = '';
    const blankOption = document.createElement('option');
    blankOption.textContent = '--Select Option--';
    blankOption.value = '';
    selectElement.appendChild(blankOption);
}
