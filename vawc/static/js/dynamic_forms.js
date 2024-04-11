function showToast(type, message) {
    var toastId = type === 'success' ? '#successToast' : '#errorToast';
    var toast = new bootstrap.Toast(document.querySelector(toastId));
    // Update toast message
    var toastBody = toastId + ' .toast-body';
    $(toastBody).text(message);
    // Show toast
    toast.show();
}
document.addEventListener("DOMContentLoaded", function() {
    const addVictimButton = document.getElementById("add-victim-form");
    const victimFormContainer = document.getElementById("victim-form_0"); // Update the target element
    const victimCountInput = document.getElementById("victim_count");


    // Add event listeners to text fields for initial validation
    const initialTextFields = document.querySelectorAll('#victim-form_0 input[type="text"]');
    initialTextFields.forEach(field => {
        field.addEventListener('input', validateVictimInput);
        field.addEventListener('focusout', validateVictimInput);
    });


    addVictimButton.addEventListener("click", function() {
        // Disable the button temporarily to prevent multiple clicks
        addVictimButton.disabled = true;

        const count = parseInt(victimCountInput.value);
        if (count >= 7) {
            showToast('error', 'You can only add up to 7 victims.');
            addVictimButton.disabled = false;
            return;
        }

        const clone = victimFormContainer.cloneNode(true);
        clearInputFields(clone); // Clear input fields of the cloned form
        // Update input field names and ids with appropriate indices
        clone.id = `victim-form_${count}`; // Update the ID of the cloned form
        clone.querySelectorAll('input, select').forEach(input => {
            const name = input.getAttribute('name');
            const id = input.getAttribute('id');
            if (name) {
                const newName = name.replace(/_\d+$/, match => `_${count}`);
                input.setAttribute('name', newName);
            }
            if (id) {
                const newId = id.replace(/_\d+$/, match => `_${count}`);
                input.setAttribute('id', newId);
            }
        });
    
        // Increment invalid-feedback IDs
        const invalidFeedbacks = clone.querySelectorAll('.invalid-feedback');
        invalidFeedbacks.forEach(feedback => {
            const id = feedback.getAttribute('class').split(' ')[1];
            if (id) {
                const newId = id.replace(/_\d+$/, match => `_${count}`);
                feedback.setAttribute('class', `invalid-feedback ${newId}`);
            }
        });
    
        const victimElement = clone.querySelector('#victim_counter')
        const countplusone = count + 1;
        victimElement.innerHTML = "Victim " + countplusone
    
        victimFormContainer.parentNode.appendChild(clone); // Append the cloned form to the parent
        victimCountInput.value = count + 1;
    
        // Enable the button after cloning is complete
        addVictimButton.disabled = false;
    
        // Reapply event listeners to text fields for validation
        const newTextFields = clone.querySelectorAll('input[type="text"]');
        newTextFields.forEach(field => {
            field.addEventListener('input', validateVictimInput);
            field.addEventListener('focusout', validateVictimInput);
        });

        // Scroll to the last form in the container
        clone.scrollIntoView({ behavior: 'smooth', block: 'start' });

        // Disable the progress button and next button again after adding the new form
        const progressButton = document.querySelector('button[title="Perpetrator Information"]');
        const nextButton = document.querySelector('.next-perpetrator-button');
        if (progressButton && nextButton) {
            progressButton.disabled = true;
            nextButton.disabled = true;
        }
    });

    // Function to validate input fields
    function validateVictimInput(event) {
        const input = event.target;
        const fieldName = input.getAttribute('name');

        // Check if the field is a house information field
        const isHouseInfoField = fieldName && fieldName.includes('victim-house-info');

        // Exclude numerical validation for house information field
        if (!isHouseInfoField && /[\d]/.test(input.value)) {
            input.value = input.value.replace(/\d/g, ''); // Remove numerical characters
        }

        // Set maximum length to 150 for house information field
        const maxLength = isHouseInfoField ? 150 : 50;

        // Check if the input value exceeds the maximum length
        const isOverMaxLength = input.value.length > maxLength;

        // Check if the input is empty
        const isEmpty = !input.value.trim();

        // Determine if the input is invalid
        const isInvalid = isEmpty || isOverMaxLength;

        const feedback = input.nextElementSibling;
        if (isOverMaxLength) {
            feedback.textContent = `Only up to ${maxLength} characters.`;
            input.value = input.value.slice(0, maxLength); // Limit input to maxLength characters
        } else if (isEmpty) {
            feedback.textContent = "This is a required input.";
        } else {
            feedback.textContent = "";
        }
        
        // Add or remove the 'is-invalid' class based on input validity
        if (isInvalid) {
            input.classList.add('is-invalid');
            input.disabled = false; // Disable input to prevent further typing
        } else {
            input.classList.remove('is-invalid');
            input.disabled = false; // Re-enable input if it was disabled
        }
    
        // Check if there are any invalid inputs
        const allInputs = document.querySelectorAll('[id^="victim-form_"] input[type="text"]');
        const hasErrors = document.querySelectorAll('.is-invalid').length > 0;
        const hasEmptyInputs = Array.from(allInputs).some(input => input.value.trim() === '');
    
        // Enable or disable the buttons based on the validation status
        const progressButton = document.querySelector('button[title="Perpetrator Information"]');
        const nextButton = document.querySelector('.next-perpetrator-button');
        if (progressButton) {
            progressButton.disabled = hasErrors; // Disable the progress button if there are errors
            progressButton.disabled = hasEmptyInputs;
        }
        if (nextButton) {
            nextButton.disabled = hasErrors; // Disable the next button if there are errors
            nextButton.disabled = hasEmptyInputs;
        }
    }


    function clearInputFields(form) {
        const inputs = form.querySelectorAll('input[type="text"], input[type="number"]');
        inputs.forEach(input => {
            input.value = ''; // Clear input value
        });
        const selects = form.querySelectorAll('select');
        selects.forEach(select => {
            select.selectedIndex = 0; // Reset select options to default
        });
    }
});

document.addEventListener("DOMContentLoaded", function() {
    const addPerpetratorButton = document.getElementById("add-perpetrator-form");
    const perpetratorFormContainer = document.getElementById("perpetrator-form_0");
    const perpetratorCountInput = document.getElementById("perpetrator_count");

    // Add event listeners to text fields for initial validation
    const initialTextFields = document.querySelectorAll('#perpetrator-form_0 input[type="text"]');
    initialTextFields.forEach(field => {
        field.addEventListener('input', validatePerpetratorInput);
        field.addEventListener('focusout', validatePerpetratorInput);
    });

    addPerpetratorButton.addEventListener("click", function() {
        addPerpetratorButton.disabled = true;

        const count = parseInt(perpetratorCountInput.value);
        if (count >= 7) {
            showToast('error', 'You can only add up to 7 perpetrators.');
            addPerpetratorButton.disabled = false;
            return;
        }

        const clone = perpetratorFormContainer.cloneNode(true);
        clearInputFields(clone);
        clone.id = `perpetrator-form_${count}`;
        clone.querySelectorAll('input, select').forEach(input => {
            const name = input.getAttribute('name');
            const id = input.getAttribute('id');
            if (name) {
                const newName = name.replace(/_\d+$/, match => `_${count}`);
                input.setAttribute('name', newName);
            }
            if (id) {
                const newId = id.replace(/_\d+$/, match => `_${count}`);
                input.setAttribute('id', newId);
            }
            const label = clone.querySelector(`[for="${id}"]`);
            if (label) {
                label.setAttribute('for', id.replace(/_\d+$/, match => `_${count}`));
            }
        });

        // Increment invalid-feedback IDs
        const invalidFeedbacks = clone.querySelectorAll('.invalid-feedback');
        invalidFeedbacks.forEach(feedback => {
            const id = feedback.getAttribute('class').split(' ')[1];
            if (id) {
                const newId = id.replace(/_\d+$/, match => `_${count}`);
                feedback.setAttribute('class', `invalid-feedback ${newId}`);
            }
        });

        const perpetratorElement = clone.querySelector('#perpetrator_counter')
        const countplusone = count + 1;
        perpetratorElement.innerHTML = "Perpetrator " + countplusone

        perpetratorFormContainer.parentNode.appendChild(clone);
        perpetratorCountInput.value = count + 1;

        addPerpetratorButton.disabled = false;

        // Reapply event listeners to text fields for validation
        const newTextFields = clone.querySelectorAll('input[type="text"]');
        newTextFields.forEach(field => {
            field.addEventListener('input', validatePerpetratorInput);
            field.addEventListener('focusout', validatePerpetratorInput);
        });

        clone.scrollIntoView({ behavior: 'smooth', block: 'start' });

        // Disable the progress button and next button again after adding the new form
        const progressButton = document.querySelector('button[title="Incident Information"]');
        const nextButton = document.querySelector('.next-incident-button');
        if (progressButton && nextButton) {
            progressButton.disabled = true;
            nextButton.disabled = true;
        }
    });

    // Function to validate input fields
    function validatePerpetratorInput(event) {
        const input = event.target;
        const fieldName = input.getAttribute('name');

        // Check if the field is a house information field
        const isHouseInfoField = fieldName && fieldName.includes('perp-address-info');
        // Exclude numerical validation for house information field
        if (!isHouseInfoField && /[\d]/.test(input.value)) {
            input.value = input.value.replace(/\d/g, ''); // Remove numerical characters
        }

        // Set maximum length to 150 for house information field
        const maxLength = isHouseInfoField ? 150 : 50;

        // Check if the input value exceeds the maximum length
        const isOverMaxLength = input.value.length > maxLength;

        // Check if the input is empty
        const isEmpty = !input.value.trim();

        // Determine if the input is invalid
        const isInvalid = isEmpty || isOverMaxLength;

        const feedback = input.nextElementSibling;
        if (isOverMaxLength) {
            feedback.textContent = `Only up to ${maxLength} characters.`;
            input.value = input.value.slice(0, maxLength); // Limit input to maxLength characters
        } else if (isEmpty) {
            feedback.textContent = "This is a required input.";
        } else {
            feedback.textContent = "";
        }
        
        // Add or remove the 'is-invalid' class based on input validity
        if (isInvalid) {
            input.classList.add('is-invalid');
            input.disabled = false; // Disable input to prevent further typing
        } else {
            input.classList.remove('is-invalid');
            input.disabled = false; // Re-enable input if it was disabled
        }

        // Check if there are any invalid inputs
        const allInputs = document.querySelectorAll('[id^="perpetrator-form_"] input[type="text"]');
        const hasErrors = document.querySelectorAll('.is-invalid').length > 0;
        const hasEmptyInputs = Array.from(allInputs).some(input => input.value.trim() === '');
    
        // Enable or disable the buttons based on the validation status
        const progressButton = document.querySelector('button[title="Incident Information"]');
        const nextButton = document.querySelector('.next-incident-button');
        if (progressButton) {
            progressButton.disabled = hasErrors; // Disable the progress button if there are errors
            progressButton.disabled = hasEmptyInputs;
        }
        if (nextButton) {
            nextButton.disabled = hasErrors; // Disable the next button if there are errors
           nextButton.disabled = hasEmptyInputs;
        }
    }


    function clearInputFields(form) {
        const inputs = form.querySelectorAll('input[type="text"], input[type="number"]');
        inputs.forEach(input => {
            input.value = '';
        });
        const selects = form.querySelectorAll('select');
        selects.forEach(select => {
            select.selectedIndex = 0;
        });
    }

});












