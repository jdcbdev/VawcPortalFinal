function addAddressListener(formElement, formType, count = 0) {
    // marked
    let barangay = null
    let city = null
    let province = null

    if(formType === 'perp' || formType === 'victim') {
        region = formElement.querySelector(`#${formType}_region_${count}`)
        province = formElement.querySelector(`#${formType}_province_${count}`)
        city = formElement.querySelector(`#${formType}_city_${count}`)
        barangay = formElement.querySelector(`#${formType}_barangay_${count}`)
    } else {
        region = formElement.querySelector(`#${formType}_region`)   
        province = formElement.querySelector(`#${formType}_province`)
        city = formElement.querySelector(`#${formType}_city`)
        barangay = formElement.querySelector(`#${formType}_barangay`)   
    }
    province.disabled = true
    city.disabled = true
    barangay.disabled = true

    region.addEventListener('change', (e) => {

        const regionId = e.target.options[e.target.selectedIndex].dataset.code

        if(regionId) {
            setGeoSelect(city, {
                filter: regionId,
                action: 'province',
                csrfmiddlewaretoken: csrf_token,
            }, {passive: true})
            province.disabled=false
        }

    })

    province.addEventListener('change', (e) => {

        const provinceId = e.target.options[e.target.selectedIndex].dataset.code

        if(provinceId) {
            setGeoSelect(city, {
                filter: provinceId,
                action: 'city',
                csrfmiddlewaretoken: csrf_token,
            }, {passive: true})
            city.disabled=false
        }

    })

    city.addEventListener('change', (e) => {

        const cityId = e.target.options[e.target.selectedIndex].dataset.code
        if(cityId) {
            setGeoSelect(barangay, {
                filter: cityId,
                action: 'barangay',
                csrfmiddlewaretoken: csrf_token,
            }, {passive: true})
            barangay.disabled=false
        }
    })
    
}


async function setGeoSelect(geoTypeInput, formData) {

    const res = await fetch('/pages/select-address/', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'X-CSRFToken': csrf_token
        },
        body: JSON.stringify(formData),
    })

    const data = await res.json()

    const blankOption = document.createElement('option')
    blankOption.textContent = '--Select Option--'
    blankOption.value = ''
    // clear all options in select element
    geoTypeInput.replaceChildren()

    // apend blank option as the first selected options
    geoTypeInput.appendChild(blankOption)
    // apped data to respective inputs
    data.forEach(item => {
        const option = document.createElement('option')
        option.dataset.code = item.code
        option.value = item.name
        option.textContent = item.name
        geoTypeInput.appendChild(option)
    })
}