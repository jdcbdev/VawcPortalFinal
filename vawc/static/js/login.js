document.addEventListener("DOMContentLoaded", function () {
    const messages = [
        "Your Voice Matters. Your Safety Comes First.",
        "We Stand With You. You Are Not Alone.",
        "Break the Silence. End the Violence.",
        "Together, We Build a Safer Future.",
        "Need Help? Reach Out. Support is Just a Click Away."
    ];

    let index = 0;
    let charIndex = 0;
    const typingSpeed = 50;
    const erasingSpeed = 30;
    const delayBetweenMessages = 2000;
    const typingText = document.querySelector(".typing-text");

    function typeMessage() {
        if (charIndex < messages[index].length) {
            let currentChar = messages[index][charIndex];

            if (currentChar === "." && charIndex !== messages[index].length - 1) {
                typingText.innerHTML += ".<br>";
            } else {
                typingText.innerHTML += currentChar;
            }

            charIndex++;
            setTimeout(typeMessage, typingSpeed);
        } else {
            setTimeout(eraseMessage, delayBetweenMessages);
        }
    }

    function eraseMessage() {
        if (charIndex > 0) {
            typingText.textContent = messages[index].substring(0, charIndex - 1);
            charIndex--;
            setTimeout(eraseMessage, erasingSpeed);
        } else {
            index = (index + 1) % messages.length;
            setTimeout(typeMessage, typingSpeed);
        }
    }

    typeMessage();
});