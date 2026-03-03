function addAddressListener(formElement, formType = '', count = 0) {
    if (!formElement) return;

    const prefix = formType ? `${formType}_` : '';
    const suffix = (formType && count) ? `_${count}` : '';

    // Helper: attempt multiple selector combinations
    function getField(name) {
        return (
            formElement.querySelector(`#${prefix}${name}${suffix}`) ||  // prefix + suffix
            formElement.querySelector(`#${prefix}${name}`) ||          // prefix only
            formElement.querySelector(`#${name}`)                      // base only
        );
    }

    const region = getField('region');
    const province = getField('province');
    const city = getField('city');
    const barangay = getField('barangay');

    if (!region || !province || !city || !barangay) return;

    const selectedRegion = region.getAttribute('data-selected');
    const selectedProvince = province.getAttribute('data-selected');
    const selectedCity = city.getAttribute('data-selected');
    const selectedBarangay = barangay.getAttribute('data-selected');

    console.log('Selected Region:', selectedRegion);
    console.log('Selected Province:', selectedProvince);
    console.log('Selected City:', selectedCity);
    console.log('Selected Barangay:', selectedBarangay);

    disableSelect(province);
    disableSelect(city);
    disableSelect(barangay);

    if (selectedRegion) {
        region.value = selectedRegion;
        setGeoSelect(province, {
            filter: region.options[region.selectedIndex].dataset.code,
            action: 'province',
            csrfmiddlewaretoken: getCSRF(),
        }, selectedProvince).then(() => {
            if (selectedProvince) {
                enableSelect(province);
                province.value = selectedProvince;
                setGeoSelect(city, {
                    filter: province.options[province.selectedIndex].dataset.code,
                    action: 'city',
                    csrfmiddlewaretoken: getCSRF(),
                }, selectedCity).then(() => {
                    if (selectedCity) {
                        enableSelect(city);
                        city.value = selectedCity;
                        setGeoSelect(barangay, {
                            filter: city.options[city.selectedIndex].dataset.code,
                            action: 'barangay',
                            csrfmiddlewaretoken: getCSRF(),
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

    // Event listeners
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
                csrfmiddlewaretoken: getCSRF(),
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
                csrfmiddlewaretoken: getCSRF(),
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
                csrfmiddlewaretoken: getCSRF(),
            });
            enableSelect(barangay);
        } else {
            disableSelect(barangay);
        }
    });
}
// CSRF getter utility
function getCSRF() {
    return (
        typeof csrf_token_victim !== 'undefined' ? csrf_token_victim :
        typeof csrf_token_perpetrator !== 'undefined' ? csrf_token_perpetrator :
        typeof csrf_token_contact !== 'undefined' ? csrf_token_contact :
        typeof csrf_token_generic !== 'undefined' ? csrf_token_generic :
        ''
    );
}

document.addEventListener('DOMContentLoaded', () => {
    const addvictimform = document.querySelector("#add_new_victim_form");
    addAddressListener(addvictimform, 'victim');

    const form = document.querySelector("#add_new_perpetrator_form");
    addAddressListener(form, 'perpetrator');
});


// Helper to populate and optionally select a value
async function setGeoSelect(geoTypeInput, formData, selectedValue = null) {
    const res = await fetch('/pages/select-address/', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'X-CSRFToken': csrf_token_victim || csrf_token_perpetrator || csrf_token_contact || csrf_token_generic,
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
        geoTypeInput.appendChild(option);
    });

    // Set selected value AFTER all options are added
    if (selectedValue) {
        geoTypeInput.value = selectedValue;
    }

    return;
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
