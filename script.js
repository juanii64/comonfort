const TOTAL_SNOWFLAKES = 10;

    function createSnowflake() {
        const snowflake = document.createElementNS("http://www.w3.org/2000/svg", "svg");
        snowflake.setAttribute("class", "snowflake");
        snowflake.setAttribute("width", "20");
        snowflake.setAttribute("height", "20");
        snowflake.setAttribute("viewBox", "0 0 24 24");

        // Posición y animación aleatorias
        snowflake.style.left = Math.random() * 100 + "vw";
        snowflake.style.animationDuration = Math.random() * 5 + 5 + "s"; 
        snowflake.style.animationDelay = Math.random() * 5 + "s"; 

        // SVG del copo de nieve
        snowflake.innerHTML = `
            <path fill="white" d="M12 2L13 8H17L14 10L15 16L12 14L9 16L10 10L7 8H11L12 2Z"/>
        `;

        document.body.appendChild(snowflake);

        // Eliminar después de que termine la animación
        snowflake.addEventListener("animationend", () => {
            snowflake.remove();
            createSnowflake(); // Crear un nuevo copo
        });
    }

    // Crear copos de nieve
    for (let i = 0; i < TOTAL_SNOWFLAKES; i++) {
        setTimeout(createSnowflake, i * 200);
    }