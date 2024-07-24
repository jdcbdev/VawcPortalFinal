//DOM elements
const DOMstrings = {
    stepsBtnClass: 'multisteps-form__progress-btn',
    stepsBtns: document.querySelectorAll(`.multisteps-form__progress-btn`),
    stepsBar: document.querySelector('.multisteps-form__progress'),
    stepsForm: document.querySelector('.multisteps-form__form'),
    stepsFormTextareas: document.querySelectorAll('.multisteps-form__textarea'),
    stepFormPanelClass: 'multisteps-form__panel',
    stepFormPanels: document.querySelectorAll('.multisteps-form__panel'),
    stepPrevBtnClass: 'js-btn-prev',
    stepNextBtnClass: 'js-btn-next' };
  
  
  //remove class from a set of items
  const removeClasses = (elemSet, className) => {
  
    elemSet.forEach(elem => {
  
      elem.classList.remove(className);
  
    });
  
  };
  
  //return exect parent node of the element
  const findParent = (elem, parentClass) => {
  
    let currentNode = elem;
  
    while (!currentNode.classList.contains(parentClass)) {
      currentNode = currentNode.parentNode;
    }
  
    return currentNode;
  
  };
  
  //get active button step number
  const getActiveStep = elem => {
    return Array.from(DOMstrings.stepsBtns).indexOf(elem);
  };
  
  //set all steps before clicked (and clicked too) to active
  const setActiveStep = activeStepNum => {
  
    //remove active state from all the state
    removeClasses(DOMstrings.stepsBtns, 'js-active');
  
    //set picked items to active
    DOMstrings.stepsBtns.forEach((elem, index) => {
  
      if (index <= activeStepNum) {
        elem.classList.add('js-active');
      }
  
    });
  };
  
  //get active panel
  const getActivePanel = () => {
  
    let activePanel;
  
    DOMstrings.stepFormPanels.forEach(elem => {
  
      if (elem.classList.contains('js-active')) {
  
        activePanel = elem;
  
      }
  
    });
  
    return activePanel;
  
  };
  
  //open active panel (and close unactive panels)
  const setActivePanel = activePanelNum => {
  
    //remove active class from all the panels
    removeClasses(DOMstrings.stepFormPanels, 'js-active');
  
    //show active panel
    DOMstrings.stepFormPanels.forEach((elem, index) => {
      if (index === activePanelNum) {
        console.log(elem)
        elem.classList.add('js-active');
  
        //setFormHeight(elem);
  
      }
    });
  
  };
  
  //set form height equal to current panel height
  // const formHeight = activePanel => {
  
  //   const activePanelHeight = activePanel.offsetHeight;
  
  //   //DOMstrings.stepsForm.style.height = `${activePanelHeight}px`;
  
  // };
  
  // const setFormHeight = () => {
  //   const activePanel = getActivePanel();
  
  //   formHeight(activePanel);
  // };
  
  //STEPS BAR CLICK FUNCTION
  DOMstrings.stepsBar.addEventListener('click', e => {
  
    //check if click target is a step button
    const eventTarget = e.target;
  
    if (!eventTarget.classList.contains(`${DOMstrings.stepsBtnClass}`)) {
      return;
    }
  
    //get active button step number
    const activeStep = getActiveStep(eventTarget);
  
    //set all steps before clicked (and clicked too) to active
    setActiveStep(activeStep);
  
    //open active panel
    setActivePanel(activeStep);
  });
  
  //PREV/NEXT BTNS CLICK
  DOMstrings.stepsForm.addEventListener('click', e => {
  
    const eventTarget = e.target;
  
    //check if we clicked on `PREV` or NEXT` buttons
    if (!(eventTarget.classList.contains(`${DOMstrings.stepPrevBtnClass}`) || eventTarget.classList.contains(`${DOMstrings.stepNextBtnClass}`)))
    {
      return;
    }
  
    //find active panel
    const activePanel = findParent(eventTarget, `${DOMstrings.stepFormPanelClass}`);
  
    let activePanelNum = Array.from(DOMstrings.stepFormPanels).indexOf(activePanel);
  
    //set active step and active panel onclick
    if (eventTarget.classList.contains(`${DOMstrings.stepPrevBtnClass}`)) {
      activePanelNum--;
  
    } else {
      const activeForm = getActivePanel()
      if (!validateInputs(activeForm)) {
        return
      }
      activePanelNum++;
  
    }
  
    setActiveStep(activePanelNum);
    setActivePanel(activePanelNum);
  
    window.scrollTo({top: 0})
  });
  
  //SETTING PROPER FORM HEIGHT ONLOAD
  //window.addEventListener('load', setFormHeight, false);
  
  //SETTING PROPER FORM HEIGHT ONRESIZE
 // window.addEventListener('resize', setFormHeight, false);
  
  //changing animation via animation select !!!YOU DON'T NEED THIS CODE (if you want to change animation type, just change form panels data-attr)
  
  const setAnimationType = newType => {
    DOMstrings.stepFormPanels.forEach(elem => {
      elem.dataset.animation = newType;
    });
  };

  window.addEventListener('load', () => {
    document.querySelector('.multiform-loading').style.display = 'none';
  })

  document.getElementById('incident-evidence').addEventListener('input', function(event) {

    const files = event.target.files;
    const imageContainer = document.getElementById('photo-evidence-container');
    imageContainer.innerHTML = ''; // Clear any existing images
    
    Array.from(files).forEach((file, index) => {
        const reader = new FileReader();
        reader.onload = function(e) {
            const img = document.createElement('img');
            img.src = e.target.result;
            img.alt = 'evidence_' + (index + 1);
            img.style.height = '100%';
            img.style.border = '1px solid #dcdcdc';
            imageContainer.appendChild(img);
        };
        reader.readAsDataURL(file);
    });
  });
  
  //selector onchange - changing animation
  // const animationSelect = document.querySelector('.pick-animation__select');
  
  // animationSelect.addEventListener('change', () => {
  //   const newAnimationType = animationSelect.value;
  
  //   setAnimationType(newAnimationType);
  // });
  
function validateInputs(formElement) {

  const required_inputs = formElement.querySelectorAll('.req-inp')
  const max_length = 50;
  let all_valid = true

  required_inputs.forEach(input => {
    const feedback = input.nextElementSibling;
    
    if (input.value.length <= 0) {
  
      feedback.textContent = "This is a required input.";
      input.classList.add('is-invalid');

      all_valid = false
    } else {
      feedback.textContent = "";
      input.classList.remove('is-invalid');
    }

  })

  return all_valid

}



function setCustomGender(selectInput) {
  const customInput = selectInput.parentElement.querySelector('.custom-gender')
  // retrieve the element with custom as option
  const customGenderOption = (() => {
    for(let i = 0; i < selectInput.options.length; i++){
      if (selectInput.options[i].textContent == 'Custom') {
        return selectInput.options[i]
      }
    }
    return null
  })();

  customInput.style.display = 'none'

  // change visibility of custom input
  selectInput.addEventListener('change', () => {
    if(selectInput.options[selectInput.selectedIndex].textContent == 'Custom') {
      customInput.style.display = 'block'
    } else {
      customInput.style.display = 'none'
    } 
  })

  

  // update the value of the <option>custom based on sibling custom input
  customInput.addEventListener('input', () => {
    customGenderOption.value = customInput.value
    console.log(customInput.value)
    console.log(customGenderOption.value)
  })
}

setCustomGender(document.querySelector('#victim-sex_0'))