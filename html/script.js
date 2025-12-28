window.addEventListener("message", function (event) {
    if (event.data.action === "show") {
        document.getElementById("title").innerText = event.data.title;
        document.getElementById("subtitle").innerText = event.data.subtitle;
        document.getElementById("message").innerText = event.data.message;

        const zta = document.getElementById("zta");
        zta.style.display = "flex";

        setTimeout(() => {
            zta.style.display = "none";
        }, 7000);
    }
});
