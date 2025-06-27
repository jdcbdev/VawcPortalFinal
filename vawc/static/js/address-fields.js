function addAddressListener(formElement, formType, count = 0) {
    let region, province, city, barangay;

    if (formType === 'perpetrator' || formType === 'victim') {
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

    const selectedRegion = region.getAttribute('data-selected');
    const selectedProvince = province.getAttribute('data-selected');
    const selectedCity = city.getAttribute('data-selected');
    const selectedBarangay = barangay.getAttribute('data-selected');

    // Always start with children disabled
    disableSelect(province);
    disableSelect(city);
    disableSelect(barangay);

    // Populate and enable selects if values are saved
    if (selectedRegion) {
        region.value = selectedRegion;
        setGeoSelect(province, {
            filter: region.options[region.selectedIndex].dataset.code,
            action: 'province',
            csrfmiddlewaretoken: csrf_token_victim ? csrf_token_victim : csrf_token_perpetrator,
        }, selectedProvince).then(() => {
            if (selectedProvince) {
                enableSelect(province);
                province.value = selectedProvince;
                setGeoSelect(city, {
                    filter: province.options[province.selectedIndex].dataset.code,
                    action: 'city',
                    csrfmiddlewaretoken: csrf_token_victim ? csrf_token_victim : csrf_token_perpetrator,
                }, selectedCity).then(() => {
                    if (selectedCity) {
                        enableSelect(city);
                        city.value = selectedCity;
                        setGeoSelect(barangay, {
                            filter: city.options[city.selectedIndex].dataset.code,
                            action: 'barangay',
                            csrfmiddlewaretoken: csrf_token_victim ? csrf_token_victim : csrf_token_perpetrator,
                        }, selectedBarangay).then(() => {
                            if (selectedBarangay) {
                                enableSelect(barangay);
                                barangay.value = selectedBarangay;
                            }
                        });
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
        disableSelect(city);
        disableSelect(barangay);

        if (regionId) {
            setGeoSelect(province, {
                filter: regionId,
                action: 'province',
                csrfmiddlewaretoken: csrf_token_victim ? csrf_token_victim : csrf_token_perpetrator,
            });
            enableSelect(province);
        } else {
            disableSelect(province);
        }
    });

    province.addEventListener('change', (e) => {
        const provinceId = e.target.options[e.target.selectedIndex].dataset.code;

        resetSelect(city);
        resetSelect(barangay);
        disableSelect(barangay);

        if (provinceId) {
            setGeoSelect(city, {
                filter: provinceId,
                action: 'city',
                csrfmiddlewaretoken: csrf_token_victim ? csrf_token_victim : csrf_token_perpetrator,
            });
            enableSelect(city);
        } else {
            disableSelect(city);
        }
    });

    city.addEventListener('change', (e) => {
        const cityId = e.target.options[e.target.selectedIndex].dataset.code;

        resetSelect(barangay);

        if (cityId) {
            setGeoSelect(barangay, {
                filter: cityId,
                action: 'barangay',
                csrfmiddlewaretoken: csrf_token_victim ? csrf_token_victim : csrf_token_perpetrator,
            });
            enableSelect(barangay);
        } else {
            disableSelect(barangay);
        }
    });
}

// Helper to populate and optionally select a value
async function setGeoSelect(geoTypeInput, formData, selectedValue = null) {
    const res = await fetch('/pages/select-address/', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'X-CSRFToken': csrf_token_victim ? csrf_token_victim : csrf_token_perpetrator,
        },
        body: JSON.stringify(formData),
    });

    const data = await res.json();

    const blankOption = document.createElement('option');
    blankOption.textContent = '--Select Option--';
    blankOption.value = '';
    geoTypeInput.replaceChildren();
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

// Helpers
function resetSelect(selectElement) {
    selectElement.innerHTML = '';
    const blankOption = document.createElement('option');
    blankOption.textContent = '--Select Option--';
    blankOption.value = '';
    selectElement.appendChild(blankOption);
    selectElement.value = '';
}

function disableSelect(el) {
    el.disabled = true;
}

function enableSelect(el) {
    el.disabled = false;
}
