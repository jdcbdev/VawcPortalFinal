document.addEventListener("DOMContentLoaded", function () {
    const messages = [
        "Your Voice Matters. Your Safety Comes First.",
        "We Stand With You. You Are Not Alone.",
        "Break the Silence. End the Violence.",
        "Together, We Build a Safer Future.",
        "Need Help? Support is Just a Click Away."
    ];

    let index = 0;
    let charIndex = 0;
    const typingSpeed = 50;
    const erasingSpeed = 30;
    const delayBetweenMessages = 2000;
    const typingText = document.querySelector(".typing-text");

    
    if (!typingText) return; // Exit if element doesn't exist
    function formatTextWithBreaks(text) {
        return text.replace(/\.(?=\s)/g, ".<br>");
    }



    function typeMessage() {
        if (charIndex < messages[index].length) {
            let currentText = messages[index].substring(0, charIndex + 1);
            typingText.innerHTML = formatTextWithBreaks(currentText);
            charIndex++;
            setTimeout(typeMessage, typingSpeed);
        } else {
            setTimeout(eraseMessage, delayBetweenMessages);
        }
    }

    function eraseMessage() {
        if (charIndex > 0) {
            let currentText = messages[index].substring(0, charIndex - 1);
            typingText.innerHTML = formatTextWithBreaks(currentText);
            charIndex--;
            setTimeout(eraseMessage, erasingSpeed);
        } else {
            index = (index + 1) % messages.length;
            setTimeout(typeMessage, typingSpeed);
        }
    }
    typeMessage();
});